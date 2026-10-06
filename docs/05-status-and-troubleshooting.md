# 05 — 当前状态与排错记录

## 1. 功能状态

| 功能 | 状态 | 说明 |
|---|---|---|
| MrChromebox UEFI 引导 OpenCore | 正常 | 1.0.8 DEBUG |
| 恢复环境引导（com.apple.recovery.boot） | 正常 | 在线拉取 Sonoma |
| 键盘 | 正常 | VoodooPS2 3.0.1（1Revenger1 fork） |
| 触摸板 | 正常 | VoodooI2CELAN 驱动 ELAN0000，I2C1 GSI51 polling |
| Wi-Fi | 正常 | AirportItlwm 2.3.0（Sonoma 14.4 构建），AC-7265 |
| 核显 | 配置完成待桌面验证 | HD515 仿冒 0x87C00000 + 低 DVMT 帧缓冲补丁 |
| 板载 eMMC | **补丁已制作，待真机验证** | 见 [02](02-emmc-enablemsi-patch.md) |
| XHCI / USB（进 macOS 后） | **异常：控制器整个消失** | 见本文第 2 节 |
| 蓝牙 | 未开始 | IntelBluetoothFirmware 2.1.0 + BlueToolFixup |
| 声卡（NAU8825） | 未开始 | AppleALC 1.9.8 已备，I2C4 目前被禁用 |
| 触摸屏 ELAN0001 | 未开始 | 需放开 I2C0 |
| CrosEC / 电池 / 功能键 / 亮度 | 未开始 | CrosEC 1.0.1 已备，SSDT-PNLF 待做 |

## 2. 悬案：XHCI 在 IOService 树中整个消失

现象：恢复环境中

```
ioreg -r -w0 -d 3 -n 'XHC@14000000'   # 空
ioreg -p IOUSB -w0                     # 只有 Root，无任何设备/端口
```

U盘（本身是 USB 盘）在 macOS 里也不可见（恢复镜像在内存中运行，所以
系统能起来，但装系统阶段无法读写 U盘/外接介质）。

已排除/已知：

- `ProtectMemoryRegions=true` 已设，XHCI 仍消失；
- SSDT-XHC（`_PS3` no-op、`_S3D/_S4D=0`）已部署但**未证实是否真正加载**；
- DSDT 的 XHCI `_PS0` 依赖复杂的 PMC 寄存器上电序列
  （UWAB/MPMC、PCI 0x74 D0D3、0x50 STGE、XMEM），怀疑 coreboot 电源/
  MMIO 窗口在 Darwin 下恢复失败，控制器被从 PCI 树注销；
- 设备名也可能不是 `XHC@14000000`，需用 `ioreg -r -w0 -d 5 -n 'XHC@14,0'`
  以及 `dmesg | grep -iE 'XHC|USB' | head -40` 交叉确认。

下一步排查顺序：

1. 恢复环境确认 SSDT-XHC 是否加载（ioreg 看方法是否被覆盖、OC 日志
   ACPI 段）；
2. **先禁用 USBMap.kext**（只 10 口 vs DSDT 18 口，人格冲突会导致
   AppleUSBXHCIPCI 匹配后无子口而整体不可见），用原生枚举验证控制器
   是否出现；
3. 确认 XHCI PCI 配置空间电源状态（D0/D3）与 MMIO BAR 是否有效；
4. 必要时参考 coreboot FADT/芯片组电源门控（STGE）资料，在 SSDT 里
   显式执行上电序列而不是只堵 `_PS3`。

## 3. 排错方法论（本项目沉淀）

- **以 ioreg 为准**：恢复环境终端里 `ioreg -l/-r/-n` 是判断设备、中断、
  驱动匹配关系的第一证据；照片拍屏时优先拍 ioreg 而不是滚动日志。
- **OpenCore 文件日志**：Target=67 时 U盘根出 `opencore-*.txt`。DEBUG
  日志含 kext 加载/prelink/ACPI 全过程；用 `tools/inspect/decode_log.py`
  解码（样本在 `research/logs/`）。
- **一次只改一个变量**：SSDT 注入中断与 eMMC 二进制补丁不同时上，
  才能归因。
- **恢复环境不自动挂载 U盘**，需 `diskutil mountDisk`；输命令注意空格，
  诊断命令尽量短。
- 关键判别命令：

  ```
  diskutil list                                   # 块设备全景
  ioreg -n EmeraldSDHC -r -w0                     # 驱动挂在哪、有无中断
  ioreg -l -p IODeviceTree | grep -i <name>      # ACPI/设备树
  ioreg -rc IOPCIDevice -w0 | grep -A20 1e       # PCI 设备属性
  ```

## 4. 安装阶段注意

- **全程插电**。老电池在 CPU/eMMC 峰值电流时会硬断电，安装中断风险极高。
- 抹盘时在磁盘工具选"显示所有设备"，抹**顶层物理 eMMC**（不是子卷）：
  GUID 分区图 + APFS，名称 Macintosh HD。
- 32GB 容量紧张：安装器在恢复模式下通过网络展开，系统盘占用约 15–20GB，
  装完优先清理安装缓存；若实在不够，回退方案是 U盘 G: TARGET 55.7GB
  （该路径已验证走到抹盘步骤；闲鱼同机型 Sonoma 14.7.4 案例最终也是
  跑外接 USB 盘、板载空着，可作旁证）。
- 装完后把 U盘 EFI 复制到板载 ESP 脱 U盘引导，再逐步加蓝牙/声卡/触屏/
  电池/亮度。

## 5. Windows 侧操作备忘

- PowerShell 非交互单段命令不支持 `&&`，用 `;` 串联；
- robocopy 退出码 1 表示"有文件复制成功"，不是错误；≥8 才是错误；
- 非提权 PowerShell 跑 diskpart 会丢 stdout；操作 U盘分区用
  `New-Partition` / `Format-Volume` 等 cmdlet 更稳；
- ocvalidate 用法：`ocvalidate.exe <config.plist 完整路径>`；
- 文件部署后必须回读 MD5 确认（FAT32 U盘偶发缓存未落盘）。
