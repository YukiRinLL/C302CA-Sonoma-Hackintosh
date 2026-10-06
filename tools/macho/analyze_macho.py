# -*- coding: utf-8 -*-
"""解析 EmeraldSDHC Mach-O：架构、段、节、start()、stubs、bind、代码洞"""
import struct, sys

PATH = r"E:\hackintosh\sonoma\EFI\EFI\OC\Kexts\EmeraldSDHC.kext\Contents\MacOS\EmeraldSDHC"
data = open(PATH, "rb").read()

magic = struct.unpack_from("<I", data, 0)[0]
off = 0
slices = []
if magic == 0xCAFEBABE:  # FAT big-endian
    nfat = struct.unpack_from(">I", data, 4)[0]
    print(f"FAT binary, {nfat} arch(s)")
    p = 8
    for i in range(nfat):
        cputype, cpusub, off2, size, align = struct.unpack_from(">IIIII", data, p)
        print(f"  arch cputype=0x{cputype:x} subtype=0x{cpusub:x} offset={off2} size={size}")
        slices.append((off2, size, cputype))
        p += 20
elif magic in (0xfeedfacf,):
    slices.append((0, len(data), 0x01000007))
else:
    print("unknown magic %x" % magic); sys.exit(1)

for base, size, cputype in slices:
    if cputype != 0x01000007:  # only x86_64
        continue
    print(f"\n===== x86_64 slice at {base} =====")
    m = struct.unpack_from("<IiiIIIII", data, base)
    _, cput, cpusub, ftype, ncmds, szcmds, flags, res = m
    print(f"ncmds={ncmds} sizeofcmds={szcmds} flags=0x{flags:x} filetype={ftype}")
    p = base + 32
    sections = []
    for i in range(ncmds):
        cmd, cmdsize = struct.unpack_from("<II", data, p)
        if cmd == 0x19:  # LC_SEGMENT_64
            segname = data[p+8:p+24].split(b"\0")[0].decode()
            vmaddr, vmsize, fileoff, filesize, maxprot, initprot, nsects, segflags = \
                struct.unpack_from("<QQQQiiII", data, p+24)
            print(f"SEG {segname:12s} vmaddr=0x{vmaddr:x} vmsz=0x{vmsize:x} fileoff=0x{fileoff:x} filesz=0x{filesize:x} nsects={nsects}")
            sp = p + 72
            for j in range(nsects):
                sname = data[sp:sp+16].split(b"\0")[0].decode()
                sseg = data[sp+16:sp+32].split(b"\0")[0].decode()
                saddr, ssize, soff, salign, sreloff, snrel, sflags, sr1, sr2 = \
                    struct.unpack_from("<QQIIIIIII", data, sp+32)
                sections.append((sseg,sname,saddr,ssize,soff,sflags))
                sp += 80
        elif cmd in (0x80000022, 0x22):  # LC_DYLD_INFO[_ONLY]
            names = ["rebase","bind","weak","lazy","export"]
            vals = struct.unpack_from("<5x10I", data, p+8)
            print("LC_DYLD_INFO:", {n: hex(v) for n, v in zip(names, vals[:10]) if v})
        elif cmd == 2:  # LC_SYMTAB
            symoff, nsyms, stroff, strsize = struct.unpack_from("<IIII", data, p+8)
            print(f"LC_SYMTAB symoff={symoff} nsyms={nsyms} stroff={stroff} strsize={strsize}")
        elif cmd == 0x80000028:  # LC_MAIN
            entryoff = struct.unpack_from("<Q", data, p+8)[0]
            print(f"LC_MAIN entryoff=0x{entryoff:x}")
        p += cmdsize
    print("\nsections:")
    for s in sections:
        print(f"  {s[0]},{s[1]:20s} addr=0x{s[2]:x} size=0x{s[3]:x} off=0x{s[4]:x} flags=0x{s[5]:x}")
