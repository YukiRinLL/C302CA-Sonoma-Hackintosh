# 07 — 研究过程时间线与决策记录

本文按时间顺序记录本项目走过的路、每个阶段的证据，以及哪些尝试失败、为什么
转向。目的是让归档不仅保存"最终配置"，也保存完整的研究过程。对应材料分别
归档在 `research/process/`、`research/logs/`、`research/legacy-stage/`、
`upstream/releases-legacy/`。

## 阶段 0：Windows 造盘与早期 Mojave 尝试

- 使用 gibMacOS（`tools/gibMacOS/`，下载日志 `research/process/logs/download.log`）
  在 Windows 上拉取安装器。最早拉取的是 **macOS Mojave 10.14.6** 一套内容
  （`research/installer-metadata/InstallInfo.plist` 内版本串
  `10.14.6.0.0.1569030045` 为证；对应原始大文件未入 git，见
  [08](08-archive-manifest.md)）。
- 在 Windows 上用 diskpart / dd 组合把镜像写到 U盘并重建 HFS+ 分区：
  脚本在 `research/process/windows-scripts/`（`run_dd.ps1`、`run_dp.ps1`、
  `run_mi.ps1`、`run_readback.ps1`、`run_verify.ps1`、
  `hfsimg` 系 `rebuild_usb.ps1` / `verify_*.ps1`），日志与阶段标记在
  `research/process/logs/`、`research/process/stage/`（含 3072 字节的
  U盘扇区头转储 `hdr.bin` 和各 `-stage.txt` 进度文件）。
- 教训（Windows 侧）：非提权 PowerShell 跑 diskpart stdout 丢失，改用
  `New-Partition`/`Format-Volume`；dd 写盘必须精确传参数
  （`dd-read-args.txt`）；写后回读校验（`run_readback.ps1`）。
- 最终 U盘方案定型为双分区：2.9GB FAT32 RECOVERY（EFI +
  com.apple.recovery.boot）+ 55.7GB exFAT TARGET。

## 阶段 1：OpenCore 0.9.7 第一代 EFI

材料：`upstream/releases-legacy/`（OC 0.9.7 DEBUG/RELEASE、Lilu 1.6.7、
VirtualSMC 1.3.2、WEG 1.6.7、VoodooI2C 2.8、VoodooPS2 2.3.7、
AppleALC 1.8.8、**AirportItlwm 的 Mojave 构建** 2.3.0、
IntelBluetoothFirmware 2.1.0）和 `research/legacy-stage/`
（当时的 `build_config-oc097.py`、`build_usbmap.py`、`config-oc097.plist`）。

该阶段完成了 U盘引导和 USB 端口人格（CAVE-XHC）的雏形，但输入设备与
新系统兼容性问题促使升级。

## 阶段 2：转向 Sonoma + OpenCore 1.0.8

- 目标系统确定为 **macOS Sonoma 14.x**（恢复环境实际版本见
  `upstream/releases-sonoma/vercheck/SystemVersion.plist`；AirportItlwm
  换用严格对应的 Sonoma 14.4 构建）。
- OpenCore 升 1.0.8 DEBUG，全部 kext 升级（`upstream/releases-sonoma/`
  保留了当时实际下载的全部 zip 和 GitHub API 元数据 json：
  `vi2c_rel.json`、`vps2_rel.json`、`acid_vps2.json`、`prelink_meta.json`）。
- 2026-07-17 / 07-18 的多轮启动调试日志全部保留在 `research/logs/`
  （`decoded_2026-07-17-0613*.txt` 共 5 个时间点、
  `decoded_opencore-2026-07-18-021*.txt` 2 个、`last_boot_log.txt`），
  用 `tools/inspect/decode_log.py` 系列解码。

## 阶段 3：输入设备三大坑

排查脚本保留在 `tools/inspect/`（`inspect_ps2.py`、`inspect_ps2301.py`、
`inspect_vi2c.py`、`inspect_vi2c2.py`、`inspect_elan.py`），直接解析各
kext 的 Info.plist 验证匹配人格。

1. **PlugIns 不自动注入**：最初 `Kernel/Add` 只列顶层 kext，键盘触摸板
   全无反应。读 OC Configuration.pdf Note 3 后，把 VoodooI2C 的
   VoodooI2CServices/VoodooGPIO/VoodooInput 和 VoodooPS2 的
   Keyboard/Mouse/Trackpad 全部单列并排序，解决。
