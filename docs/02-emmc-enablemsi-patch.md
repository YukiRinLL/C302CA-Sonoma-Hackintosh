# 02 — 核心研究：为 EmeraldSDHC 注入 enableMSI 调用

本文记录归档中最有价值的部分：为什么板载 eMMC 在 macOS 下没有中断，为什么
ACPI 补救失败，以及如何通过对 EmeraldSDHC.kext 二进制打补丁彻底解决。

所有分析脚本在 [`tools/macho/`](../tools/macho)，原/补丁二进制在
[`research/emerald-sdhc/binaries/`](../research/emerald-sdhc)，源码副本在
[`research/emerald-sdhc/source/`](../research/emerald-sdhc/source)。

---

## 1. 症状（ioreg 铁证）

在恢复环境中：

- `diskutil list` 只有 disk0（3.2GB 恢复 HFS）和若干内存盘，**没有 32GB eMMC**；
- `ioreg -l` 中 eMMC 设备 `_SB.PCI0.EMMC`（`EMMC@1E,4`，`_ADR=0x001E0004`）：

  ```
  IOInterruptSpecifiers = ()
  IOInterruptControllers = ()
  ```

  即 IOPCIDevice 拿不到任何中断；
- EmeraldSDHC 驱动**确实加载了**，但它的整个 IOResources 子树
  （EmeraldSDHC → Slot01 → BlockStorageDevice）挂在 **`SDXC@1E,6`** 下——
  那是本机空着的 SD 卡槽，它有正常的 GSI23 中断。

## 2. 根因链

### 2.1 驱动侧

EmeraldSDHC 的匹配人格用 IOPCIClassMatch：

```
0x080500 0x080501
```

即匹配所有 SDHCI 类控制器，不挑设备 ID，所以 9d2b（eMMC）和 9d2d（SDXC）
都会被匹配。其 `EmeraldSDHC::start()`（`EmeraldSDHC.cpp`）在 super::start
成功后创建工作循环，然后调用：

```cpp
IOInterruptEventSource::interruptEventSource(this, action, provider, 0)
```

它向 provider（IOPCIDevice）要 **0 号中断源**。该方法依赖 IOKit 传统 INTx
中断注册。provider 没有 INTx 时返回失败，`start()` 直接判定失败退出。
于是 eMMC 上的实例启动失败；而同一驱动在有 GSI23 的 SDXC 上启动成功——
驱动被空槽"吸走"。

通读 EmeraldSDHC 源码确认：**它从不调用 `IOPCIDevice::enableMSI()`**，
只有传统 INTx 一条路。

### 2.2 固件侧

Skylake SCS 支持 MSI 和传统 INTx。在 MrChromebox/coreboot 固件下：

- eMMC(9d2b) PCI 配置空间 **Interrupt Pin 寄存器（offset 0x3D）= 0**，即没有
  路由任何 INTA-INTD 引脚。ChromeOS/Linux 驱动直接走 MSI；
- DSDT 的 `_PRT`（PICP 包）只给 `0x1EFFFF`（设备 1e.0–1e.3）映射 INTA-INTD 到
  GSI 0x14–0x17；eMMC 是 1e.4、SDXC 是 1e.6，均不在表内。实测 SDXC 拿到
  GSI23 是固件/内核其它路径的结果，eMMC 则什么都没有；
- DSDT 中 EMMC 设备**既无 `_CRS` 也无 `_PRS`**，只有一个特殊的 `_PS0`
  上电序列（PMC 0xC0/0x0600 寄存器操作）。

### 2.3 为什么 SSDT 注入中断无效（重要弯路）

第一反应是写 SSDT 给 EMMC 补 `_CRS`（64 位 MMIO + `Interrupt(){0x16}`，
GSI22，对应 INTC 引脚，BAR 地址在运行时从 PCI 配置空间动态读取）。源码见
[`research/ssdt/SSDT-EMMC.dsl`](../research/ssdt/SSDT-EMMC.dsl)。

编译、部署、重启后 ioreg 中断仍为空。结论：

> **macOS 对 PCI 设备的中断分配，只认 PCI 配置空间的 Interrupt Pin/Line
> 寄存器配合 DSDT `_PRT` 路由；设备对象的 `_CRS` Interrupt 资源会被忽略。**

`_CRS` 在 macOS PCI 枚举里不参与中断建模。要让设备有中断，要么硬件/固件有
INTx 引脚且 `_PRT` 有映射，要么驱动显式申请 MSI。此路不通，SSDT-EMMC
保留在配置中但不产生实际作用（无害）。

## 3. 方案：补丁二进制调用 enableMSI

正解是在 EmeraldSDHC 的 `start()` 中、调用 `interruptEventSource` **之前**，
对 provider 先执行一次 `IOPCIDevice::enableMSI()`，让 IOPCIFamily 为 9d2b
分配 MSI 向量。之后 IOKit 的中断注册即可基于该 MSI 成功。

