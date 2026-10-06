# ASUS Chromebook Flip C302CA — macOS Sonoma Hackintosh

ASUS Chromebook Flip C302CA（主板代号 **CAVE**，Intel m3-6Y30 Skylake-Y）上安装
macOS Sonoma 的研究归档。本机已刷 [MrChromebox UEFI Full ROM](https://mrchromebox.tech/)。

本仓库的核心研究成果是：**对 acidanthera EmeraldSDHC.kext 做二进制补丁，
在驱动 `start()` 中注入一次 `IOPCIDevice::enableMSI()` 调用**，解决 coreboot
固件下板载 eMMC 控制器（Skylake SCS 9d2b）没有 INTx 中断引脚、驱动无法在 eMMC
上启动的问题。技术细节见 [docs/02-emmc-enablemsi-patch.md](docs/02-emmc-enablemsi-patch.md)。

> 状态提示：本仓库是**研究进行中**的归档。键盘、触摸板、Wi-Fi、显卡加速、
> 恢复环境引导已工作；eMMC 补丁已制作完成待真机最终验证；XHCI/USB 在 macOS
> 中消失的问题尚未解决。详见 [docs/05-status-and-troubleshooting.md](docs/05-status-and-troubleshooting.md)。

---

## 硬件

| 项目 | 规格 |
|---|---|
| 机型 | ASUS Chromebook Flip C302CA（CAVE） |
| CPU | Intel Core m3-6Y30（Skylake-Y，2C4T，PLUG 4200） |
| 核显 | Intel HD Graphics 515（PCI ID 0x191E，32MB DVMT） |
| 内存 | 8GB LPDDR3（板载） |
| 存储 | 32GB 板载 eMMC（Skylake SCS，PCI 9d2b，SDHCI 080500） |
| 读卡器 | SDXC（PCI 9d2d，本机为空槽） |
| 无线 | Intel Wireless-AC 7265（Wi-Fi + 蓝牙） |
| 触摸板 | ELAN0000（I2C1 @ GSI51，Linux elan_i2c 私有协议） |
| 触摸屏 | ELAN0001（I2C0，装系统后调） |
| 声卡 | NAU8825（I2C4，装系统后调） |
| 固件 | MrChromebox coreboot UEFI Full ROM |

## 目录结构

```
.
├── EFI/                         # 可直接部署的 OpenCore 1.0.8 EFI（config 已脱敏）
│   └── EFI/BOOT, OC/
├── docs/
│   ├── 01-hardware-and-firmware.md      # 硬件与固件、启动介质方案
│   ├── 02-emmc-enablemsi-patch.md       # 【核心】eMMC 无中断根因与二进制补丁
│   ├── 03-acpi-ssdt.md                  # DSDT 分析、自制 SSDT、失败的弯路
│   ├── 04-opencore-configuration.md     # config.plist 决策与 kext 清单
│   ├── 05-status-and-troubleshooting.md # 当前状态与排错记录
│   ├── 06-third-party-components.md     # 第三方组件版本/来源/许可证
│   ├── 07-research-process-timeline.md  # 完整研究过程：Mojave→Sonoma 各阶段决策
│   └── 08-archive-manifest.md           # 归档清单、未收录大文件的哈希与重取方法
├── upstream/
│   ├── releases-sonoma/         # 实际下载的 kext/OC 发行 zip + 下载元数据
│   ├── releases-legacy/         # OC 0.9.7/Mojave 期旧版本 zip
│   └── sources/                 # OpenCore/VoodooI2C/ELAN 源码包
├── research/
│   ├── acpi-tables/             # 真机 ACPI 表（DSDT.dsl 反编译 + 14 个原始 aml）
│   ├── ssdt/                    # 自制 SSDT 源与产物（含废弃实验稿）
│   ├── emerald-sdhc/            # 源码副本 + 原/补丁二进制（含 SHA256）
│   ├── logs/                    # 2026-07 多轮 OC 解码日志（已脱敏）
│   ├── photos/                  # 研究照片/屏幕截图：24 张规范命名证据图（含索引）
│   ├── reference/               # USBMap 研究材料、端口 plist、cbosx 设备树等
│   ├── process/                 # 造盘全过程：PowerShell 脚本、日志、stage 标记、扇区转储
│   ├── legacy-stage/            # OC 0.9.7 期 config 与生成脚本
│   └── installer-metadata/      # 安装器 plist/chunklist/小 pkg（大文件见 docs/08）
└── tools/
    ├── build_config.py          # 从 OC Sample.plist 生成 config.plist
    ├── macho/                   # Mach-O 解析/反汇编/补丁/校验脚本
    ├── inspect/                 # 启动日志解码、kext Info.plist 检查脚本
    ├── acpica/                  # iasl/acpidump/acpixtract 20260408
    └── gibMacOS/                # 安装器下载工具（上游镜像）
```

归档边界（哪些 Apple 大文件和上游解压树没有收录、如何核验/重取）见
[docs/08-archive-manifest.md](docs/08-archive-manifest.md)；
从 Mojave 尝试到 enableMSI 补丁的完整研究脉络见
[docs/07-research-process-timeline.md](docs/07-research-process-timeline.md)。

## 快速使用

1. **生成自己的 SMBIOS**。仓库内 `EFI/EFI/OC/config.plist` 的序列号等字段已替换为
   占位符（`REPLACE_WITH_YOUR_SERIAL` 等），必须用 [macserial](https://github.com/acidanthera/OpenCorePkg)
   生成 `MacBookPro15,1` 的 Serial / MLB，并自行生成 UUID、填写本机网卡 MAC（ROM）。
   也可以修改 `tools/build_config.py` 后用 Python 3 重新生成整个 config：

   ```
   python tools/build_config.py
   ```

2. 将 `EFI/` 目录内容放到 FAT32 分区（U盘或板载 ESP）的 EFI 分区根。
3. BIOS/固件中关闭安全启动相关策略（MrChromebox 新版固件默认拒绝第三方驱动，
   本配置已设置 `UEFI/Quirks/DisableSecurityPolicy=true`）。
4. 安装镜像不在仓库内（Apple 版权），用 [gibMacOS](https://github.com/corpnewt/gibMacOS)
   或 OpenCore 的 `com.apple.recovery.boot` 在线恢复方式准备，见
   [docs/01-hardware-and-firmware.md](docs/01-hardware-and-firmware.md)。

## 重要警告

- **eMMC 补丁是实验性的**，针对特定二进制（EmeraldSDHC 0.1.2 RELEASE）的文件偏移
  制作。升级 kext 后必须重新分析、重新打补丁，脚本在 `tools/macho/`。
- **不要把含真实序列号的 config.plist 传到公开仓库**。本仓库已脱敏，你自己生成后
  请勿提交。
- 本机 32GB eMMC 空间非常紧张，安装 Sonoma 需要精简，全程插电（老电池峰值电流
  可能导致硬断电）。
- 所有第三方 kext / 驱动版权归原作者，清单与许可证见
  [docs/06-third-party-components.md](docs/06-third-party-components.md)。

## 关键结论速查

- macOS 对 PCI 设备中断**只认配置空间 Interrupt Pin 寄存器 + DSDT `_PRT` 路由表**，
  往设备 `_CRS` 里注入 Interrupt 资源**无效**（已用 SSDT-EMMC 实测验证）。
- coreboot 下 Skylake SCS eMMC(9d2b) 的 INTx pin 为 0，ChromeOS/Linux 走 MSI；
  因此必须让驱动显式调用 `enableMSI()`，而不是补 ACPI。
- OpenCore prelink **不会自动注入 kext 包内 PlugIns**，VoodooI2C/VoodooPS2 的
  子插件必须在 `Kernel/Add` 中单列并遵守全局依赖顺序。
- Sonoma 上 `XhciPortLimit` 已损坏必须关闭，端口靠 codeless USBMap.kext 精确映射。
- Ventura 起苹果删除 Skylake 核显驱动，HD515 需仿冒 Kaby/Amber Lake 人格
  （ig-platform-id `0000C087`）+ WhateverGreen。
