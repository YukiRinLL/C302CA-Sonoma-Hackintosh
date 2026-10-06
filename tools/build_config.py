# -*- coding: utf-8 -*-
"""基于 OC 1.0.8 Sample.plist 生成 ASUS C302CA (m3-6Y30 Skylake-Y / HD515)
Sonoma 14 安装盘 config。

对齐同机型成功案例（Sonoma 14.7.4 实拍）：
- SMBIOS MacBookPro15,1 (Board Mac-937A206F2EE63C01)，CPU 走 Kaby Lake 仿冒
- HD515(0x191E) 仿冒为 Amber Lake-Y UHD617(0x87C0)：
    AAPL,ig-platform-id = 0000C087 (即 Hackintool 显示的 0x87C00000，
    MacBookAir8,1 原配人格，带内建 eDP 端口，内屏 1920x1080 免端口补丁)
    device-id           = C0870000
    名称仍注入 model="Intel HD Graphics 515" 保持关于本机显示真实型号
- Ventura 起苹果删除 SKL 显卡驱动，必须靠 Kaby/Amber 人格 + WEG>=1.6.1 驱动（现1.7.1）
"""
import plistlib, os

SAMPLE = r"E:\hackintosh\sonoma\extract\OpenCore-1.0.8-DEBUG\Docs\Sample.plist"
KEXTS  = r"E:\hackintosh\sonoma\EFI\EFI\OC\Kexts"
OUT    = r"E:\hackintosh\sonoma\EFI\EFI\OC\config.plist"

with open(SAMPLE, "rb") as f:
    cfg = plistlib.load(f)

# ---------- 加载顺序（先依赖后功能） ----------
# 关键：OC prelink 模式不会自动注入 kext 包内的 PlugIns（官方 Configuration
# 文档 Note 3：内嵌 Plugins 必须各自单列条目并遵守全局依赖顺序）。
# 之前只列顶层导致 VoodooPS2Keyboard 等全部未注入，键盘触摸板无反应。
# 安装期集（共15条，子插件用完整相对路径）：
#   VoodooI2C 的三个插件必须在 VoodooI2C 之前；
#   触摸板 ELAN0000(Chromebook) 用 VoodooI2CELAN(Linux elan_i2c 私有协议,
#   GSI51 polling)，不是 HID/PTP，不用 VoodooI2CHID/PNP0C50（官方README明示）；
#   VoodooPS2 三个插件必须在 VoodooPS2Controller 之后；
#   VoodooInput 1.1.6 统一由 VoodooI2C 包提供（PS2 包内旧版已删除）。
#   EmeraldSDHC 0.1.2(acidanthera)：驱动板载 32GB eMMC(Skylake SCS 9d2b,
#   PCI class 080500 标准SDHCI)，类匹配不挑设备ID，HS200。系统目标盘=板载eMMC。
# 触摸屏 ELAN0001(I2C0)/声卡/蓝牙/电池/EC 装完系统后再加。
order = [
    "Lilu.kext",
    "VirtualSMC.kext",
    "WhateverGreen.kext",
    "USBMap.kext",
    "EmeraldSDHC.kext",
    "VoodooI2C.kext/Contents/PlugIns/VoodooI2CServices.kext",
    "VoodooI2C.kext/Contents/PlugIns/VoodooGPIO.kext",
    "VoodooI2C.kext/Contents/PlugIns/VoodooInput.kext",
    "VoodooI2C.kext",
    "VoodooI2CELAN.kext",
    "VoodooPS2Controller.kext",
    "VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Keyboard.kext",
    "VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Mouse.kext",
    "VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Trackpad.kext",
    "AirportItlwm.kext",
]

def kexec(name):
    ip = os.path.join(KEXTS, name, "Contents", "Info.plist")
    with open(ip, "rb") as f:
        info = plistlib.load(f)
    exe = info.get("CFBundleExecutable")
    return ("Contents/MacOS/" + exe) if exe else ""

adds = []
for k in order:
    adds.append({
        "Arch": "Any",
        "BundlePath": k,
        "Comment": k,
        "Enabled": True,
        "MaxKernel": "",
        "MinKernel": "",
        "PlistPath": "Contents/Info.plist",
        "ExecutablePath": kexec(k),
    })
cfg["Kernel"]["Add"] = adds
# 屏蔽苹果原生 SerialIO I2C 驱动，让出 9d60/9d61 控制器给 VoodooI2C
def block(identifier, comment):
    return {"Arch": "Any", "Comment": comment, "Enabled": True,
            "Identifier": identifier, "MaxKernel": "", "MinKernel": "",
            "Strategy": "Disable"}
cfg["Kernel"]["Block"] = [
    block("com.apple.driver.AppleIntelLpssI2C",
          "Block native AppleIntelLpssI2C (conflicts with VoodooI2C)"),
    block("com.apple.driver.AppleIntelLpssI2CController",
          "Block native AppleIntelLpssI2CController (conflicts with VoodooI2C)"),
]
cfg["Kernel"]["Force"] = []
cfg["Kernel"]["Patch"] = []
cfg["Kernel"]["Emulate"]["DummyPowerManagement"] = False
cfg["Kernel"]["Emulate"]["MaxKernel"] = ""
cfg["Kernel"]["Emulate"]["MinKernel"] = ""

