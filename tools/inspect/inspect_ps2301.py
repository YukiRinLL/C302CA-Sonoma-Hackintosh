import plistlib, os, glob

base = r'E:\hackintosh\sonoma\EFI\EFI\OC\Kexts'

def show(kpath, tag):
    info_p = os.path.join(kpath, 'Contents', 'Info.plist')
    info = plistlib.load(open(info_p, 'rb'))
    exe = os.path.join(kpath, 'Contents', 'MacOS', info.get('CFBundleExecutable', ''))
    print('=' * 72)
    print(tag, os.path.basename(kpath), info.get('CFBundleShortVersionString'))
    print('  id =', info.get('CFBundleIdentifier'))
    print('  binary exists =', os.path.exists(exe), exe)
    deps = info.get('OSBundleLibraries') or {}
    for d, v in deps.items():
        print('   dep', d, v)
    for name, p in (info.get('IOKitPersonalities') or {}).items():
        line = '  personality %-28s prov=%-22s class=%s' % (
            name, p.get('IOProviderClass'), p.get('IOClass'))
        if 'IONameMatch' in p:
            line += ' match=%s' % (p['IONameMatch'],)
        if 'IOProbeScore' in p:
            line += ' score=%s' % p['IOProbeScore']
        if 'IOPropertyMatch' in p:
            line += ' prop=%s' % p['IOPropertyMatch']
        print(line)

show(os.path.join(base, 'VoodooPS2Controller.kext'), '[top]')
for plug in sorted(glob.glob(os.path.join(base, 'VoodooPS2Controller.kext', 'Contents', 'PlugIns', '*.kext'))):
    show(plug, '   [plugin]')
show(os.path.join(base, 'VoodooI2C.kext', 'Contents', 'PlugIns', 'VoodooInput.kext'), '[vi2c plugin]')
