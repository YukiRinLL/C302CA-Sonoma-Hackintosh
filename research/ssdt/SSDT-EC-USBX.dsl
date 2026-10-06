// C302CA (CAVE): 真实 EC = _SB.PCI0.LPCB.EC0 (PNP0C09, Google EC)，保留给电池。
// 另建 macOS 期望的伪 EC(ACID0001)，并注入 USB 电源属性(USBX)。
// 编译: iasl -e DSDT.aml -e SSDT-1.aml
DefinitionBlock ("", "SSDT", 2, "ACDT", "ECUSBX", 0x00001000)
{
    Scope (\_SB.PCI0.LPCB)
    {
        Device (EC)
        {
            Name (_HID, "ACID0001")
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin")) { Return (0x0F) } Else { Return (Zero) }
            }
        }
    }

    Scope (\_SB)
    {
        Device (USBX)
        {
            Name (_ADR, Zero)
            Method (_DSM, 4, NotSerialized)
            {
                If (Arg2 == Zero) { Return (Buffer (One) { 0x03 }) }
                Return (Package (0x08)
                {
                    "kUSBSleepPowerSupply", 0x13EC,
                    "kUSBSleepPortCurrentLimit", 0x0834,
                    "kUSBWakePowerSupply", 0x13EC,
                    "kUSBWakePortCurrentLimit", 0x0834
                })
            }
        }
    }
}