# ---------- Kernel Quirks (SKL 笔记本 + Sonoma) ----------
kq = cfg["Kernel"]["Quirks"]
kq["AppleCpuPmCfgLock"] = True
kq["AppleXcpmCfgLock"] = True
kq["CustomSMBIOSGuid"] = False
kq["DisableIoMapper"] = True
kq["ExternalDiskIcons"] = False
kq["LapicKernelPanic"] = False
kq["PanicNoKextDump"] = True
kq["PowerTimeoutKernelPanic"] = True
kq["ThirdPartyDrives"] = True
# Sonoma(11.3+) 下 XhciPortLimit 已损坏必须关；端口由 USBMap.kext 精确映射
# (HS01-HS10 强制 USB2.0 + kUSBMuxEnabled)，不靠该 Quirk。
kq["XhciPortLimit"] = False

# ---------- ACPI ----------
# SSDT-PLUG-4200: coreboot 4.20+ 以无地址 Device(CPxx) 声明 CPU，
# Darwin 下隐藏并重建为带地址 Processor(CPU0-3)，CPU0 注入 plugin-type=1。
# SSDT-EC-USBX: 伪 EC(ACID0001) + USB 供电属性，原 Google EC0 保留给电池。
# SSDT-DISABLE-I2C: Darwin 下禁用 I2C0/2/3/4/5（空口+声卡+触摸屏装后再开），
#                   仅保留 I2C1 触摸板控制器，消除 LPS I2C 超时风暴。
# ELAN0000 走 VoodooI2CELAN 私有协议，直接按 name 匹配，无需 PNP0C50 补丁。
cfg["ACPI"]["Add"] = [
    {"Comment": "coreboot4.20 CPU redefine + plugin-type (4 threads)",
     "Enabled": True, "Path": "SSDT-PLUG-4200.aml"},
    {"Comment": "Fake EC (ACID0001) + USBX",
     "Enabled": True, "Path": "SSDT-EC-USBX.aml"},
    {"Comment": "Disable SerialIO I2C0/2/3/4/5 in Darwin (keep I2C1 trackpad)",
     "Enabled": True, "Path": "SSDT-DISABLE-I2C.aml"},
    {"Comment": "eMMC(9d2b) inject _CRS GSI22 interrupt (coreboot leaves INTpin=0)",
     "Enabled": True, "Path": "SSDT-EMMC.aml"},
    {"Comment": "XHCI(9d2f) keep D0 (_PS3 no-op) + _S3D/_S4D=0, prevent vanish",
     "Enabled": True, "Path": "SSDT-XHC.aml"},
]
cfg["ACPI"]["Delete"] = []
cfg["ACPI"]["Patch"] = []
cfg["ACPI"]["Quirks"]["ResetLogoStatus"] = True

# ---------- Booter Quirks (coreboot/Chromebook) ----------
bq = cfg["Booter"]["Quirks"]
bq["AvoidRuntimeDefrag"] = True
# chrultrabook 官方唯一明确 config 修复项：必须 False，否则 NVRAM/运行时服务异常
bq["DevirtualiseMmio"] = False
bq["EnableSafeModeSlide"] = True
bq["EnableWriteUnprotector"] = False
# Chromebook 必开：保护固件 MMIO 不被内核回收（XHCI 寄存器在此区，
# 不开会内核接管后 USB 控制器消失 -> Still waiting for root device）
bq["ProtectMemoryRegions"] = True
bq["ProvideCustomSlide"] = True
bq["RebuildAppleMemoryMap"] = True
bq["SetupVirtualMap"] = True
bq["SyncRuntimePermissions"] = True
cfg["Booter"]["MmioWhitelist"] = []
cfg["Booter"]["Patch"] = []

# ---------- DeviceProperties: HD515 仿冒 Amber Lake-Y UHD617 ----------
# 成功案例 Hackintool 平台ID 0x87C00000 = data 0000C087（MacBookAir8,1 人格）。
# coreboot 仅给 iGPU 32MB DVMT：stolen 32MB + fbmem 9MB（Dortania 低DVMT标准补丁）。
cfg["DeviceProperties"]["Add"] = {
    "PciRoot(0x0)/Pci(0x2,0x0)": {
        "AAPL,ig-platform-id": bytes.fromhex("0000C087"),
        "device-id": bytes.fromhex("C0870000"),
        "model": "Intel HD Graphics 515",
        "framebuffer-patch-enable": bytes.fromhex("01000000"),
        "framebuffer-stolenmem": bytes.fromhex("00003001"),
        "framebuffer-fbmem": bytes.fromhex("00009000"),
    }
}
cfg["DeviceProperties"]["Delete"] = {}

