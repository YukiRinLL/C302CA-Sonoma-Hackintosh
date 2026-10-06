/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20260408 (32-bit version)
 * Copyright (c) 2000 - 2026 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of SSDT-HS00.aml
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000064 (100)
 *     Revision         0x02
 *     Checksum         0x46
 *     OEM ID           "ACDT"
 *     OEM Table ID     "HS00"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20260408 (539362312)
 */
DefinitionBlock ("", "SSDT", 2, "ACDT", "HS00", 0x00000000)
{
    External (_SB_.PCI0.XHCI, DeviceObj)

    Scope (_SB.PCI0.XHCI)
    {
        If (_OSI ("Darwin"))
        {
            Device (HS00)
            {
                Name (_ADR, Zero)  // _ADR: Address
            }
        }
    }
}

