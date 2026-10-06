# -*- coding: utf-8 -*-
"""基于 OC 0.9.7 Sample.plist 生成 ASUS C302CA (Skylake-Y / HD515) Mojave 安装盘 config"""
import plistlib, os, copy

SAMPLE = r"E:\hackintosh\efi-build\extract\OpenCore-0.9.7-RELEASE\Docs\Sample.plist"
KEXTS  = r"E:\hackintosh\efi-build\EFI\EFI\OC\Kexts"
OUT    = r"E:\hackintosh\efi-build\EFI\EFI\OC\config.plist"

with open(SAMPLE, "rb") as f:
    cfg = plistlib.load(f)

# ---------- 加载顺序（先依赖后功能） ----------
order = [
    "Lilu.kext",
    "VirtualSMC.kext",
    "SMCBatteryManager.kext",
    "SMCProcessor.kext",
    "WhateverGreen.kext",
    "USBMap.kext",
    "AppleALC.kext",
    "VoodooI2C.kext",
    "VoodooI2CHID.kext",
    "VoodooI2CELAN.kext",
    "VoodooPS2Controller.kext",
    "AirportItlwm.kext",
    "IntelBluetoothFirmware.kext",
    "IntelBluetoothInjector.kext",
]

def kexec(name):
    ip = os.path.join(KEXTS, name, "Contents", "Info.plist")
    with open(ip, "rb") as f:
        info = plistlib.load(f)
    exe = info.get("CFBundleExecutable")
    return ("Contents/MacOS/" + exe) if exe else ""

# 安装阶段最小驱动集：先禁用 I2C触摸板/声卡/电池/CPU监测/蓝牙。
# 现象：-v 卡在 "ACPI AML tables successfully acquired and loaded" 后无panic挂起，
# VoodooI2C/VoodooGPIO 在缺少Chromebook专用GPIO配置时早期probe会阻塞IOKit。
# 装好系统后再逐个启用调试触摸板/声卡/蓝牙。
disabled_for_install = {
    "SMCBatteryManager.kext", "SMCProcessor.kext", "AppleALC.kext",
    "VoodooI2C.kext", "VoodooI2CHID.kext", "VoodooI2CELAN.kext",
    "IntelBluetoothFirmware.kext", "IntelBluetoothInjector.kext",

    # PS2键盘/WiFi 已通过对照实验排除（开关两者挂点完全相同），装机需要，保持启用。
}

adds = []
for i, k in enumerate(order):
    adds.append({
        "Arch": "Any",
        "BundlePath": k,
        "Comment": k,
        "Enabled": k not in disabled_for_install,
        "MaxKernel": "",
        "MinKernel": "",
        "PlistPath": "Contents/Info.plist",
        "ExecutablePath": kexec(k),
    })
cfg["Kernel"]["Add"] = adds
cfg["Kernel"]["Block"] = []
cfg["Kernel"]["Force"] = []
cfg["Kernel"]["Patch"] = []
cfg["Kernel"]["Emulate"]["DummyPowerManagement"] = False
cfg["Kernel"]["Emulate"]["MaxKernel"] = ""
cfg["Kernel"]["Emulate"]["MinKernel"] = ""

# ---------- Kernel Quirks (Skylake 笔记本) ----------
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
# 安装期打开端口限制解除：coreboot XHCI 暴露的 Type-C 口可能排在15个端口
# 人格之外，内核接管后U盘掉枚举 -> "Still waiting for root device"。
# Mojave(10.14)下该Quirk安全有效（仅11.3+有副作用），装好做USB映射后再关。
kq["XhciPortLimit"] = True

# ---------- ACPI ----------
# SSDT-PLUG-4200: coreboot 4.20+ 以 Device(CPxx) 无地址声明 CPU，
# macOS AppleACPICPU 无法枚举会在早期静默挂起；Darwin 下隐藏 CP00-03
# 并重建为带地址的 Processor(CPU0-3)，CPU0 注入 plugin-type=1。
# SSDT-EC-USBX: 伪 EC(ACID0001, 位于 LPCB) + USB 电源属性。
cfg["ACPI"]["Add"] = [
    {"Comment": "coreboot4.20 CPU redefine + plugin-type (4 threads)",
     "Enabled": True, "Path": "SSDT-PLUG-4200.aml"},
    {"Comment": "Fake EC (ACID0001) + USBX",
     "Enabled": True, "Path": "SSDT-EC-USBX.aml"},
    {"Comment": "Disable empty SerialIO I2C0-5 in Darwin (stop LPS I2C timeout storm)",
     "Enabled": True, "Path": "SSDT-DISABLE-I2C.aml"},
    # HS00 不再用 ACPI 伪造：改由 USBMap.kext 在 IOKit 层正规注入全部端口(含HS00)。
]
cfg["ACPI"]["Delete"] = []
cfg["ACPI"]["Patch"] = []
cfg["ACPI"]["Quirks"]["ResetLogoStatus"] = True

