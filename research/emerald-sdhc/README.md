# EmeraldSDHC 补丁材料

| 文件 | 大小 | SHA256 |
|---|---:|---|
| `binaries/EmeraldSDHC-0.1.2-original` | 78144 | `8E54319536FA5AAE812ACBF189E91637BB04AAF3A6D84CC254D33FAECC131C3B` |
| `binaries/EmeraldSDHC-0.1.2-patched` | 94528 | `D4F0F3D2D30153D9A6DD6B33B3EF634DE2564624030D51C56030BF920A431328` |

- original：acidanthera EmeraldSDHC 0.1.2 RELEASE 包内原文件
  （安装路径 `EmeraldSDHC.kext/Contents/MacOS/EmeraldSDHC`）；
- patched：本仓库 `tools/macho/patch_em_msi.py` 的产物，在 `start()`
  中注入 `IOPCIDevice::enableMSI()`。

补丁原理与布局见 [../../docs/02-emmc-enablemsi-patch.md](../../docs/02-emmc-enablemsi-patch.md)。

`source/` 是 0.1.2 源码的研究副本（.cpp/.hpp/Info.plist），版权遵循
上游 https://github.com/acidanthera/EmeraldSDHC 。
