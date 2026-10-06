# -*- coding: utf-8 -*-
import struct
from capstone import Cs, CS_ARCH_X86, CS_MODE_64

P = r"E:\hackintosh\sonoma\EFI\EFI\OC\Kexts\EmeraldSDHC.kext\Contents\MacOS\EmeraldSDHC"
d = open(P, "rb").read()
print("size:", hex(len(d)))
magic, cputype, cpusub, ft, ncmds, szcmds, flags, resv = struct.unpack_from("<IiiIIIII", d, 0)
print(f"ncmds={ncmds} sizeofcmds={szcmds} flags=0x{flags:x}")

p = 32
symtab = dysym = None
for i in range(ncmds):
    cmd, csz = struct.unpack_from("<II", d, p)
    if cmd == 0x19:
        nm = bytes(d[p+8:p+24]).split(b"\0")[0].decode()
        vmaddr, vmsz, foff, fsz, mx, ip, ns, fl = struct.unpack_from("<QQQQiiII", d, p+24)
        print(f"LC_SEGMENT_64 {nm:10s} vm=0x{vmaddr:x}+0x{vmsz:x} file=0x{foff:x}+0x{fsz:x} prot={mx}/{ip} nsects={ns}")
        sp = p + 72
        for j in range(ns):
            s = d[sp:sp+16].split(b"\0")[0].decode()
            a, sz, so, al, ro, nr, sf, r1, r2 = struct.unpack_from("<QQIIIIIII", d, sp+32)
            print(f"    {s:14s} addr=0x{a:x} size=0x{sz:x} off=0x{so:x} align={al} reloff=0x{ro:x} nrel={nr} flags=0x{sf:x}")
            sp += 80
    elif cmd == 2:
        symoff, nsym, stroff, strsz = struct.unpack_from("<IIII", d, p+8)
        symtab = (symoff, nsym, stroff, strsz)
        print(f"LC_SYMTAB off=0x{symoff:x} nsyms={nsym} stroff=0x{stroff:x} strsz=0x{strsz:x}")
    elif cmd == 0xB:
        dysym = p
    p += csz

so, ns, stro, strsz = symtab
# 新符号 523
strx, typ, sect, desc, val = struct.unpack_from("<IBBHQ", d, so + 523*16)
name_end = d.index(b"\0", stro + strx)
print("sym[523]:", d[stro+strx:name_end].decode(), "type=0x%02x sect=%d" % (typ, sect))

# DYSYMTAB 关键字段
nundef = struct.unpack_from("<I", d, dysym+8+5*4)[0]
indoff, nind = struct.unpack_from("<II", d, dysym+8+12*4)
extro, nextrel = struct.unpack_from("<II", d, dysym+8+14*4)
locro, nloc = struct.unpack_from("<II", d, dysym+8+16*4)
print(f"nundef={nundef} indirect=0x{indoff:x}/{nind} extrel=0x{extro:x}/{nextrel} locrel=0x{locro:x}/{nloc}")

# 新 reloc 条目
a, info = struct.unpack_from("<II", d, extro + (nextrel-1)*8)
print(f"new reloc: addr=0x{a:x} sym={info&0xffffff} pcrel={(info>>24)&1} len={(info>>25)&3} ext={(info>>27)&1} type={info>>28}")

# 反汇编补丁点
md = Cs(CS_ARCH_X86, CS_MODE_64)
print("\n--- __text 0x4730 patch site ---")
for ins in md.disasm(bytes(d[0x4730:0x4750]), 0x4730):
    print(f"0x{ins.address:x}: {ins.mnemonic} {ins.op_str}")

print("\n--- __cave 0x17000 ---")
cave_fo = 0x16000
for ins in md.disasm(bytes(d[cave_fo:cave_fo+0x37]), 0x17000):
    print(f"0x{ins.address:x}: {ins.mnemonic} {ins.op_str}")
print("cave bytes:", d[cave_fo:cave_fo+0x37].hex())

# 校验 enableMSI 名在 strtab 范围内
idx = d.find(b"__ZN12IOPCIDevice9enableMSIEPjPvh\x00", stro)
print("\nname string fo:", hex(idx), "strtab end:", hex(stro+strsz))
assert stro <= idx < stro+strsz
