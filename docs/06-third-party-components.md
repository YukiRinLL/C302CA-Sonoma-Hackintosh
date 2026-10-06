# 06 — 第三方组件版本与来源

本仓库 `EFI/` 中随附的二进制驱动版权归各自作者所有，按其上游许可证使用。
重装/升级请以下方官方仓库为准。版本为归档时（2026-10）实际使用的版本。

## OpenCore 与核心补丁

| 组件 | 版本 | 来源 | 许可证 |
|---|---|---|---|
| OpenCore | 1.0.8 DEBUG（含 OpenRuntime、ocvalidate） | https://github.com/acidanthera/OpenCorePkg | BSD-3-Clause |
| OcBinaryData（OpenHfsPlus 等） | master 快照 | https://github.com/acidanthera/OcBinaryData | 见上游 |
| Lilu | 1.7.2 RELEASE | https://github.com/acidanthera/Lilu | BSD-3-Clause |
| VirtualSMC | 1.3.8 RELEASE | https://github.com/acidanthera/VirtualSMC | BSD-3-Clause |
| WhateverGreen | 1.7.1 RELEASE | https://github.com/acidanthera/WhateverGreen | BSD-3-Clause |

## 板载设备驱动

| 组件 | 版本 | 来源 | 许可证 | 备注 |
|---|---|---|---|---|
| EmeraldSDHC | 0.1.2 RELEASE + **本仓库 enableMSI 二进制补丁** | https://github.com/acidanthera/EmeraldSDHC | 见上游（Apple 样例衍生） | 补丁说明见 [02](02-emmc-enablemsi-patch.md)，源码副本在 `research/emerald-sdhc/source/` |
| VoodooI2C（含 VoodooI2CServices/VoodooGPIO/VoodooInput） | 2.9.1 | https://github.com/VoodooI2C/VoodooI2C | BSD-2-Clause | |
| VoodooRMI/VoodooI2CELAN | 对应 2.9.x 配套 | https://github.com/VoodooI2C/VoodooI2C | BSD-2-Clause | ELAN0000 走私有协议 satellite |
| VoodooPS2Controller | 3.0.1（**1Revenger1 fork**，chrultrabook 推荐） | https://github.com/1Revenger1/VoodooPS2-Chromebook | Apache-2.0 / 见上游 | Chromebook 键盘特殊键需要该 fork |
| AirportItlwm | 2.3.0（**Sonoma 14.4 专用构建**） | https://github.com/OpenIntelWireless/itlwm | BSD-3-Clause | 大版本必须与 macOS 版本严格对应 |
| USBMap | codeless kext（自制 Info.plist） | 工具 https://github.com/corpnewt/USBMap | 见上游 | 人格 CAVE-XHC，见 [04](04-opencore-configuration.md) |

## 已下载备用、尚未启用

| 组件 | 版本 | 用途 |
|---|---|---|
| AppleALC | 1.9.8 RELEASE | NAU8825 声卡（需先放开 I2C4 并定 layout） |
| IntelBluetoothFirmware | 2.1.0 | AC-7265 蓝牙；Sonoma 还需 BlueToolFixup（Lilu 插件） |
| CrosEC | 1.0.1 RELEASE | Chrome EC（电池/功能键/热管理） |

## 工具链

| 工具 | 版本 | 来源 |
|---|---|---|
| ACPICA iasl | 20260408（Windows） | https://www.intel.com/downloads/acpica.html / https://github.com/acpica/acpica |
| Python | 3.13（+ capstone、macholib） | https://www.python.org/ / https://www.capstone-engine.org/ |
| gibMacOS | master | https://github.com/corpnewt/gibMacOS |
| macserial | OpenCorePkg Utilities 随附 | 同 OpenCore |

## 未随仓库分发的内容（版权/体积原因）

- macOS Sonoma 安装器 / BaseSystem.dmg / `com.apple.recovery.boot`：
  Apple 版权，用 gibMacOS 或 macrecovery 自行获取；
- OpenCore/VoodooI2C 完整源码树、各 kext 的 RELEASE zip：可按上表链接
  自行下载对应版本；
- EmeraldSDHC 源码以研究副本形式放在 `research/emerald-sdhc/source/`，
  版权与许可遵循上游仓库。

## 再发布提醒

若 fork 本仓库并公开再发布：

1. 保持上述版权声明，勿将第三方二进制据为己有；
2. **不要提交你自己的 SMBIOS 序列号/MLB/UUID/MAC**（本仓库已脱敏）；
3. EmeraldSDHC 补丁为修改版二进制，再发布时请同时保留本仓库的补丁说明
   与 `tools/macho/patch_em_msi.py`（提供可复现的修改方式）。
