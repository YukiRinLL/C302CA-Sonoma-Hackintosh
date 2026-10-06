# -*- coding: utf-8 -*-
"""
EmeraldSDHC 0.1.2 enableMSI 补丁 (x86_64 MH_BUNDLE, 经典内核kext链接格式)
在 EmeraldSDHC::start() 的 super::start 成功后、创建中断源之前，
对 IOPCIDevice provider 调用 enableMSI(0,0,0)，使无 INTx 引脚的
coreboot SCS eMMC(9d2b) 获得 MSI 中断。

布局（文件扩展 0x3000 -> 0x16140，__LINKEDIT filesz/vmsz -> 0xd140）：
  0x13140  搬迁后的 external reloc 表 (1121*8=0x2308) + 新增1条
  0xb3d0   原extreloc起点，搬走后作为 symtab 第524项(nlist)的位置
  0x15500  新符号名 __ZN12IOPCIDevice9enableMSIEPjPvh
  0x15600  新段 __MSI 中的 __cave 节代码（r-x, vmaddr 0x17000）
__text 0x4730: jmp 0x17000; 90 90  (原 lea rsi,[rip+0xcff] 7字节移入cave)
"""
import struct, shutil, os

SRC = r"E:\hackintosh\sonoma\EFI\EFI\OC\Kexts\EmeraldSDHC.kext\Contents\MacOS\EmeraldSDHC"
BAK = SRC + ".012.bak"
if not os.path.exists(BAK):
    shutil.copy2(SRC, BAK)
    print("backup ->", BAK)

d = bytearray(open(BAK, "rb").read())

SYMOFF, NSYMS         = 0x9320, 523
STROFF                = 0xd6d8
EXTREL_OFF, N_EXTREL  = 0xb3d0, 1121
EXTREL_SZ             = N_EXTREL * 8          # 0x2308

EXTEND               = 0x4000
NEW_LINKEDIT_SZ      = 0xd140                 # 表数据只用到 0x15522；映射到 0x16140
NEW_EXTREL_FO        = 0x13140
NEW_NLIST_FO         = 0xb3d0                 # symtab 自然末尾
NEW_NAME_FO          = 0x15500
MSI_SEG_VA           = 0x17000
MSI_CODE_FO          = 0x16000                # 页对齐
MSI_SEG_SZ           = 0x200
TEXT_PATCH_VA        = 0x4730
ORIG_INSN_LEN        = 7
LEA_TARGET_VA        = 0x4902
RETURN_VA            = 0x4737
SYM_NAME             = b"__ZN12IOPCIDevice9enableMSIEPjPvh\x00"

# 1. 扩展文件
d.extend(b"\x00" * EXTEND)
assert len(d) == 0x17140

# 2. 搬迁 external reloc 表（先拷贝，源区域随后要复用给新nlist）
d[NEW_EXTREL_FO:NEW_EXTREL_FO+EXTREL_SZ] = d[EXTREL_OFF:EXTREL_OFF+EXTREL_SZ]

# 3. 新 nlist 未定义符号
new_strx = NEW_NAME_FO - STROFF
struct.pack_into("<IBBHQ", d, NEW_NLIST_FO, new_strx, 0x01, 0, 0, 0)

# 4. 新符号名
d[NEW_NAME_FO:NEW_NAME_FO+len(SYM_NAME)] = SYM_NAME
new_strsize = new_strx + len(SYM_NAME)

