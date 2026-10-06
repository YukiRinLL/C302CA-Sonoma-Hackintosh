import plistlib, glob, os

root = r'E:\hackintosh\sonoma\extract\VoodooI2C-2.9.1'
kexts = glob.glob(os.path.join(root, '**', '*.kext'), recursive=True)
seen = set()
for k in kexts:
    info_p = os.path.join(k, 'Contents', 'Info.plist')
    if not os.path.exists(info_p):
        continue
    info = plistlib.load(open(info_p, 'rb'))
    cid = info.get('CFBundleIdentifier', '')
    # only print top-level once and each plugin
    rel = os.path.relpath(k, root)
    print('=' * 70)
    print(rel, '| ver', info.get('CFBundleShortVersionString'), '| id', cid)
    for name, pers in (info.get('IOKitPersonalities') or {}).items():
        print('  personality:', name)
        print('    IOClass     =', pers.get('IOClass'))
        print('    IOProvider  =', pers.get('IOProviderClass'))
        inm = pers.get('IONameMatch')
        if inm is not None:
            print('    IONameMatch =', inm)
        # ELAN check inside nested match dict
        im = pers.get('IONameMatch')
    deps = info.get('OSBundleLibraries') or {}
    if deps:
        print('  deps:', list(deps.keys()))
