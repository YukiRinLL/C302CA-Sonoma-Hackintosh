# 01 — 硬件、固件与启动介质

## 1. 机型背景

ASUS Chromebook Flip C302CA 是 2016 年的 12.5 寸翻转触屏 Chromebook，主板代号
**CAVE**，属于第一代 Skylake-Y Core m3 Chromebook，也是 [chrultrabook](https://chrultrabook.com/)
项目支持的机型之一。

关键配置：

| 项目 | 规格 / 说明 |
|---|---|
| CPU | Intel Core m3-6Y30，Skylake-Y，2 核 4 线程 |
| 核显 | HD Graphics 515，PCI `8086:191e`，coreboot 仅分配 32MB DVMT |
| 内存 | 8GB LPDDR3 板载 |
| eMMC | 32GB 板载，接在 Skylake SCS（Storage Control Unit）下，PCI `8086:9d2b`，标准 SDHCI 类 `080500` |
| SD 卡槽 | SCS 第二通道，PCI `8086:9d2d`，本机为空槽 |
| XHCI | Intel 9d2f（`00:14.0`） |
| Wi-Fi/蓝牙 | Intel AC-7265（Wi-Fi 走 AirportItlwm；蓝牙待调） |
| EC | Chrome EC（CrosEC 驱动装后再调） |
| 电池 | 老化严重，峰值电流可能导致整机硬断电，安装全程必须插电 |

## 2. 固件：MrChromebox UEFI Full ROM

刷写 MrChromebox 的 **UEFI Full ROM**（不是 RW_LEGACY），开机直接进 UEFI 环境，
不再走 ChromeOS 深度充电/验证流程。

注意事项：

- 新版 Full ROM 默认带安全策略，会拒绝加载第三方 UEFI 驱动，OpenCore 配置必须设
  `UEFI → Quirks → DisableSecurityPolicy = true`。
- 该固件基于 coreboot，其 ACPI 表有明显的 ChromeOS/coreboot 特征（见
  [03-acpi-ssdt.md](03-acpi-ssdt.md)）：CPU 设备以无地址 `Device(CPxx)` 声明、
  SCS 设备不给传统 INTx 资源、PCI 内存区布局与消费级主板不同。
- Booter Quirks 中 `DevirtualiseMmio` **必须为 false**（chrultrabook 官方明确项），
  否则 NVRAM/运行时服务异常；`ProtectMemoryRegions` 为 true（保护固件 MMIO 区，
  XHCI 寄存器落在该区）。

## 3. 启动介质方案演进

调试阶段使用一块 58.6GB U盘（VendorCo），在 Windows 下分两个区：

| 分区 | 文件系统 | 大小 | 内容 |
|---|---|---|---|
| F: RECOVERY | FAT32 | 2.9GB | `EFI/`（OpenCore）+ `com.apple.recovery.boot/`（在线恢复镜像） |
| G: TARGET | exFAT | 55.7GB | 预留的 macOS 安装目标（回退方案） |

最终目标是**装到板载 32GB eMMC**（本归档研究的主线）。曾经走到 U盘 TARGET 抹盘
步骤并验证可行，但明确放弃该方案，接受板载 32GB 空间紧张的风险。

安装路径：

1. OpenCore 菜单选择 `com.apple.recovery.boot` 的恢复项（`Misc → Boot →
   HideAuxiliary` 必须为 false，否则 OC 会把恢复项归类隐藏，见
   [04-opencore-configuration.md](04-opencore-configuration.md)）。
2. 恢复环境在内存盘运行，通过网络拉取 Sonoma 安装器。
3. eMMC 可见后，用磁盘工具抹**顶层物理设备**（不是子卷）为 GUID + APFS，命名
   Macintosh HD，再开始安装。
4. 装完把 U盘 EFI 复制到板载 ESP，实现脱 U盘引导。

## 4. 安装镜像获取（仓库不提供）

Apple 安装镜像有版权，仓库内不含。Windows 侧使用过的工具链：

- [gibMacOS](https://github.com/corpnewt/gibMacOS)：下载完整 InstallAssistant
  包 / BaseSystem；
- OpenCore `macrecovery`：生成 `com.apple.recovery.boot`（BaseSystem.dmg +
  chunklist），开机在线恢复；
- HFS+ 卷重建脚本与 4.hfs 等中间产物属于过程文件，未纳入归档。

版本目标：**macOS Sonoma 14.x**（AirportItlwm 使用 Sonoma 14.4 对应构建 2.3.0）。