# ---------- Booter Quirks (Skylake) ----------
bq = cfg["Booter"]["Quirks"]
bq["AvoidRuntimeDefrag"] = True
bq["DevirtualiseMmio"] = False
bq["EnableSafeModeSlide"] = True
bq["EnableWriteUnprotector"] = False
# Chromebook/coreboot 强制项（LuluMacOS 与 chrultrabook 官方均注明必须开启）：
# 保护固件 MMIO 区不被内核回收。XHCI 寄存器位于该区，不开会导致内核接管后
# USB 控制器消失 -> "Still waiting for root device"。
bq["ProtectMemoryRegions"] = True
bq["ProvideCustomSlide"] = True
bq["RebuildAppleMemoryMap"] = True
bq["SetupVirtualMap"] = True
bq["SyncRuntimePermissions"] = True
cfg["Booter"]["MmioWhitelist"] = []
cfg["Booter"]["Patch"] = []

# ---------- DeviceProperties: HD515 核显 ----------
# coreboot(Chromebook) 默认仅给 iGPU 32MB DVMT 窃取内存，而帧缓冲 0x19160000
# 需要 34MB stolen + 21MB fbmem，不足会在 AppleKeyStore 之后的帧缓冲初始化期
# 静默挂起（无panic）。用 WEG 把 stolen 改写为 32MB、fbmem 改写为 9MB。
cfg["DeviceProperties"]["Add"] = {
    "PciRoot(0x0)/Pci(0x2,0x0)": {
        "AAPL,ig-platform-id": bytes.fromhex("00001619"),
        "framebuffer-patch-enable": bytes.fromhex("01000000"),
        "framebuffer-stolenmem": bytes.fromhex("00003001"),
        "framebuffer-fbmem": bytes.fromhex("00009000"),
    }
}
cfg["DeviceProperties"]["Delete"] = {}

# ---------- NVRAM ----------
guid = "7C436110-AB2A-4BBB-A880-FE41995C9F82"
nv = cfg["NVRAM"]["Add"][guid]
# 正式启动参数；debug=0x144 保留 panic 全量输出便于排错
# 纯电池启动会因老电池电压塌陷被 EC 硬断电，必须插原装充电器启动。
nv["boot-args"] = "-v keepsyms=1 debug=0x144"
nv["csr-active-config"] = bytes(4)
nv["prev-lang:kbd"] = b"en:25"
cfg["NVRAM"]["Delete"] = {guid: ["boot-args", "csr-active-config", "prev-lang:kbd"]}
cfg["NVRAM"]["WriteFlash"] = False

# ---------- PlatformInfo: MacBook9,1 ----------
cfg["PlatformInfo"]["Automatic"] = True
g = cfg["PlatformInfo"]["Generic"]
g["SystemProductName"]  = "MacBook9,1"
g["SystemSerialNumber"] = "C02S9BZLHDNK"
g["MLB"]                = "C02635405CDFV488C"
g["SystemUUID"]         = "A2F4D155-B2AA-48B0-A6E9-C125BEE8106A"
g["ROM"]                = bytes.fromhex("A2F4D155B2AA")
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
md = cfg["Misc"]["Debug"]
md["AppleDebug"] = False
md["ApplePanic"] = True
md["DisableWatchDog"] = True
md["Target"] = 67  # 控制台+文件日志
md["SysReport"] = True  # 转储固件ACPI表到 EFI/OC/SysReport，用于按真实DSDT制作SSDT
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
    {"Arguments": "", "Comment": "HFS+ driver", "Enabled": True, "LoadEarly": False, "Path": "HfsPlus.efi"},
    {"Arguments": "", "Comment": "OpenRuntime", "Enabled": True, "LoadEarly": False, "Path": "OpenRuntime.efi"},
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
# MrChromebox 新版 UEFI Full ROM 固件默认安全策略会拒绝 OpenCore 加载第三方驱动
# （HfsPlus.efi cannot be loaded - Invalid Parameter），必须关闭安全策略
uq["DisableSecurityPolicy"] = True

with open(OUT, "wb") as f:
    plistlib.dump(cfg, f, fmt=plistlib.FMT_XML)
print("config.plist written:", OUT)
print("Kernel/Add entries:", len(adds))
