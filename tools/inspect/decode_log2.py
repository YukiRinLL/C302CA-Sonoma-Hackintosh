import glob, os

cands = sorted(glob.glob(r'F:\opencore-*.txt'), key=os.path.getmtime)
for src in cands:
    raw = open(src, 'rb').read()
    txt = raw.decode('utf-8', errors='replace').replace('\x00', '')
    base = os.path.basename(src)
    out = r'E:\hackintosh\sonoma\decoded_' + base
    open(out, 'w', encoding='utf-8').write(txt)
    print(base, '->', out, len(txt), 'chars,', len(txt.splitlines()), 'lines')
