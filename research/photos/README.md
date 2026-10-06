# 研究照片与屏幕截图

本目录统一存放研究过程中对话里用到的全部图片证据：手机拍屏、恢复环境终端、
OpenCore 开机画面、磁盘工具/ioreg 画面等，共 **24 张**，全部直接放在本目录。

## 命名规范

```
YYYY-MM-DD-NN-小写英文连字符描述.jpg
```

- 日期 = 拍摄日期（不是归档日期），`NN` 为当天序号 01/02…；
- 2026-10-05 有 6 张（01–06），2026-10-06 有 18 张（01–18）；
- 同一场景存在手机原图与微信聊天压缩版时，保留分辨率更高的手机原图
  （微信内拍摄 `wx_camera_*` 或相册 `IMG_*`）；verbose 开机屏没有手机原图，
  保留聊天版；
- 所有图片均保留原始内容，未做裁剪、压缩或涂改。

## 已删除的图片

2026-10-06 应用户要求，5 张闲鱼第三方成功案例截图（显示器设置、Hackintool
磁盘页、关于本机、Hackintool 系统页、系统信息）已彻底删除，不再在本归档留存；
当天后续照片序号已顺延重排。其证据结论（同机型 Sonoma 14.7.4 可运行、SMBIOS
选型 MacBookPro15,1）仍以文字形式保留在 docs/ 中。

归档过程中曾设 `wechat-chat/` 子目录保存 25 张微信聊天原图，同日应用户要求扁平化
移除：其中 4 张 verbose 屏与正片字节完全相同、16 张聊天压缩版在正片中有同照片的
高清手机原图、5 张闲鱼图按上条要求删除，故移除该目录无信息损失。

## 隐私说明

- 24 张照片中不含任何第三方机器标识符；本机自身的序列号/MLB/UUID/ROM 同样
  不出现在任何照片中。
- 文本类材料中的本机隐私值已按仓库根 README 的规则脱敏。

## 索引（24 张）

### A. 2026-10-05 凌晨：verbose 启动失败，卡禁止符 / Still waiting for root device

| 文件 | 时间 | 内容与证据意义 |
|---|---|---|
| `2026-10-05-01-verbose-boot-acpi-errors-still-waiting-root-device.jpg` | 02:48 | `-v` 滚动屏：ACPI Error（`_SB.PCI0.LPCB.EC0.CREC.TIMC._STR`，RE_NOT_EXIST）、EmbeddedControl region 无 handler；AirPortItlwm 1.0.1 legacy matching；多个 `pci8086,9d2d/34xx` "Failed to get acpi path / initIOProvider failed"；AppleSDHCI 日志；结尾 `Still waiting for root device` |
| `2026-10-05-02-verbose-boot-prohibition-sign-a.jpg` | 02:48 | 同一启动序列，屏幕中央出现禁止符号（圆圈斜杠），末尾 waiting for root device |
| `2026-10-05-03-verbose-boot-prohibition-sign-b.jpg` | 03:03 | 同序列另一屏，禁止符，waiting for root device |
| `2026-10-05-04-verbose-boot-prohibition-sign-c.jpg` | 03:41 | 同序列又一屏，禁止符，证明多次启动稳定复现 |

### B. 2026-10-05 晚：MacSetup 失败画面

| 文件 | 时间 | 内容与证据意义 |
|---|---|---|
| `2026-10-05-05-macsetup-error-bar-with-left-arrow.jpg` | 22:38 | 黑底苹果 MacSetup 错误图标（长条设备 + 左箭头），提示 support.apple.com/macsetup |
| `2026-10-05-06-macsetup-input-device-pairing-prompt.jpg` | 22:40 | MacSetup 鼠标/触控板配对图标（竖椭圆双竖线 + 上箭头），安装流程卡在输入设备配对 |

### C. 2026-10-06 凌晨：恢复环境与安装器界面

| 文件 | 时间 | 内容与证据意义 |
|---|---|---|
| `2026-10-06-01-recovery-time-machine-restore-screen.jpg` | 01:02 | 恢复环境 "Time Machine System Restore — Restore from Time Machine" 入口界面 |
| `2026-10-06-02-installer-select-disk-no-target.jpg` | 01:31 | Install macOS Sonoma "Select the disk where you want to install macOS"：无任何磁盘可选，Continue 灰色不可点 |
| `2026-10-06-03-disk-utility-base-system-macos-14-6-1.jpg` | 01:40 | 磁盘工具：disk0s1 为 2.87GB Disk Image Volume（Mac OS Extended），卷信息写明 **macOS 14.6.1 (23G93)**——恢复环境实际版本证据 |

### D. 2026-10-06 凌晨：恢复环境终端第一轮诊断

