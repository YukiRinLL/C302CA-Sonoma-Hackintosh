import glob, os, re

cands = glob.glob(r'F:\opencore-*.txt')
cands.sort(key=os.path.getmtime)
src = cands[-1]
raw = open(src, 'rb').read()
txt = raw.decode('utf-8', errors='replace').replace('\x00', '')
out = r'E:\hackintosh\sonoma\decoded_latest.txt'
open(out, 'w', encoding='utf-8').write(txt)
lines = txt.splitlines()
print('source:', src, 'bytes:', len(raw), 'clean chars:', len(txt), 'lines:', len(lines))
print('first line:', lines[0][:120] if lines else '(empty)')
print('last  line:', lines[-1][:120] if lines else '(empty)')