`enableMSI` 的 xnu 原型（IOPCIDevice.h）：

```cpp
virtual IOReturn enableMSI(unsigned int *maxMSIIndex,
                           void *maxMSIVectorOrIndex,
                           UInt8 interruptSource = 0);
```

本补丁以 `enableMSI(&one, NULL, 0)` 调用（申请 1 个 MSI 向量）。
其 Itanium C++ mangled 名推断为：

```
__ZN12IOPCIDevice9enableMSIEPjPvh
```

> 注：`unsigned int*` → `Pj`，`void*` → `Pv`，`unsigned char` → `h`。
> 若某代 IOPCIFamily 的第二参数按 `unsigned long*` 导出，符号会是
> `...EPyPvh`，prelink 会报未定义符号，改这一处重打即可。

## 4. Mach-O 二进制结构分析

目标文件：EmeraldSDHC 0.1.2 RELEASE，78144 字节，**单架构 x86_64 薄
Mach-O**（非 FAT），`filetype=11 (MH_BUNDLE)`，flags=0x85。

这是经典内核 kext 链接格式：

- **没有 LC_DYLD_INFO / bind opcode**，外部符号绑定完全靠 `LC_SYMTAB`
  的 nlist + 各节重定位表，在内核 prelink/kpstart 阶段由链接器处理；
- 三个段：

  | 段 | vmaddr | vmsize | fileoff |
  |---|---|---|---|
  | `__TEXT` | 0x0 | 0x6000 | 0x0 |
  | `__DATA` | 0x6000 | 0x3000 | 0x6000 |
  | `__LINKEDIT` | 0x9000 | 0xa140 | 0x9000 |

- `__TEXT,__text`：addr/off=0x760，size=0x461a；
- `LC_SYMTAB`：symoff=0x9320，523 个符号；stroff=0xd6d8；
- `LC_DYSYMTAB`：145 个定义符号 + 378 个未定义符号；**external 重定位表
  0xb3d0，共 1121 条**；local 重定位 0x9000 共 100 条；indirect 表为空；
- **没有 LC_CODE_SIGNATURE**（内核 kext 惯例），因此扩展文件不会破坏签名，
  也无需 ldid。

### 4.1 x86_64 重定位约定（实测）

分析现有 1121 条重定位后确认：

- `r_info` 位域：bits 0–23 = 符号索引；bit24 = r_pcrel；bits25–26 = r_length
  （2 表示 4 字节）；bit27 = r_extern；bits28–31 = r_type；
- `r_address` 是**镜像内绝对虚拟地址**（不是节内偏移），且对于
  `R_X86_64_BRANCH(type=2)/GOT/SIGNED` 类 pc-relative 项，指向的是
  **disp32 字段本身**（即 call 操作码 e8 的下一字节），不是指令首字节；
- 例如 `interruptEventSource` 的调用点 0x473f `e8 00000000`，其重定位项
  `r_address=0x4740, type=2, pcrel=1, len=2, extern=1, symbol=279`。

### 4.2 start() 插入点

反汇编 start（符号 `__ZN11EmeraldSDHC5startEP9IOService`，value=0x46a4）：

```
0x471c  call qword [rax+0x20]      ; getWorkLoop()
0x4724  mov [r15+0x98], rax        ; this->workLoop
0x472b  test rax,rax / je fail
0x4730  lea  rsi, [rip+0x1cb]      ; 中断源名称串 -> 0x4902   (7 字节)
0x4737  mov rdi, r15
0x473a  mov rdx, r14               ; provider
0x473d  xor ecx, ecx
0x473f  call interruptEventSource  ; ← 失败点
```

在 0x4730 处把原 7 字节 `lea` 替换为 `jmp cave; nop; nop`，原指令移入
cave 末尾原样执行，再跳回 0x4737。此时 `r14=provider`（IOPCIDevice），
是 enableMSI 的 this。

## 5. 补丁布局（78144 → 94528 字节）

文件扩展 0x4000，`__LINKEDIT` 的 vmsize/filesize 改为 0xd140（覆盖到
0x16140；新数据实际只用到 0x15522）：

| 文件偏移 | 内容 |
|---|---|
| 0xb3d0 | 原 external reloc 表起点；表搬走后，这里作为**新 nlist[523]** 的位置（恰为 symtab 523*16 的自然末尾） |
| 0x13140 | **搬迁后的 external 重定位表**（原 1121 条逐字节复制，共 0x2308 字节）+ 追加的 1 条新重定位 |
| 0x15500 | 新字符串 `__ZN12IOPCIDevice9enableMSIEPjPvh\0`（strtab 尾部延伸） |
| 0x16000 | 新段 `__MSI` 的 `__cave` 节代码（页对齐；vmaddr 0x17000） |

新增 load command：`LC_SEGMENT_64 __MSI`，vmaddr=0x17000，fileoff=0x16000，
maxprot=initprot=5（r-x），含一个节 `__cave`
（flags `S_ATTR_PURE_INSTRUCTIONS|SOME_INSTRUCTIONS`）。

