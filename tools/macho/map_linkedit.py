# -*- coding: utf-8 -*-
"""映射 __LINKEDIT 布局：symtab/strtab/dysymtab 各表位置和间隙"""
import struct

PATH = r"E:\hackintosh\sonoma\EFI\EFI\OC\Kexts\EmeraldSDHC.kext\Contents\MacOS\EmeraldSDHC"
data = bytearray(open(PATH, "rb").read())

ncmds = struct.unpack_from("<I", data, 16)[0]
p = 32
dys = None
for i in range(ncmds):
    cmd, cmdsize = struct.unpack_from("<II", data, p)
    if cmd == 0xB:  # LC_DYSYMTAB
        vals = struct.unpack_from("<18I", data, p+8)
        labels = ["ilocalsym","nlocalsym","iextdefsym","nextdefsym","iundefsym","nundefsym",
                  "tocoff","ntoc","modtaboff","nmodtab","extreloff","nextrel",
                  "breloff","nbreloc","indirectsymoff","nindirectsym","extreloff2","nextrel2"]
        dys = dict(zip(labels, vals))
        print("LC_DYSYMTAB:")
        for k in labels: print(f"  {k} = 0x{dys[k]:x} ({dys[k]})" if "off" in k or k.startswith("i") else f"  {k} = {dys[k]}")
    elif cmd == 2:
        symoff, nsyms, stroff, strsize = struct.unpack_from("<IIII", data, p+8)
    p += cmdsize

print(f"\nsymtab: off=0x{symoff:x} nsyms={nsyms} end=0x{symoff+nsyms*16:x}")
print(f"strtab: off=0x{stroff:x} size=0x{strsize:x} end=0x{stroff+strsize:x}")
print(f"file size=0x{len(data):x}")

# collect all linkedit-resident ranges
ranges = []
ranges.append((symoff, symoff+nsyms*16, "nlist"))
ranges.append((stroff, stroff+strsize, "strings"))
for k in ("tocoff","modtaboff","extreloff","breloff","indirectsymoff","extreloff2"):
    off = dys[k]
    if off:
        cntk = {"tocoff":"ntoc","modtaboff":"nmodtab","extreloff":"nextrel","breloff":"nbreloc",
                "indirectsymoff":"nindirectsym","extreloff2":"nextrel2"}[k]
        sz = {"tocoff":8,"modtaboff":32,"indirectsymoff":4}.get(k,8)*dys[cntk]
        ranges.append((off, off+sz, f"{k}({dys[cntk]})"))
ranges.sort()
print("\nlinkedit ranges (sorted):")
prev = None
for a,b,n in ranges:
    gap = "" if prev is None else f"  GAP before: 0x{a-prev:x}"
    print(f"  0x{a:06x}-0x{b:06x} {n}{gap}")
    if prev is None or a > prev_end:
        pass
    prev = n; prev_end = b

# section reloc tables
print("\nsection reloc tables:")
p = 32
for i in range(ncmds):
    cmd, cmdsize = struct.unpack_from("<II", data, p)
    if cmd == 0x19:
        segname = data[p+8:p+24].split(b"\0")[0].decode()
        nsects = struct.unpack_from("<I", data, p+24+40)[0]
        sp = p + 72
        for j in range(nsects):
            sname = data[sp:sp+16].split(b"\0")[0].decode()
            saddr, ssize, soff, salign, sreloff, snrel, sflags, sr1, sr2 = \
                struct.unpack_from("<QQIIIIIII", data, sp+32)
            if snrel:
                print(f"  {segname},{sname}: reloff=0x{sreloff:x} nrel={snrel} end=0x{sreloff+snrel*8:x}")
            sp += 80
    p += cmdsize
