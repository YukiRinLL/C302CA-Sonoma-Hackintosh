# 08 — 归档清单与边界说明

本清单说明归档里有什么、没有复制什么、为什么，以及大体积文件如何核验/重取。
归档时间：2026-10-06。原始工作目录 `E:\hackintosh\` 在归档过程中保持原样，
本归档全部由副本构成。

## 1. 归档总览

```
C302CA-Sonoma-Hackintosh/
├── EFI/                           # 可部署成品（OC 1.0.8，补丁版 EmeraldSDHC）
├── docs/                          # 8 篇文档（01-08，本文件为 08）
├── upstream/
│   ├── releases-sonoma/           # Sonoma 阶段实际下载的 kext/OC 发行 zip + 下载元数据
│   ├── releases-legacy/           # 阶段1（OC 0.9.7/Mojave 期）的旧版本 zip
│   └── sources/                   # 源码包：oc108.tar.gz(OC 1.0.8)、vi2c-src、elan、vi2chid
├── tools/
│   ├── build_config.py
│   ├── macho/                     # Mach-O 逆向与补丁脚本（7 个）
│   ├── inspect/                   # 日志解码/Info.plist 检查脚本（7 个）
│   ├── acpica/                    # ACPICA 20260408 Windows 工具（iasl/acpidump/acpixtract 等）
│   └── gibMacOS/                  # gibMacOS 工具上游镜像（含 LICENSE）
├── research/
│   ├── acpi-tables/               # 真机 DSDT.dsl + 14 个原始 .aml
│   ├── ssdt/                      # 全部自制 SSDT 源与产物（含废弃实验稿）
│   ├── emerald-sdhc/              # 源码副本 + 原/补丁二进制（含 SHA256）
│   ├── logs/                      # 2026-07-17/18 全部 OC 解码日志（8 份）+ last_boot_log
│   ├── photos/                    # 研究照片/屏幕截图：24 张证据图（10-05 共 6 张、10-06 共 18 张；
│   │                              # 5 张闲鱼第三方截图与微信聊天原图暂存目录已应用户要求彻底移除）
│   ├── reference/                 # USBMap 研究材料、USB 端口 plist、lulu 笔记、cbosx 设备树
│   ├── process/
│   │   ├── windows-scripts/       # dd/diskpart/分区重建/HFS 校验全部 PowerShell 脚本
│   │   ├── logs/                  # 造盘阶段日志（dd/dp/download/repart/rebuild 等）
│   │   └── stage/                 # 阶段标记、参数记录、hdr.bin 扇区转储
│   ├── legacy-stage/              # OC 0.9.7 期的 config 与生成脚本
│   └── installer-metadata/        # 安装器小体积元数据（plist/chunklist/小 pkg/dmg）
├── README.md
└── .gitignore
```

## 2. 未复制进归档的内容（体积/版权/重复原因）

### 2.1 Apple 大体积安装媒体（约 8.9 GB，仅登记不复制）

这些文件留在原研究机路径，**未进 git、未复制进归档文件夹**（归档盘
当时仅剩 26GB，且 Apple 版权文件不宜公开分发）。完整性以本表 SHA256
为准，需要时按第 3 节重新获取。

| 文件 | 原路径 | 大小 | SHA256 |
|---|---|---:|---|
| InstallESDDmg.pkg | `E:\hackintosh\macOS Downloads\` | 5,288.0 MB | `defd3e8fdaaed4b816ebdd7fdd92ebc44f12410a0deeb93e34486c3d7390ffb7` |
| 4.hfs（自建 HFS+ 安装盘映像） | `E:\hackintosh\hfsimg\` | 1,908.6 MB | `5001536b47659eb43fbf7df8c6e83452128d11e766f16536adfd430ddfdc4fc5` |
| BaseSystem.dmg（U盘 recovery） | `E:\hackintosh\sonoma\com.apple.recovery.boot\` | 753.0 MB | `591f07a9a4a58d855a2e53b86a5f5da854a250000a66a9382adaf106c20f839b` |
| RecoveryHDMetaDmg.pkg | `E:\hackintosh\macOS Downloads\` | 459.7 MB | `fee67d1a4423998ae1929095d3e83e405a00830e415b32426f2c24192b21c2cb` |
| BaseSystem.dmg（gibMacOS 目录） | `E:\hackintosh\macOS Downloads\` | 458.2 MB | `c1bb8a816a9ecd916e824c975368a3921f4bcbc9469aa63e9c9fe10a783931ad` |

配套的 Apple 签名校验文件（chunklist）和清单 plist 已复制到
`research/installer-metadata/`：

- `BaseSystem.chunklist`、`AppleDiagnostics.chunklist`、
  `InstallESDDmg.chunklist`（Apple 官方分块签名，可用 OpenCore
  自带的校验逻辑或 `chunkcodesign` 验证对应 dmg/pkg，比哈希更权威）；
- `InstallInfo.plist`：显示这套下载实际是阶段 0 的
  **Mojave 10.14.6（1569030045）**，是研究转向 Sonoma 前的历史物证；
- `InstallAssistantAuto.pkg`、`MajorOSInfo.pkg`、`OSInstall.mpkg`、
  `AppleDiagnostics.dmg`（均 <12MB）。

### 2.2 解压后的上游源码/二进制树（约 280MB，已用压缩包等价覆盖）

- `sonoma/extract/`（166MB）：OpenCore 1.0.8 完整源码树、IA32 固件
  二进制全集、VoodooI2C 2.9.1 解压树等。等价来源：
  - OpenCore 源码 → `upstream/sources/oc108.tar.gz`（18.3MB，
    与原机 `sonoma/oc-src.tar.gz` MD5 相同：
    `53DAB1499F542331E794D8351908FA44`）；
  - VoodooI2C 源码/文档 → `upstream/sources/vi2c-src.tar.gz`；
  - ELAN satellite / VoodooI2CHID 源码 → `elan.tar.gz`、`vi2chid.tar.gz`；
  - 发行内容 → `upstream/releases-sonoma/*.zip`。
  - **例外**：EmeraldSDHC 源码（补丁研究对象）已完整复制到
    `research/emerald-sdhc/source/`。
- `efi-build/extract/`：OC 0.9.7、gibMacOS 等旧解压树。等价来源：
  `upstream/releases-legacy/OpenCore-0.9.7-*.zip` 及
  `tools/gibMacOS/`。
- `sonoma/dl` 里的 `oc108.tar`/`oc108gz`（50MB 解包 tar）与 tar.gz
  内容重复，不复制。
- 各 kext 在 `EFI/` 中已有可用实例，zip 仅作版本冻结与离线重取凭据。

## 3. 重新获取缺失内容的方法

- Sonoma 恢复镜像：在 macOS/虚拟机用 OpenCore 的 `macrecovery`
  （`Utilities/macrecovery`）：

  ```
  ./macrecovery -b com.apple.recovery.boot -os latest -d ./com.apple.recovery.boot
  ```

  或 Windows 上用归档内 `tools/gibMacOS/` 选择对应 Sonoma 版本；
- 全部第三方 kext/OC：按 [06](06-third-party-components.md) 的版本号
  到对应 GitHub Release 下载；归档内 zip 即当时逐字版本；
- ACPICA：https://github.com/acpica/acpica/releases （归档内为
  20260408 构建）；
- 自制 SSDT：`research/ssdt/*.dsl` 用归档内 iasl 重新编译即可。

## 4. 隐私脱敏记录

归档公开发布前已对 SMBIOS 标识做全量替换（含二进制级全文扫描，0 命中）：

| 原内容 | 替换为 | 出现位置 |
|---|---|---|
| SystemSerialNumber | `REPLACE_WITH_YOUR_SERIAL` | config.plist、build_config.py、全部启动日志 |
| MLB | `REPLACE_WITH_YOUR_MLB` | 同上 |
| SystemUUID | 全零 UUID | 同上 |
| ROM（无线网卡 MAC） | `11:22:33:44:55:66` / `112233445566` | config.plist、build_config.py、日志中 `Setting ROM` 行 |

复现脱敏：对整个目录执行字符串替换即可（本项目使用一次性 Python 脚本，
规则如上表；注意日志中 MAC 同时存在冒号和无分隔符两种形式）。

## 5. 体积与 GitHub 适配

- 归档（入 git 部分）总计约 130MB 量级、单个文件最大 18.3MB
  （oc108.tar.gz），低于 GitHub 50MB 警告/100MB 硬限制；
- `.gitignore` 只屏蔽本机私有配置（`*local.plist`）、根目录运行期
  `opencore-*.txt` 和系统杂项；`research/` 下的历史 `.log` 属于研究
  记录，**有意保留跟踪**；
- 若你的 GitHub 仓库想进一步瘦身，可优先移除
  `upstream/releases-legacy/`（旧版本，约 44MB）和
  `research/installer-metadata/InstallAssistantAuto.pkg`（11MB），
  不影响 EFI 可用性。
