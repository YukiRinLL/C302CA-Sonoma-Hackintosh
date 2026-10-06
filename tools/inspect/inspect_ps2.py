import plistlib, glob, os

base = r'E:\hackintosh\sonoma\EFI\EFI\OC\Kexts\VoodooPS2Controller.kext'
info = plistlib.load(open(os.path.join(base, 'Contents', 'Info.plist'), 'rb'))
print('version:', info.get('CFBundleShortVersionString'), info.get('CFBundleVersion'))
print('id:', info.get('CFBundleIdentifier'))
print('executable:', info.get('CFBundleExecutable'))
print('OSBundleLibraries:', info.get('OSBundleLibraries'))
for k, v in (info.get('IOKitPersonalities') or {}).items():
    print('personality:', k)
    print('  IOClass      =', v.get('IOClass'))
    print('  IOProvider   =', v.get('IOProviderClass'))
    print('  IONameMatch  =', v.get('IONameMatch'))
print('--- PlugIns ---')
for p in sorted(glob.glob(os.path.join(base, 'Contents', 'PlugIns', '*.kext'))):
    pi = plistlib.load(open(os.path.join(p, 'Contents', 'Info.plist'), 'rb'))
    exe_path = os.path.join(p, 'Contents', 'MacOS', pi.get('CFBundleExecutable', ''))
    print(os.path.basename(p),
          '| ver', pi.get('CFBundleShortVersionString'),
          '| exe:', os.path.exists(exe_path),
          '| deps:', list((pi.get('OSBundleLibraries') or {}).keys()))