头部更新：

- `LC_SEGMENT_64 __LINKEDIT`：vmsize/filesize += 0x4000；
- `LC_SYMTAB`：nsyms 523→524，strsize 延伸到新字符串末尾；
- `LC_DYSYMTAB`：nundefsym 378→379，extreloff=0x13140，nextrel 1121→1122；
- Mach-O header：ncmds 6→7，sizeofcmds += 152。

新符号表项：`n_strx` 指向新字符串，`n_type=0x01 (N_UNDF|N_EXT)`，
n_sect=0，n_value=0——标准未定义外部符号，prelink 时由内核链接器解析到
IOPCIDevice。

新增重定位项：

```
r_address = 0x17021              ; cave 内 call 的 disp32 字段地址
r_info    = sym=523
          | r_pcrel=1 (bit24)
          | r_length=2 (bits25-26)
          | r_extern=1 (bit27)
          | r_type=2  R_X86_64_BRANCH (bits28-31)
```

### 5.1 cave 代码（共 0x37 字节）

进入时 `r14=provider`，内核调用约定下 rsp≡0 mod16，因此先保存 r14 并重对齐：

```asm
0x17000  push r14
0x17002  and  rsp, -0x10
0x17006  sub  rsp, 0x20
0x1700a  mov  dword [rsp+0x10], 1     ; maxMSIIndex = 1
0x17012  mov  rdi, [rsp+0x28]         ; this = provider（保存的 r14）
0x17017  lea  rsi, [rsp+0x10]         ; &maxMSIIndex
0x1701c  xor  edx, edx                ; maxMSIVectorOrIndex = NULL
0x1701e  xor  ecx, ecx                ; interruptSource = 0
0x17020  call enableMSI               ; ↖ 新 BRANCH 重定位绑定符号 523
0x17025  add  rsp, 0x28
0x17029  pop  r14
0x1702b  lea  rsi, [rip -> 0x4902]    ; 复刻原 0x4730 的指令
0x17032  jmp  0x4737                  ; 回到原流程
```

__text 补丁点：

```asm
0x4730  jmp 0x17000   ; e9 xx xx xx xx
0x4735  nop
0x4736  nop
```

## 6. 复现方法

依赖：Python 3 + [capstone](https://www.capstone-engine.org/)（仅反汇编校验用）。
脚本目录 [`tools/macho/`](../tools/macho)：

| 脚本 | 作用 |
|---|---|
| `analyze_macho.py` | 解析 Mach-O 头、段/节、符号表，定位 start() |
| `disasm_start.py` | capstone 反汇编 start()，找插入点 |
| `map_linkedit.py` | 列出 LINKEDIT 内 nlist/strtab/重定位表布局与间隙 |
| `check_relocs.py` / `recheck_orig.py` | 核对重定位 r_address 约定与原始指令 |
| `patch_em_msi.py` | **执行补丁**（自动从 `.012.bak` 生成，幂等） |
| `verify_patch.py` | 校验补丁后段表/符号/重定位/反汇编 |

注意脚本中的路径硬编码为研究机路径，移植时改 `SRC`/`BAK` 常量。
补丁脚本每次都从备份 `EmeraldSDHC.012.bak` 重新生成，可反复运行。

补丁后的 kext 需要重新放回 EFI：

```
EFI/OC/Kexts/EmeraldSDHC.kext/Contents/MacOS/EmeraldSDHC
```

部署后用 ocvalidate 校验 config，并核对拷贝 MD5。

## 7. 真机验证方法

在恢复环境终端：

```
diskutil list
ioreg -n EmeraldSDHC -r -w0
```

成功判据：

1. `diskutil list` 出现约 29–31GB 的内置物理盘；
2. EmeraldSDHC 实例挂在 `EMMC@1E,4` 而不是 `SDXC@1E,6`；
3. eMMC 的 IOPCIDevice 节点 `IOInterruptSpecifiers` 非空（MSI 向量）。

失败分支：

- OpenCore 开机 prelink 阶段报 enableMSI 未定义符号：第二参数 mangling
  不符，把符号名改为 `__ZN12IOPCIDevice9enableMSIEPyPvh` 重打；
- 驱动仍在但无中断：检查 enableMSI 返回值（可在 cave 中加 IOLog，
  需要额外字符串与符号，后续迭代）；
- 完全无 EmeraldSDHC：核对 kext 路径、Info.plist 与 prelink 日志。

## 8. 后续可改进

- 目前 cave 丢弃了 enableMSI 的返回值；可在补丁版增加一条 IOLog 打印
  返回码，方便真机确认；
- 更彻底的做法是拿到 EmeraldSDHC 源码后直接在 `start()` 加 enableMSI
  并用 XNU 工具链编译，二进制补丁只是无工具链环境下的替代手段；
- MSI 多向量/电源管理（D3 唤醒后 MSI 可能需要重新 enable）尚需长期验证。
