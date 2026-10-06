# -*- coding: utf-8 -*-
import struct
PATH = r"E:\hackintosh\sonoma\EFI\EFI\OC\Kexts\EmeraldSDHC.kext\Contents\MacOS\EmeraldSDHC"
d = open(PATH, "rb").read()
ncmds = struct.unpack_from("<I", d, 16)[0]
p = 32
secs = []
for i in range(ncmds):
    cmd, csz = struct.unpack_from("<II", d, p)
    if cmd == 0x19:
        seg = d[p+8:p+24].split(b"\0")[0].decode()
        nsects = struct.unpack_from("<I", d, p+24+40)[0]
        sp = p + 72
        for j in range(nsects):
            nm = d[sp:sp+16].split(b"\0")[0].decode()
            saddr, ssize, soff, salign, reloff, nrel, sflags, r1, r2 = \
                struct.unpack_from("<QQIIIIIII", d, sp+32)
            secs.append((seg, nm, saddr, ssize, soff, reloff, nrel))
            print(f"{seg},{nm:16s} addr=0x{saddr:x} reloff=0x{reloff:x} nrel={nrel}")
            sp += 80
    p += csz

# show extern BRANCH relocs of __text
for seg, nm, saddr, ssize, soff, reloff, nrel in secs:
    if nm == "__text":
        print(f"\n__text reloc table at 0x{reloff:x}, {nrel} entries")
        for i in range(nrel):
            a, info = struct.unpack_from("<II", d, reloff + i*8)
            sym = info & 0xffffff
            pcrel = (info >> 24) & 1; ln = (info >> 25) & 3
            ext = (info >> 27) & 1; rtype = info >> 28
            va = saddr + a
            op = d[va] if va < len(d) else -1
            if ext and rtype == 4:
                print(f"  BRANCH r_address(sec)=0x{a:x} va=0x{va:x} op=0x{op:02x} symidx={sym}")
