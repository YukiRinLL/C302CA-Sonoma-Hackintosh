// C302CA (CAVE) / Skylake-Y, MrChromebox coreboot
// coreboot 暴露 6 个 SerialIO I2C 控制器：
//   I2C0 (15,0) -> D010 ELAN0001 触摸屏  (I2C 0x10, GSI31) 装后再开
//   I2C1 (15,1) -> D015 ELAN0000 触摸板  (I2C 0x15, GSI51) 安装期启用
//   I2C4 (19,2) -> NAU8825 声卡 codec（装后再开）
//   I2C2/I2C3/I2C5 无任何子设备
// 空控制器会让原生 AppleIntelLpssI2C 反复 "Timed out on input stream 1"，
// 刷屏并拖慢启动。Darwin 下将 I2C0/I2C2/I2C3/I2C4/I2C5 置 _STA=0；
// 仅 I2C1 保留(0x0F)，交给 VoodooI2C + VoodooI2CHID 驱动触摸板。
// D015 的 GSI=51 超过 APIC 兼容上限47，VoodooI2C 自动落 polling 模式，
// 正是官方文档推荐的"安装期安全模式"。
// config 中另 block AppleIntelLpssI2C / AppleIntelLpssI2CController。
DefinitionBlock ("", "SSDT", 2, "sqrl", "noi2c", 0x00000000)
{
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.I2C0, DeviceObj)
    External (_SB_.PCI0.I2C2, DeviceObj)
    External (_SB_.PCI0.I2C3, DeviceObj)
    External (_SB_.PCI0.I2C4, DeviceObj)
    External (_SB_.PCI0.I2C5, DeviceObj)

    Scope (\_SB.PCI0)
    {
        Scope (I2C0)
        {
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin")) { Return (Zero) } Else { Return (0x0F) }
            }
        }

        Scope (I2C2)
        {
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin")) { Return (Zero) } Else { Return (0x0F) }
            }
        }

        Scope (I2C3)
        {
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin")) { Return (Zero) } Else { Return (0x0F) }
            }
        }

        Scope (I2C4)
        {
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin")) { Return (Zero) } Else { Return (0x0F) }
            }
        }

        Scope (I2C5)
        {
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin")) { Return (Zero) } Else { Return (0x0F) }
            }
        }
    }
}
