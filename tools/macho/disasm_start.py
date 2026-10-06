# -*- coding: utf-8 -*-
"""反汇编 start() 并扫描 __text 内 0xCC/0x90 填充洞"""
import struct
from capstone import Cs, CS_ARCH_X86, CS_MODE_64
from analyze_macho import data  # reuse parse? import executes; simpler redefine

PATH = r"E:\hackintosh\sonoma\EFI\EFI\OC\Kexts\EmeraldSDHC.kext\Contents\MacOS\EmeraldSDHC"
data = open(PATH, "rb").read()

# sections known from previous output
TEXT_ADDR, TEXT_OFF, TEXT_SIZE = 0x760, 0x760, 0x461a
text = data[TEXT_OFF:TEXT_OFF+TEXT_SIZE]

# --- scan padding runs (CC or 90) >= 16 bytes ---
runs = []
i = 0
while i < len(text):
    if text[i] in (0xCC, 0x90):
        j = i
        while j < len(text) and text[j] == text[i]:
            j += 1
        if j - i >= 16:
            runs.append((TEXT_ADDR+i, j-i, text[i]))
        i = j
    else:
        i += 1
print("padding runs >=16 in __text:")
for a, l, b in runs:
    print(f"  addr=0x{a:x} len={l} fill=0x{b:02x}")

# tail of __text
tail = text[-64:]
print("\n__text tail bytes:", tail.hex())

# --- find start() via symbol table ---
SYMOFF, NSYMS, STROFF, STRSIZE = 37664, 523, 55000, 23144
def getstr(idx):
    end = data.index(b"\0", STROFF+idx)
    return data[STROFF+idx:end].decode(errors="replace")

syms = []
for k in range(NSYMS):
    n_strx, n_type, n_sect, n_desc, n_value = struct.unpack_from("<IBBHQ", data, SYMOFF+k*16)
    name = getstr(n_strx) if n_strx else ""
    syms.append((name, n_type, n_sect, n_desc, n_value))

starts = [s for s in syms if "EmeraldSDHC" in s[0] and ("start" in s[0] or "enableMSI" in s[0])]
for s in starts:
    print("sym:", s)

# disasm EmeraldSDHC::start
start_sym = [s for s in syms if s[0].endswith("11EmeraldSDHC5startEP9IOService")]
if start_sym:
    addr = start_sym[0][4]
    print(f"\n===== start() at 0x{addr:x} =====")
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    cnt = 0
    for ins in md.disasm(data[addr:addr+700], addr):
        print(f"0x{ins.address:x}: {ins.bytes.hex():28s} {ins.mnemonic} {ins.op_str}")
        cnt += 1
        if cnt > 90: break
