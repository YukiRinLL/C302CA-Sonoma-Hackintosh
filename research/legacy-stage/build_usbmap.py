# -*- coding: utf-8 -*-
"""
C302CA (CAVE / Skylake-Y) 安装期 codeless USB 映射 kext（CorpNewt USBMap 格式）。

依据（社区成功案例 + Dortania 对 "Still waiting for root device" 的标准解法）：
  * “固件能读 U 盘、内核加载后 U 盘在总线上消失” = XHCI 从固件移交给 macOS 时
    USB3(SuperSpeed) 设备掉线。官方/社区一致解法：让安装盘走 USB2.0 高速(HS)通道
    （即物理“插 USB2.0 口 / 加 USB2.0 Hub”的软件等价做法）。
  * 实现：只映射真实存在的 HS01..HS10（DSDT _ADR 1..10），不映射任何 SS01..SS06，
    于是所有 USB3 设备只在 HighSpeed 端口枚举（480Mbps），安装足够且最稳。
  * coreboot 的 XHCI 控制器 ACPI 名是 "XHCI"（非苹果惯例 "XHC"，WEG 不改名），
    故 IONameMatch 用数组同时匹配两者，确保本 kext 真正 attach。
  * UsbConnector=0（标准外部 USB），port-count=10（最高 HS _ADR）。
装好系统后再用 USBToolBox 实测精修 Type-C(9)/内部设备(255) 与 SS 通道。
"""
import os, plistlib

OUT = r"E:\hackintosh\efi-build\EFI\EFI\OC\Kexts\USBMap.kext\Contents\Info.plist"

def pdata(n):
    return n.to_bytes(4, "little")

ports = {}
# 仅真实硬件高速端口 HS01..HS10（_ADR 1..10）；不注入不存在的 HS00，也不映射 SS。
for adr in range(1, 11):
    ports["HS%02d" % adr] = {
        "UsbConnector": 0,
        "port": pdata(adr),
        "usb-port-type": 0,
        "usb-port-number": pdata(adr),
    }

info = {
    "CFBundleDevelopmentRegion": "English",
    "CFBundleGetInfoString": "v1.0 C302CA HS-only install map",
    "CFBundleIdentifier": "com.corpnewt.USBMap",
    "CFBundleInfoDictionaryVersion": "6.0",
    "CFBundleName": "USBMap",
    "CFBundlePackageType": "KEXT",
    "CFBundleShortVersionString": "1.0",
    "CFBundleSignature": "????",
    "CFBundleVersion": "1.0",
    "IOKitPersonalities": {
        "CAVE-XHC": {
            "CFBundleIdentifier": "com.apple.driver.AppleUSBHostMergeProperties",
            "IOClass": "AppleUSBHostMergeProperties",
            "IONameMatch": ["XHC", "XHCI"],   # 兼容苹果名 XHC 与 coreboot 名 XHCI
            "IOProviderClass": "AppleUSBXHCIPCI",
            "IOProviderMergeProperties": {
                "kUSBMuxEnabled": True,
                "port-count": pdata(10),
                "ports": ports,
            },
        }
    },
    "OSBundleRequired": "Root",
}

os.makedirs(os.path.dirname(OUT), exist_ok=True)
with open(OUT, "wb") as f:
    plistlib.dump(info, f)
print("written:", OUT)
print("ports:", ", ".join(sorted(ports.keys())))