| 文件 | 时间 | 内容与证据意义 |
|---|---|---|
| `2026-10-06-04-terminal-diag-command-typo.jpg` | 02:20 | 诊断一行命令现场：`OUT=` 判断处漏空格，报 `[: -d: command not found` 与 `[: missing ']'`，回退路径 /Volumes/TARGET 不存在（见 docs/05 的命令拼写教训） |
| `2026-10-06-05-terminal-mountdisk-volumes-only-untitled.jpg` | 02:24 | `diskutil mountDisk disk2/3/4` 均报 mounted successfully；`ls -la /Volumes` 只见 `Untitled -> /`，U盘数据分区并未出现 |
| `2026-10-06-06-kmutil-emeraldsdhc-0-1-1-diskutil-screen1.jpg` | 02:28 | `kmutil showloaded` 中有 `fish.goldfish64.EmeraldSDHC (0.1.1)`（驱动已加载）；`diskutil list` 第 1 屏：disk0 3.2GB Apple_HFS，其余 disk1 起全是 `(disk image)` 内存盘 |
| `2026-10-06-07-diskutil-screen2-memory-disks-only.jpg` | 02:28 | `diskutil list` 第 2 屏：disk4–disk18 全部 `(disk image)`，无任何物理 eMMC/U盘 |
| `2026-10-06-08-kmutil-emeraldsdhc-0-1-2-diskutil-screen1.jpg` | 02:30 | 更换 kext 后的另一次启动：EmeraldSDHC 版本显示为 **0.1.2**，diskutil 结果不变（驱动版本对照） |
| `2026-10-06-09-ioreg-9d2b-emmc-empty-sdxc-has-gsi23.jpg` | 02:33 | `ioreg -lw0 \| grep -i -B3 -A25 9d2b`：上半 disk14–disk18 内存盘；下半 **EMMC(9d2b) 的 `IOInterruptControllers=()` 为空**，而 SDXC@1E,6 有 `IOInterruptSpecifiers=<17...>`（GSI 0x17=23）与 `io-apic-0`——eMMC 无中断的核心铁证 |
| `2026-10-06-10-ioreg-goldfish-emeraldsdhc-chain-isembedded-no.jpg` | 02:34 | `grep goldfish`：EmeraldSDHC → EmeraldSDHCSlot01(Slot=1) → EmeraldSDHCBlockStorageDevice（**IsEmbedded=No、Physical Interconnect Location=External**）→ IOBlockStorageDriver 整链，IOPCIClassMatch `0x08050000/0x08050100` 证明驱动错挂在有中断的空 SDXC(9d2d) 上 |
| `2026-10-06-11-ioreg-iousb-only-root-closeup.jpg` | 02:34 | IOBlockStorageDriver Statistics 全 0、LPCB@1F `pci8086,9d46`；`ioreg -p IOUSB -w0` 只有 Root 一项——XHCI 在 IOService 中整个消失的特写铁证 |
| `2026-10-06-12-ioreg-emeraldsdhc-chain-iousb-root-wide.jpg` | 02:35 | 同区域全景：SDXC 节点尾部 + EmeraldSDHC 驱动链 + LPCB + IOUSB 仅 Root，一屏涵盖错挂与 USB 消失两个事实 |

### E. 2026-10-06 傍晚：补丁立项前的 ioreg 复核

| 文件 | 时间 | 内容与证据意义 |
|---|---|---|
| `2026-10-06-13-ioreg-emmc-empty-interrupt-iousb-root.jpg` | 17:40 | `ioreg -p IOUSB` 仅 Root；`ioreg -r -w0 -d 6 -n 'EMMC@1E,4'` 全属性：`IOInterruptSpecifiers=()` 与 `IOInterruptControllers=()` 双空，compatible `pci8086,9d2b,pciclass,080501,EMMC`，acpi-path `\_SB_.PCI0/EMMC@1e0004` |
| `2026-10-06-14-ioreg-sdxc-interrupt-emeraldsdhc-attached.jpg` | 17:41 | 查 SDXC@1E,6：持有 GSI 0x17 中断（io-apic-0），下方挂着完整 EmeraldSDHC→Slot01→BlockStorageDevice→IOBlockStorageDriver 链，直接对比出驱动"抱错大腿" |
| `2026-10-06-15-ioreg-emeraldsdhc-chain-xhc-query-empty.jpg` | 17:41 | EmeraldSDHC 链特写后执行 `ioreg -r -w0 -d 3 -n 'XHC@14000000'`：**无任何输出直接返回提示符**，XHCI(9d2f) 消失复核 |

### F. 2026-10-06 晚：enableMSI 补丁前最后一次取证

| 文件 | 时间 | 内容与证据意义 |
|---|---|---|
| `2026-10-06-16-grep-emmc-interrupt-controllers-empty.jpg` | 19:09 | grep 过滤 `IOInterrupt|EmeraldSDHC|IOBlockStorage` 后 EMMC 节点只剩 `IOInterruptSpecifiers=()`、`IOInterruptControllers=()` 两行 |
| `2026-10-06-17-grep-emmc-empty-xhc-empty-diskutil-start.jpg` | 19:10 | 同上的 grep 输出 + XHC 查询为空 + `diskutil list` 开头仅 disk0 3.2GB 恢复盘，一屏串联三大症状 |
| `2026-10-06-18-diskutil-memory-disks-only-final.jpg` | 19:11 | `diskutil list` 收尾：disk5–disk18 全为 `(disk image)` 内存盘，坐实块设备层看不到 32GB eMMC |

## 证据与文档的对应关系

- A 组（禁止符 / waiting for root device）对应
  [../../docs/05-status-and-troubleshooting.md](../../docs/05-status-and-troubleshooting.md)
  记录的早期启动失败阶段。
- D、E、F 组的 eMMC 无中断、驱动错挂 SDXC、XHCI 消失三条证据链，是
  [../../docs/02-emmc-enablemsi-patch.md](../../docs/02-emmc-enablemsi-patch.md)
  中 enableMSI 二进制补丁立项的原始依据，时间线见
  [../../docs/07-research-process-timeline.md](../../docs/07-research-process-timeline.md)。
- SMBIOS 固定 MacBookPro15,1 / Sonoma 可行的外部佐证来自闲鱼同机型成功案例；
  其截图已应用户要求彻底删除，文字结论保留在
  [../../docs/01-hardware-and-firmware.md](../../docs/01-hardware-and-firmware.md)、
  [../../docs/04-opencore-configuration.md](../../docs/04-opencore-configuration.md)
  与 [../../docs/07-research-process-timeline.md](../../docs/07-research-process-timeline.md)。