# 5. cave 代码
cave = bytearray()
cave += bytes.fromhex("4156")                    # 0x00 push r14
cave += bytes.fromhex("4883e4f0")                # 0x02 and rsp,-0x10
cave += bytes.fromhex("4883ec20")                # 0x06 sub rsp,0x20
cave += bytes.fromhex("c744241001000000")        # 0x0a mov dword[rsp+0x10],1
cave += bytes.fromhex("488b7c2428")              # 0x12 mov rdi,[rsp+0x28] (provider=r14)
cave += bytes.fromhex("488d742410")              # 0x17 lea rsi,[rsp+0x10]
cave += bytes.fromhex("31d2")                    # 0x1c xor edx,edx
cave += bytes.fromhex("31c9")                    # 0x1e xor ecx,ecx
assert len(cave) == 0x20
cave += b"\xe8\x00\x00\x00\x00"                  # 0x20 call enableMSI (BRANCH reloc)
cave += bytes.fromhex("4883c428")                # 0x25 add rsp,0x28
cave += bytes.fromhex("415e")                    # 0x29 pop r14
# 复刻原指令 lea rsi,[rip+0xcff] -> 0x4902
lea_rip_next = MSI_SEG_VA + len(cave) + 7
cave += b"\x48\x8d\x35" + struct.pack("<i", LEA_TARGET_VA - lea_rip_next)
# 跳回 0x4737
jmp_rip_next = MSI_SEG_VA + len(cave) + 5
cave += b"\xe9" + struct.pack("<i", RETURN_VA - jmp_rip_next)
print(f"cave 0x{len(cave):x} bytes; lea@0x{MSI_SEG_VA+0x2b:x}, jmp@0x{MSI_SEG_VA+0x32:x}")
d[MSI_CODE_FO:MSI_CODE_FO+len(cave)] = cave

# 6. 追加 external reloc: r_address=绝对地址disp32, BRANCH=2, pcrel=1, len=2, extern=1
reloc_va = MSI_SEG_VA + 0x21
reloc_info = 523 | (1 << 24) | (2 << 25) | (1 << 27) | (2 << 28)
struct.pack_into("<II", d, NEW_EXTREL_FO + EXTREL_SZ, reloc_va, reloc_info)

# 7. __text 0x4730: jmp cave + nop nop
d[TEXT_PATCH_VA:TEXT_PATCH_VA+ORIG_INSN_LEN] = (
    b"\xe9" + struct.pack("<i", MSI_SEG_VA - (TEXT_PATCH_VA + 5)) + b"\x90\x90")

# 8. Mach-O load commands
ncmds  = struct.unpack_from("<I", d, 16)[0]
szcmds = struct.unpack_from("<I", d, 20)[0]
p = 32
cmds = {}
for i in range(ncmds):
    cmd, csz = struct.unpack_from("<II", d, p)
    cmds.setdefault(cmd, []).append((p, csz))
    if cmd == 0x19 and bytes(d[p+8:p+24]).split(b"\0")[0] == b"__LINKEDIT":
        struct.pack_into("<Q", d, p+24+8,  NEW_LINKEDIT_SZ)   # vmsize
        struct.pack_into("<Q", d, p+24+24, NEW_LINKEDIT_SZ)   # filesize
    p += csz

# LC_SYMTAB: nsyms +1, strsize 增大
sp_, _ = cmds[2][0]
struct.pack_into("<IIII", d, sp_+8, SYMOFF, NSYMS+1, STROFF, new_strsize)

# LC_DYSYMTAB: nundefsym+1 (字段5), extreloff=NEW (字段14), nextrel+1 (字段15)
dp, _ = cmds[0xB][0]
nundef = struct.unpack_from("<I", d, dp+8+5*4)[0]
struct.pack_into("<I", d, dp+8+5*4,  nundef+1)
struct.pack_into("<I", d, dp+8+14*4, NEW_EXTREL_FO)
struct.pack_into("<I", d, dp+8+15*4, N_EXTREL+1)

# 9. 追加 LC_SEGMENT_64 __MSI（72 + 1 section 80 = 152 字节）
hdr_end = 32 + szcmds
assert hdr_end + 152 <= 0x760
seg = bytearray(152)
struct.pack_into("<II", seg, 0, 0x19, 152)
seg[8:24] = b"__MSI".ljust(16, b"\x00")
struct.pack_into("<QQQQiiII", seg, 24,
                 MSI_SEG_VA, MSI_SEG_SZ, MSI_CODE_FO, MSI_SEG_SZ, 5, 5, 1, 0)
seg[72:88]  = b"__cave".ljust(16, b"\x00")
seg[88:104] = b"__MSI".ljust(16, b"\x00")
struct.pack_into("<QQIIIIIIII", seg, 104,
                 MSI_SEG_VA, len(cave), MSI_CODE_FO, 2,
                 0, 0,
                 0x80000400, 0, 0, 0)
d[hdr_end:hdr_end+152] = seg
struct.pack_into("<II", d, 16, ncmds+1, szcmds+152)

open(SRC, "wb").write(d)
print("patched ->", SRC, "size", len(d))
