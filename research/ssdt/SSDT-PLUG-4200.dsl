// C302CA (CAVE) / m3-6Y30, MrChromebox coreboot 4.20+
// coreboot 4.20 以 Device(CPxx)+ACPI0007 声明 CPU 且无 Processor 地址，
// macOS AppleACPICPU 无法枚举 -> 早期静默挂起。
// Darwin 下隐藏 CP00-CP03，重建为带地址的 Processor(CPU0-3)，CPU0 注入 plugin-type=1。
DefinitionBlock ("", "SSDT", 2, "sqrl", "plug4200", 0x00000000)
{
    External (_SB_, DeviceObj)
    External (_SB_.CP00, DeviceObj)
    External (_SB_.CP01, DeviceObj)
    External (_SB_.CP02, DeviceObj)
    External (_SB_.CP03, DeviceObj)

    Scope (\_SB)
    {
        Scope (CP00)
        {
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin")) { Return (Zero) } Else { Return (0x0F) }
            }
        }
        Scope (CP01)
        {
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin")) { Return (Zero) } Else { Return (0x0F) }
            }
        }
        Scope (CP02)
        {
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin")) { Return (Zero) } Else { Return (0x0F) }
            }
        }
        Scope (CP03)
        {
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin")) { Return (Zero) } Else { Return (0x0F) }
            }
        }

        Processor (CPU0, 0x00, 0x00000410, 0x06)
        {
            Name (_HID, "ACPI0007")
            Name (_UID, Zero)
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin")) { Return (0x0F) } Else { Return (Zero) }
            }
            Method (_DSM, 4, NotSerialized)
            {
                If (Arg2 == Zero) { Return (Buffer (One) { 0x03 }) }
                Return (Package (0x02) { "plugin-type", One })
            }
        }

        Processor (CPU1, 0x01, 0x00000410, 0x06)
        {
            Name (_HID, "ACPI0007")
            Name (_UID, One)
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin")) { Return (0x0F) } Else { Return (Zero) }
            }
        }

        Processor (CPU2, 0x02, 0x00000410, 0x06)
        {
            Name (_HID, "ACPI0007")
            Name (_UID, 0x02)
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin")) { Return (0x0F) } Else { Return (Zero) }
            }
        }

        Processor (CPU3, 0x03, 0x00000410, 0x06)
        {
            Name (_HID, "ACPI0007")
            Name (_UID, 0x03)
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin")) { Return (0x0F) } Else { Return (Zero) }
            }
        }
    }
}