# ---------- NVRAM ----------
guid = "7C436110-AB2A-4BBB-A880-FE41995C9F82"
nv = cfg["NVRAM"]["Add"][guid]
nv["boot-args"] = "-v keepsyms=1 debug=0x144"
nv["csr-active-config"] = bytes(4)
nv["prev-lang:kbd"] = b"en:25"
cfg["NVRAM"]["Delete"] = {guid: ["boot-args", "csr-active-config", "prev-lang:kbd"]}
cfg["NVRAM"]["WriteFlash"] = False

# ---------- PlatformInfo: MacBookPro15,1（对齐成功案例） ----------
cfg["PlatformInfo"]["Automatic"] = True
g = cfg["PlatformInfo"]["Generic"]
g["SystemProductName"]  = "MacBookPro15,1"
g["SystemSerialNumber"] = "REPLACE_WITH_YOUR_SERIAL"
g["MLB"]                = "REPLACE_WITH_YOUR_MLB"
g["SystemUUID"]         = "00000000-0000-0000-0000-000000000000"
g["ROM"]                = bytes.fromhex("112233445566")
g["SystemMemoryStatus"] = "Auto"
cfg["PlatformInfo"]["UpdateDataHub"] = True
cfg["PlatformInfo"]["UpdateNVRAM"] = True
cfg["PlatformInfo"]["UpdateSMBIOS"] = True
cfg["PlatformInfo"]["UpdateSMBIOSMode"] = "Create"

# ---------- Misc ----------
mb = cfg["Misc"]["Boot"]
mb["ShowPicker"] = True
mb["Timeout"] = 15
mb["PollAppleHotKeys"] = True
mb["LauncherOption"] = "Disabled"
# DMG恢复项(com.apple.recovery.boot)在OC内部一律归类为APPLE_RECOVERY，
# HideAuxiliary=True时会被直接丢弃(源码BootEntryManagement.c)，现场实测
# 导致选择器只剩自引导的"EFI (external)"。安装U盘必须默认显示恢复项。
mb["HideAuxiliary"] = False
md = cfg["Misc"]["Debug"]
md["AppleDebug"] = False
md["ApplePanic"] = True
md["DisableWatchDog"] = True
md["Target"] = 67  # 控制台+文件日志（opencore-*.txt）
md["SysReport"] = False
ms = cfg["Misc"]["Security"]
ms["ScanPolicy"] = 0
ms["SecureBootModel"] = "Disabled"
ms["Vault"] = "Optional"
ms["AllowSetDefault"] = False
ms["ExposeSensitiveData"] = 6
ms["HaltLevel"] = 2147483648
ms["AuthRestart"] = False
ms["ApECID"] = 0
cfg["Misc"]["Entries"] = []
cfg["Misc"]["Tools"] = [{
    "Arguments": "",
    "Auxiliary": True,
    "Comment": "OpenShell",
    "Enabled": True,
    "Flavour": "Auto",
    "FullNvramAccess": False,
    "Name": "OpenShell",
    "Path": "OpenShell.efi",
    "RealPath": False,
    "TextMode": False,
}]

# ---------- UEFI ----------
cfg["UEFI"]["Drivers"] = [
    {"Arguments": "", "Comment": "OpenRuntime (APFS JumpStart + NVRAM)",
     "Enabled": True, "LoadEarly": False, "HideVerbose": False,
     "Path": "OpenRuntime.efi"},
    {"Arguments": "", "Comment": "HFS+ driver",
     "Enabled": True, "LoadEarly": False, "HideVerbose": False,
     "Path": "OpenHfsPlus.efi"},
    {"Arguments": "", "Comment": "Reset NVRAM picker entry",
     "Enabled": True, "LoadEarly": False, "HideVerbose": False,
     "Path": "ResetNvramEntry.efi"},
]
cfg["UEFI"]["APFS"]["EnableJumpstart"] = True
ui = cfg["UEFI"]["Input"]
ui["KeySupport"] = True
ui["KeySupportMode"] = "Auto"
ui["TimerResolution"] = 50000
cfg["UEFI"]["Output"]["ProvideConsoleGop"] = True
uq = cfg["UEFI"]["Quirks"]
uq["ReleaseUsbOwnership"] = False
uq["RequestBootVarRouting"] = True
uq["IgnoreInvalidFlexRatio"] = False
uq["UnblockFsConnect"] = False
uq["ForceOcWriteFlash"] = False
uq["ActivateHpetSupport"] = False
# MrChromebox 新版 UEFI Full ROM 默认安全策略拒载第三方驱动，必须关闭
uq["DisableSecurityPolicy"] = True

with open(OUT, "wb") as f:
    plistlib.dump(cfg, f, fmt=plistlib.FMT_XML)
print("config.plist written:", OUT)
print("Kernel/Add entries:", len(adds))
for a in adds:
    print("  ", a["BundlePath"], "->", a["ExecutablePath"] or "(codeless)")