2. **SerialIO I2C 超时风暴**：coreboot 暴露 6 个 I2C 控制器，空的
   I2C0/2/3/4/5 让原生 AppleIntelLpssI2C 反复超时刷屏。方案是
   SSDT-DISABLE-I2C（Darwin 下隐藏，仅留 I2C1）+ Kernel/Block 屏蔽原生
   驱动。
3. **触摸板协议误判**：先试 HID/PTP 路线（废弃稿
   `research/ssdt/SSDT-I2C-HID.dsl`、`SSDT-HS00.dsl`），读 VoodooI2C
   官方文档后确认 Chromebook 的 ELAN0000 必须用 VoodooI2CELAN 的
   Linux elan_i2c 私有协议；GSI51 超 47 自动落 polling。

阶段成果：**键盘（VoodooPS2 1Revenger1 3.0.1）、触摸板（VoodooI2CELAN）、
Wi-Fi（AirportItlwm AC-7265）、恢复环境引导全部稳定**。

## 阶段 4：核显仿冒定型

HD515(0x191E) 在 Ventura+ 无原生驱动。对齐同机型闲鱼成功案例
（Sonoma 14.7.4 实拍配置）：MacBookPro15,1 SMBIOS + ig-platform-id
`0000C087`（MBAir8,1/UHD617 人格）+ device-id `C0870000` +
stolenmem 32MB/fbmem 9MB 低 DVMT 组合。决策细节见
[04](04-opencore-configuration.md)。

## 阶段 5：板载 eMMC 无中断（核心战役）

1. 现象取证：`ioreg` 显示 EMMC@1E,4 的 `IOInterruptSpecifiers=()`，
   EmeraldSDHC 被有 GSI23 的空 SDXC@1E,6 "吸走"；`diskutil list`
   无内置盘。
2. **弯路 A：SSDT 注入 `_CRS` 中断**（SSDT-EMMC，动态读 BAR + GSI22）。
   部署后 ioreg 仍为空，确认 macOS PCI 中断只认配置空间 pin 寄存器 +
   `_PRT`，不认设备 `_CRS`。表保留在配置中（无害）作为结论证据。
3. 正解调研：读 EmeraldSDHC 源码（`research/emerald-sdhc/source/`）
   确认其只有 INTx 路径、从不调用 enableMSI；coreboot 下 9d2b 的
   INTx pin 寄存器为 0（ChromeOS/Linux 走 MSI）。
4. Mach-O 逆向：`tools/macho/` 七个脚本逐步完成结构解析
   （`analyze_macho.py`）、start() 反汇编（`disasm_start.py`）、
   LINKEDIT 布局测绘（`map_linkedit.py`）、重定位约定实测
   （`check_relocs.py`/`recheck_orig.py`）。
5. 补丁制作（2026-10-06）：`patch_em_msi.py` 新增 `__MSI` 段和
   enableMSI 符号/重定位，`verify_patch.py` 校验；原版/补丁版二进制
   与 SHA256 存于 `research/emerald-sdhc/binaries/`，技术全文
   [02](02-emmc-enablemsi-patch.md)。已部署 U盘，待真机验证。

## 阶段 6：XHCI 消失（未结案）

XHCI 9d2f 在 macOS IOService 树整个消失导致 U盘进系统后不可见。
已尝试 SSDT-XHC（堵 `_PS3`/声明 `_S3D/_S4D=0`，效果未证实，且含一个
待清理的实验性 `_DSM`）。`ProtectMemoryRegions=true` 已设无效。
下一步计划（禁用 USBMap 验证人格冲突、查电源门控）见
[05](05-status-and-troubleshooting.md)。

## 研究方法沉淀

- 证据优先级：ioreg 实拍 > OpenCore 文件日志 > 屏幕滚动照片 > 推测；
- 一次只改一个变量，每轮配置用 ocvalidate 把关、部署后回读 MD5；
- 逆向先测绘再动手：重定位 r_address 的绝对地址/disp32 约定就是靠
  统计现有 1121 条表项实测出来的，避免了按节内偏移写错；
- 所有自制脚本保留原始版本和中间分析产物，补丁脚本从备份幂等生成，
  保证任何结论可复现。
