import plistlib, glob, os, pprint

root = r'E:\hackintosh\sonoma\extract\VoodooI2C-2.9.1'

def load(kext):
    p = glob.glob(os.path.join(root, '**', kext), recursive=True)
    if not p:
        raise SystemExit('not found: ' + kext)
    return plistlib.load(open(os.path.join(p[0], 'Contents', 'Info.plist'), 'rb'))

vi2c = load('VoodooI2C.kext')
print('##### VoodooI2CPCILakeController full personality #####')
pp = vi2c['IOKitPersonalities']
for key in ('VoodooI2CPCILakeController', 'VoodooI2CPCIController'):
    print('----', key)
    pprint.pp(pp.get(key), width=140)

hid = load('VoodooI2CHID.kext')
print()
print('##### VoodooI2CHID full personality #####')
pp2 = hid['IOKitPersonalities']['VoodooI2CHIDDevice']
pprint.pp(pp2, width=140)
