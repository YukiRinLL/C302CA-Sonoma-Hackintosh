// C302CA (CAVE) / Skylake-Y, MrChromebox coreboot
// coreboot 的 ELAN 触摸板 \_SB.PCI0.I2C1.D015 只有 _HID="ELAN0000"，
// 没有 compatible ID。VoodooI2CHID.kext 以 IOPropertyMatch
// { compatible = "PNP0C50" } 匹配 VoodooI2CDeviceNub（PNP0C50 = 标准
// HID over I2C）。此补丁向已有设备对象追加 _CID，使其被 HID 卫星驱动接管。
// 触摸板是标准 HID-I2C 设备，无需专用 ELAN kext。
DefinitionBlock ("", "SSDT", 2, "sqrl", "i2chid", 0x00000000)
{
    External (_SB_.PCI0.I2C1, DeviceObj)
    External (_SB_.PCI0.I2C1.D015, DeviceObj)

    Scope (\_SB.PCI0.I2C1.D015)
    {
        Name (_CID, Package ()
        {
            "PNP0C50"
        })
    }
}
