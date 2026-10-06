DefinitionBlock ("", "SSDT", 2, "TST", "TST", 0)
{
    Scope (\_SB.PCI0.LPCB)
    {
        Device (TST1) { Name (_HID, "ACID0001") }
    }
}
