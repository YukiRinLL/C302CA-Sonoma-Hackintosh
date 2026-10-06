# 03 — ACPI：DSDT 分析与自制 SSDT

真机 ACPI 表在 [`research/acpi-tables/`](../research/acpi-tables)
（`dsl/DSDT.dsl` 为完整反编译，`raw/` 为提取的原始 aml），自制 SSDT 源码在
[`research/ssdt/`](../research/ssdt)。编译器为 ACPICA iasl 20260408。

## 1. 提取与编译

- 在 ChromeOS/恢复环境用 `acpidump` 导出全部表，`acpixtract` 拆出 DSDT/SSDT，
  `iasl -d` 反编译；
- 编译自制表：`iasl SSDT-XXX.dsl`，产物 .aml 同目录；
- OpenCore 加载 5 个表（见 config 的 `ACPI/Add`）。

## 2. DSDT 关键证据（行号基于 research/acpi-tables/dsl/DSDT.dsl）

| 设备 | 位置 | 要点 |
|---|---|---|
| EMMC | 约 3744–3811 行 | `_ADR 0x001E0004`；特殊 `_PS0` 上电序列（PGEN=0；PCRA(0xC0,0x0600,0x7FFFFFBA)；PCRO(0xC0,0x0600,0x80000045)；PMCR&=0xFFFC）；子设备 CARD `_ADR 0x08`、`_RMV=0`；**无 _CRS/_PRS**；有 `_DSM`(UUID e5c937d0) |
| SDXC | 约 3813–3865 行 | `_ADR 0x001E0006`；不同的 `_PS0`；CARD `_RMV=1`（可移动） |
| XHCI | 约 3898–4133 行 | `_ADR 0x00140000`；`_PRW{0x6D,3}`；`_PS0` 依赖 PMC.UWAB/MPMC、D0D3(PCI 0x74)、STGE(0x50)、XMEM(BAR 高 16 位)；RHUB 下 HS01–HS10、USR1/USR2(`_ADR 0x0B/0x0C`)、SS01–SS06(`_ADR 0x0D–0x12`) |
| PICP 路由表 | 约 483–812 行 | `0x1EFFFF` pin0–3 → GSI 0x14–0x17（仅覆盖 1e.0–1e.3）；`0x14FFFF`(XHCI) pin0–3 → GSI 0x10–0x13 |
| `_PRT` | 约 1079 行 | `PICM` 模式返回 PICP 包 |

coreboot 4.20+ 还以无地址的 `Device(CPxx)` 声明 CPU 节点（Darwin 下无法识别为
处理器），这是 SSDT-PLUG-4200 要解决的问题。

## 3. 自制 SSDT 清单

| 文件 | 状态 | 作用 |
|---|---|---|
| SSDT-PLUG-4200.aml | 有效 | 隐藏 coreboot 的无地址 CPxx，重建带地址的 Processor(CPU0–3)，CPU0 注入 `plugin-type=1`，开启 XNU CPU 电源管理（4 线程） |
| SSDT-EC-USBX.aml | 有效 | 声明伪 EC（ACID0001）满足 macOS 对嵌入式控制器的预期；注入 USBX USB 供电属性。原 Google EC0 保留给电池/CrosEC |
| SSDT-DISABLE-I2C.aml | 有效（安装期） | Darwin 下把 I2C0/2/3/4/5 置 `_STA=0`，仅保留 I2C1（触摸板）。空控制器会让原生 AppleIntelLpssI2C 反复 "Timed out on input stream 1" 刷屏拖慢启动；触摸屏(I2C0)与声卡(I2C4)装完系统后再放开 |
| SSDT-EMMC.aml | **已验证无效，保留无害** | 试图向 EMMC 注入带 GSI22 的 `_CRS`，macOS 不使用 PCI 设备的 _CRS 中断资源，详见 [02](02-emmc-enablemsi-patch.md) |
| SSDT-XHC.aml | 实验中，效果未证实 | 覆盖 XHCI `_PS3` 为 no-op、`_S3D/_S4D=0`，阻止控制器被切 D3 后整个消失；含一个 `_DSM`（其中第二 UUID 为实验性注入，后续可清理只保留电源方法） |

另有两个实验/废弃表未加载，仅作为研究记录保留：`SSDT-HS00`、`SSDT-I2C-HID`
（早期尝试把触摸板按 HID 驱动的方案，后确认 ELAN0000 必须走
VoodooI2CELAN 私有协议）。

## 4. 触摸板中断说明

I2C1 上的 ELAN0000（`_ADR` 对应 D015，**GSI=51**）超过 APIC 兼容模式 47 的
上限，VoodooI2C 会自动落到 polling 模式，这正是其官方文档推荐的安装期安全
模式；装好后可再研究 GPIO 中断模式（Skylake LPSS + VoodooGPIO）。
ELAN0000 不是 HID/PTP 触摸板，不能用 VoodooI2CHID/PNP0C50 那套补丁。

## 5. iasl / ASL 踩坑记录

- **名称严格 4 字符**：`BARD0` 被当名称解析报错，改成 `BAR0`；
- **ResourceTemplate 编译期校验**：`QWordMemory` 的 Max-Min+1 必须 ≥ Length。
  需要运行时动态填地址时，模板里先放 `Min=0 Max=0xFFF Length=0x1000`，
  再用 `CreateQWordField` 在运行时改：Min 字段在 buffer 偏移 **0x0E**，
  Max 在 **0x16**（见 SSDT-EMMC.dsl）；
- **ASL 不是 C**：必须用三参数语句形式 `And(a,b,target)` / `Or(...)` /
  `ShiftLeft(a,b,target)`，不能写 `<</&/|` 表达式；
- **Package 长度**按实际元素个数填写，多写少写都会编译失败或运行异常；
- 条件判断用 `If (_OSI("Darwin")) { ... } Else { ... }` 实现平台差异化
  `_STA`，同一套表在 ChromeOS/Linux 下行为不变。

## 6. 后续 ACPI 工作

- 清理 SSDT-XHC：去掉实验性 `_DSM`，只保留 `_PS3/_S3D/_S4D`，并在
  恢复环境确认它是否真的被加载（`ioreg -lw0 -n XHC`、OC 日志 ACPI 段）；
- 装后表：SSDT-PNLF（亮度）、电池（EC 查询，配 CrosEC 或 SMC 电池补丁）、
  声卡 layout 相关 GPIO/I2C4 放开；
- 触摸屏 ELAN0001：放开 I2C0 后用 VoodooI2CHID 评估。
