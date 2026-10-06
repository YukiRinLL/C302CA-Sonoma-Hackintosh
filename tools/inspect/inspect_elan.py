import plistlib, glob, os, pprint

root = r'E:\hackintosh\sonoma\extract\VoodooI2C-2.9.1'
hits = glob.glob(os.path.join(root, '**', 'VoodooI2CELAN.kext'), recursive=True)
for h in hits:
    info = plistlib.load(open(os.path.join(h, 'Contents', 'Info.plist'), 'rb'))
    print(h, info.get('CFBundleShortVersionString'), info.get('CFBundleIdentifier'))
    for name, p in (info.get('IOKitPersonalities') or {}).items():
        print('----', name)
        for k in ('IOClass','IOProviderClass','IONameMatch','IOPropertyMatch','IOProbeScore','CFBundleIdentifier'):
            if k in p: print('   ', k, '=', p[k])
    print('deps:', list((info.get('OSBundleLibraries') or {}).keys()))
