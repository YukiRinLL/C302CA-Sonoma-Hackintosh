# 04 — OpenCore 配置说明

- OpenCore：**1.0.8 DEBUG**（带 ocvalidate，方便安装期排错）
- 配置由 [`tools/build_config.py`](../tools/build_config.py) 基于官方
  Sample.plist 生成，`ocvalidate` 校验 No issues；
- 成品在 [`EFI/EFI/OC/config.plist`](../EFI/EFI/OC/config.plist)（**已脱敏**，
  序列号为占位符，必须自行生成）。

## 1. Kernel/Add（15 条，顺序即依赖顺序）

```
Lilu
VirtualSMC
WhateverGreen
USBMap                      (codeless，只有 Info.plist)
EmeraldSDHC                 (本仓库的 enableMSI 补丁版，见 docs/02)
VoodooI2CServices           (VoodooI2C.kext/Contents/PlugIns/)
VoodooGPIO                  (同上)
VoodooInput                 (同上，1.1.6 统一输入框架)
VoodooI2C
VoodooI2CELAN
VoodooPS2Controller
VoodooPS2Keyboard
VoodooPS2Mouse
VoodooPS2Trackpad
AirportItlwm                (2.3.0，Sonoma 14.4 构建)
```

关键教训：**OC prelink 不会自动注入 kext 包内的 PlugIns**（官方
Configuration.pdf Note 3）。VoodooI2C 的 3 个插件必须各自单列且排在
VoodooI2C 之前；VoodooPS2 的 3 个插件必须排在 VoodooPS2Controller 之后。
最初只列顶层 kext，导致键盘、触摸板全无反应。

Kernel/Block（Disable 策略）：

- `com.apple.driver.AppleIntelLpssI2C`
- `com.apple.driver.AppleIntelLpssI2CController`

屏蔽苹果原生 SerialIO I2C，把 9d60/9d61 让给 VoodooI2C（与
SSDT-DISABLE-I2C 配合）。

## 2. 核显仿冒（DeviceProperties）

Sonoma/Ventura 起苹果删除了 Skylake 核显驱动，HD515(0x191E) 必须用
Kaby/Amber Lake 人格 + WhateverGreen 1.7.x 驱动。对齐同机型成功案例
（Sonoma 14.7.4 实拍，SMBIOS MacBookPro15,1）：

`PciRoot(0x0)/Pci(0x2,0x0)`：

| 键 | 值 | 说明 |
|---|---|---|
| AAPL,ig-platform-id | `0000C087` | 即工具显示的 0x87C00000，MacBookAir8,1 原配人格，带内建 eDP，1920x1080 免端口补丁 |
| device-id | `C0870000` | 仿冒 Amber Lake-Y UHD617 |
| model | Intel HD Graphics 515 | "关于本机"仍显示真实型号 |
| framebuffer-patch-enable | `01000000` | 启用帧缓冲补丁 |
| framebuffer-stolenmem | `00003001` | 32MB（coreboot DVMT 仅 32MB） |
| framebuffer-fbmem | `00009000` | 9MB 帧缓冲（Dortania 低 DVMT 标准组合） |

## 3. Booter / Kernel / UEFI Quirks 要点

Booter：

- `AvoidRuntimeDefrag=true`、`ProvideCustomSlide=true`、
  `EnableSafeModeSlide=true`；
- `RebuildAppleMemoryMap=true`、`SetupVirtualMap=true`、
  `SyncRuntimePermissions=true`；
- **`DevirtualiseMmio=false`**：chrultrabook 官方唯一硬性项，否则 NVRAM/
  运行时服务异常；
- **`ProtectMemoryRegions=true`**：保护固件 MMIO 不被内核回收（XHCI
  寄存器在该区；注释认为关闭会导致 USB 控制器消失，但实测 XHCI 仍消失，
  见 [05](05-status-and-troubleshooting.md)）。

Kernel：

- `AppleCpuPmCfgLock=true`、`AppleXcpmCfgLock=true`；
- `DisableIoMapper=true`（VT-d 让位）；
- `PanicNoKextDump=true`、`PowerTimeoutKernelPanic=true`；
- `ThirdPartyDrives=true`；
- **`XhciPortLimit=false`**：Sonoma 上该 Quirk 已损坏，端口靠 USBMap
  精确映射，绝不能开。

UEFI：

- Drivers：OpenRuntime（APFS JumpStart + NVRAM）、OpenHfsPlus、
  ResetNvramEntry（选择器里的重置 NVRAM 项）；
- **`DisableSecurityPolicy=true`**：MrChromebox 新版固件默认安全策略
  拒载第三方 UEFI 驱动，必须关；
- `RequestBootVarRouting=true`、APFS `EnableJumpstart=true`、
  `ProvideConsoleGop=true`。

## 4. NVRAM / 安全 / 调试

- `boot-args = -v keepsyms=1 debug=0x144`（啰嗦模式 + 保留符号 + 内核
  调试位，安装期排错；装稳后可精简为 `-v` 或清空）；
- `csr-active-config = 00000000`（SIP 全关，安装期需要）；
- `SecureBootModel=Disabled`、`ScanPolicy=0`（不限制扫描）；
- `Vault=Optional`；
- `Misc/Debug/Target=67`：控制台 + 文件日志，U 盘根目录产生
  `opencore-*.txt`，是无屏幕截图时最重要的取证来源；`ApplePanic=true`、
  `DisableWatchDog=true`；
- `Misc/Boot/HideAuxiliary=false`：**恢复 U 盘必须**。DMG 恢复项
  （com.apple.recovery.boot）在 OC 内部固定归类为 APPLE_RECOVERY，
  HideAuxiliary=true 时会被 BootEntryManagement 直接丢弃，选择器只剩
  自引导的 "EFI (external)"；
- `ShowPicker=true`、Timeout=15。

## 5. PlatformInfo（仓库内已占位）

`MacBookPro15,1`（Board `Mac-937A206F2EE63C01`，Kaby Lake 仿冒路径，
与同机型成功案例一致）。需要自行填写：

- `SystemSerialNumber`、`MLB`：用 macserial 生成；
- `SystemUUID`：随机 UUID；
- `ROM`：本机无线网卡 MAC（6 字节）。

仓库中这四个字段分别为 `REPLACE_WITH_YOUR_SERIAL`、
`REPLACE_WITH_YOUR_MLB`、全零 UUID、`112233445566`。

## 6. USB 端口映射（USBMap.kext，codeless）

针对 CAVE-XHC 人格：

- IOProviderClass=`AppleUSBXHCIPCI`，IONameMatch=`[XHC, XHCI]`；
- `port-count=0x0A`（10），仅映射 HS01–HS10，UsbConnector=0（USB2 内置/
  Type-C 口在 HS 对），`kUSMuxEnabled=true`；
- DSDT 实际声明了 18 个口（HS01–HS10、USR1/USR2、SS01–SS06），当前只
  映射 HS01–HS10 是安装期最小集，**也可能是 XHCI 不出现的嫌疑之一**，
  待排查（见 [05](05-status-and-troubleshooting.md)）。
