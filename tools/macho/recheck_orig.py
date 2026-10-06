# -*- coding: utf-8 -*-
import struct
from capstone import Cs, CS_ARCH_X86, CS_MODE_64

BAK = r"E:\hackintosh\sonoma\EFI\EFI\OC\Kexts\EmeraldSDHC.kext\Contents\MacOS\EmeraldSDHC.012.bak"
d = open(BAK, "rb").read()
md = Cs(CS_ARCH_X86, CS_MODE_64)

print("raw bytes 0x4720..0x4745:", d[0x4720:0x4745].hex())
print("\n--- original disasm 0x46f0..0x4770 ---")
for ins in md.disasm(bytes(d[0x46f0:0x4770]), 0x46f0):
    print(f"0x{ins.address:x}: {ins.bytes.hex():20s} {ins.mnemonic} {ins.op_str}")

# DYSYMTAB raw fields
p = 32
ncmds = struct.unpack_from("<I", d, 16)[0]
for i in range(ncmds):
    cmd, csz = struct.unpack_from("<II", d, p)
    if cmd == 0xB:
        names = ["ilocalsym","nlocalsym","iextdefsym","nextdefsym","iundefsym","nundefsym",
                 "tocoff","ntoc","modtaboff","nmodtab","extrefsymoff","nextrefsyms",
                 "indirectsymoff","nindirectsym","extreloff","nextrel","locreloff","nlocrel"]
        vals = struct.unpack_from("<18I", d, p+8)
        for n, v in zip(names, vals):
            print(f"  {n:16s} = 0x{v:x} ({v})")
    p += csz
