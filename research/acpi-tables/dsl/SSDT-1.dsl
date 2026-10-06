/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20260408 (32-bit version)
 * Copyright (c) 2000 - 2026 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of SSDT-1.aml
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000149E (5278)
 *     Revision         0x02
 *     Checksum         0xC8
 *     OEM ID           "COREv4"
 *     OEM Table ID     "COREBOOT"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "CORE"
 *     Compiler Version 0x20250807 (539297799)
 */
DefinitionBlock ("", "SSDT", 2, "COREv4", "COREBOOT", 0x00000000)
{
    /*
     * iASL Warning: There were 8 external control methods found during
     * disassembly, but only 0 were resolved (8 unresolved). Additional
     * ACPI tables may be required to properly disassemble the code. This
     * resulting disassembler output file may not compile because the
     * disassembler did not know how many arguments to assign to the
     * unresolved methods. Note: SSDTs can be dynamically loaded at
     * runtime and may or may not be available via the host OS.
     *
     * To specify the tables needed to resolve external control method
     * references, the -e option can be used to specify the filenames.
     * Example iASL invocations:
     *     iasl -e ssdt1.aml ssdt2.aml ssdt3.aml -d dsdt.aml
     *     iasl -e dsdt.aml ssdt2.aml -d ssdt1.aml
     *     iasl -e ssdt*.aml -d dsdt.aml
     *
     * In addition, the -fe option can be used to specify a file containing
     * control method external declarations with the associated method
     * argument counts. Each line of the file must be of the form:
     *     External (<method pathname>, MethodObj, <argument count>)
     * Invocation:
     *     iasl -fe refs.txt -d dsdt.aml
     *
     * The following methods were unresolved and many not compile properly
     * because the disassembler had to guess at the number of arguments
     * required for each:
     */
    External (_SB_.MDSX, MethodObj)    // Warning: Unknown method, guessing 1 arguments
    External (_SB_.MS0X, MethodObj)    // Warning: Unknown method, guessing 1 arguments
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.EGPM, MethodObj)    // Warning: Unknown method, guessing 0 arguments
    External (_SB_.PCI0.GFX0, DeviceObj)
    External (_SB_.PCI0.GFX0.XBCL, IntObj)
    External (_SB_.PCI0.GFX0.XBCM, MethodObj)    // Warning: Unknown method, guessing 1 arguments
    External (_SB_.PCI0.GFX0.XBQC, IntObj)
    External (_SB_.PCI0.HDAS, DeviceObj)
    External (_SB_.PCI0.I2C0, DeviceObj)
    External (_SB_.PCI0.I2C1, DeviceObj)
    External (_SB_.PCI0.I2C4, DeviceObj)
    External (_SB_.PCI0.LPCB.EC0_.EDSX, MethodObj)    // Warning: Unknown method, guessing 1 arguments
    External (_SB_.PCI0.LPCB.EC0_.S0IX, MethodObj)    // Warning: Unknown method, guessing 1 arguments
    External (_SB_.PCI0.LPCB.EC__.S0IX, MethodObj)    // Warning: Unknown method, guessing 1 arguments
    External (_SB_.PCI0.RGPM, MethodObj)    // Warning: Unknown method, guessing 0 arguments
    External (_SB_.PCI0.SDXC, DeviceObj)
    External (_SB_.PCI0.TPM_.USER, UnknownObj)
    External (PRRS, IntObj)
    External (RSTT, IntObj)
    External (WFDL, UnknownObj)

    Device (CTBL)
    {
        Name (_HID, "BOOT0000")  // _HID: Hardware ID
        Name (_UID, Zero)  // _UID: Unique ID
        Method (_STA, 0, NotSerialized)  // _STA: Status
        {
            Return (0x0F)
        }

        Name (_CRS, Buffer (0x001C)  // _CRS: Current Resource Settings
        {
            /* 0000 */  0x87, 0x17, 0x00, 0x00, 0x1C, 0x02, 0x00, 0x00,  // ........
            /* 0008 */  0x00, 0x00, 0x00, 0xD0, 0xA0, 0x7A, 0xFF, 0x4F,  // .....z.O
            /* 0010 */  0xA1, 0x7A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,  // .z......
            /* 0018 */  0x00, 0x00, 0x79, 0x00                           // ..y.
        })
    }

    Device (\_SB.CP00)
    {
        Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
        Name (_UID, Zero)  // _UID: Unique ID
        Name (_CST, Package (0x04)  // _CST: C-States
        {
            0x03, 
            Package (0x04)
            {
                Buffer (0x0011)
                {
                    /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x01, 0x02, 0x01, 0x01,  // ........
                    /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                    /* 0010 */  0x00                                             // .
                }, 

                0x01, 
                0x0000, 
                0x000003E8
            }, 

            Package (0x04)
            {
                Buffer (0x0011)
                {
                    /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x01, 0x02, 0x01, 0x33,  // .......3
                    /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                    /* 0010 */  0x00                                             // .
                }, 

                0x02, 
                0x0097, 
                0x000000C8
            }, 

            Package (0x04)
            {
                Buffer (0x0011)
                {
                    /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x01, 0x02, 0x01, 0x60,  // .......`
                    /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                    /* 0010 */  0x00                                             // .
                }, 

                0x03, 
                0x040A, 
                0x000000C8
            }
        })
        Name (GCPC, Package (0x15)
        {
            0x00000015, 
            0x02, 
            Buffer (0x0011)
            {
                /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x08, 0x00, 0x04, 0x71,  // .......q
                /* 0008 */  0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                /* 0010 */  0x00                                             // .
            }, 

            Buffer (0x0011)
            {
                /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x08, 0x08, 0x04, 0xCE,  // ........
                /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                /* 0010 */  0x00                                             // .
            }, 

            Buffer (0x0011)
            {
                /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x08, 0x10, 0x04, 0x71,  // .......q
                /* 0008 */  0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                /* 0010 */  0x00                                             // .
            }, 

            Buffer (0x0011)
            {
                /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x08, 0x18, 0x04, 0x71,  // .......q
                /* 0008 */  0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                /* 0010 */  0x00                                             // .
            }, 

            Buffer (0x0011)
            {
                /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x08, 0x08, 0x04, 0x71,  // .......q
                /* 0008 */  0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                /* 0010 */  0x00                                             // .
            }, 

            Buffer (0x0011)
            {
                /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x08, 0x10, 0x04, 0x74,  // .......t
                /* 0008 */  0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                /* 0010 */  0x00                                             // .
            }, 

            Buffer (0x0011)
            {
                /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x08, 0x00, 0x04, 0x74,  // .......t
                /* 0008 */  0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                /* 0010 */  0x00                                             // .
            }, 

            Buffer (0x0011)
            {
                /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x08, 0x08, 0x04, 0x74,  // .......t
                /* 0008 */  0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                /* 0010 */  0x00                                             // .
            }, 

            Buffer (0x0011)
            {
                /* 0000 */  0x82, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                /* 0010 */  0x00                                             // .
            }, 

            Buffer (0x0011)
            {
                /* 0000 */  0x82, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                /* 0010 */  0x00                                             // .
            }, 

            Buffer (0x0011)
            {
                /* 0000 */  0x82, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                /* 0010 */  0x00                                             // .
            }, 

            Buffer (0x0011)
            {
                /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x40, 0x00, 0x04, 0xE7,  // ....@...
                /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                /* 0010 */  0x00                                             // .
            }, 

            Buffer (0x0011)
            {
                /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x40, 0x00, 0x04, 0xE8,  // ....@...
                /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                /* 0010 */  0x00                                             // .
            }, 

            Buffer (0x0011)
            {
                /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x01, 0x02, 0x04, 0x77,  // .......w
                /* 0008 */  0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                /* 0010 */  0x00                                             // .
            }, 

            Buffer (0x0011)
            {
                /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x01, 0x00, 0x04, 0x70,  // .......p
                /* 0008 */  0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                /* 0010 */  0x00                                             // .
            }, 

            0x00000001, 
            Buffer (0x0011)
            {
                /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x0A, 0x20, 0x04, 0x74,  // ..... .t
                /* 0008 */  0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                /* 0010 */  0x00                                             // .
            }, 

            Buffer (0x0011)
            {
                /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x08, 0x18, 0x04, 0x74,  // .......t
                /* 0008 */  0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                /* 0010 */  0x00                                             // .
            }, 

            Buffer (0x0011)
            {
                /* 0000 */  0x82, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                /* 0010 */  0x00                                             // .
            }
        })
        Method (_CPC, 0, NotSerialized)  // _CPC: Continuous Performance Control
        {
            Return (\_SB.CP00.GCPC)
        }
    }

    Device (\_SB.CP01)
    {
        Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
        Name (_UID, One)  // _UID: Unique ID
        Name (_CST, Package (0x04)  // _CST: C-States
        {
            0x03, 
            Package (0x04)
            {
                Buffer (0x0011)
                {
                    /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x01, 0x02, 0x01, 0x01,  // ........
                    /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                    /* 0010 */  0x00                                             // .
                }, 

                0x01, 
                0x0000, 
                0x000003E8
            }, 

            Package (0x04)
            {
                Buffer (0x0011)
                {
                    /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x01, 0x02, 0x01, 0x33,  // .......3
                    /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                    /* 0010 */  0x00                                             // .
                }, 

                0x02, 
                0x0097, 
                0x000000C8
            }, 

            Package (0x04)
            {
                Buffer (0x0011)
                {
                    /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x01, 0x02, 0x01, 0x60,  // .......`
                    /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                    /* 0010 */  0x00                                             // .
                }, 

                0x03, 
                0x040A, 
                0x000000C8
            }
        })
        Method (_CPC, 0, NotSerialized)  // _CPC: Continuous Performance Control
        {
            Return (\_SB.CP00.GCPC)
        }
    }

    Device (\_SB.CP02)
    {
        Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
        Name (_UID, 0x02)  // _UID: Unique ID
        Name (_CST, Package (0x04)  // _CST: C-States
        {
            0x03, 
            Package (0x04)
            {
                Buffer (0x0011)
                {
                    /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x01, 0x02, 0x01, 0x01,  // ........
                    /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                    /* 0010 */  0x00                                             // .
                }, 

                0x01, 
                0x0000, 
                0x000003E8
            }, 

            Package (0x04)
            {
                Buffer (0x0011)
                {
                    /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x01, 0x02, 0x01, 0x33,  // .......3
                    /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                    /* 0010 */  0x00                                             // .
                }, 

                0x02, 
                0x0097, 
                0x000000C8
            }, 

            Package (0x04)
            {
                Buffer (0x0011)
                {
                    /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x01, 0x02, 0x01, 0x60,  // .......`
                    /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                    /* 0010 */  0x00                                             // .
                }, 

                0x03, 
                0x040A, 
                0x000000C8
            }
        })
        Method (_CPC, 0, NotSerialized)  // _CPC: Continuous Performance Control
        {
            Return (\_SB.CP00.GCPC)
        }
    }

    Device (\_SB.CP03)
    {
        Name (_HID, "ACPI0007" /* Processor Device */)  // _HID: Hardware ID
        Name (_UID, 0x03)  // _UID: Unique ID
        Name (_CST, Package (0x04)  // _CST: C-States
        {
            0x03, 
            Package (0x04)
            {
                Buffer (0x0011)
                {
                    /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x01, 0x02, 0x01, 0x01,  // ........
                    /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                    /* 0010 */  0x00                                             // .
                }, 

                0x01, 
                0x0000, 
                0x000003E8
            }, 

            Package (0x04)
            {
                Buffer (0x0011)
                {
                    /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x01, 0x02, 0x01, 0x33,  // .......3
                    /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                    /* 0010 */  0x00                                             // .
                }, 

                0x02, 
                0x0097, 
                0x000000C8
            }, 

            Package (0x04)
            {
                Buffer (0x0011)
                {
                    /* 0000 */  0x82, 0x0C, 0x00, 0x7F, 0x01, 0x02, 0x01, 0x60,  // .......`
                    /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79,  // .......y
                    /* 0010 */  0x00                                             // .
                }, 

                0x03, 
                0x040A, 
                0x000000C8
            }
        })
        Method (_CPC, 0, NotSerialized)  // _CPC: Continuous Performance Control
        {
            Return (\_SB.CP00.GCPC)
        }
    }

    Name (PPKG, Package (0x04)
    {
        \_SB.CP00, , 
        \_SB.CP01, , 
        \_SB.CP02, , 
        \_SB.CP03, 
    })
    Method (\_SB.CNOT, 1, NotSerialized)
    {
        Notify (\_SB.CP00, Arg0)
        Notify (\_SB.CP01, Arg0)
        Notify (\_SB.CP02, Arg0)
        Notify (\_SB.CP03, Arg0)
    }

    Scope (\_SB.PCI0)
    {
        Name (A4GB, 0x000000027F000000)
        Name (A4GS, 0x0000007D81000000)
    }

    Scope (\_SB.PCI0.GFX0)
    {
        Method (_DOD, 0, NotSerialized)  // _DOD: Display Output Devices
        {
            Return (Package (0x03)
            {
                0x80010100, 
                0x80010240, 
                0x80010410
            })
        }

        Device (VGA0)
        {
            Name (_ADR, 0x00000100)  // _ADR: Address
            Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
            {
                Return (0x1D)
            }

            Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
            {
                Return (Zero)
            }

            Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
            {
            }
        }

        Device (TV0)
        {
            Name (_ADR, 0x00000240)  // _ADR: Address
            Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
            {
                Return (0x1D)
            }

            Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
            {
                Return (Zero)
            }

            Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
            {
            }
        }

        Device (LCD0)
        {
            Name (_ADR, 0x00000410)  // _ADR: Address
            Method (_BCL, 0, NotSerialized)  // _BCL: Brightness Control Levels
            {
                Return (^^XBCL) /* External reference */
            }

            Method (_BCM, 1, NotSerialized)  // _BCM: Brightness Control Method
            {
                ^^XBCM (Arg0)
            }

            Method (_BQC, 0, NotSerialized)  // _BQC: Brightness Query Current
            {
                Return (^^XBQC) /* External reference */
            }

            Method (_DCS, 0, NotSerialized)  // _DCS: Display Current Status
            {
                Return (0x1D)
            }

            Method (_DGS, 0, NotSerialized)  // _DGS: Display Graphics State
            {
                Return (Zero)
            }

            Method (_DSS, 1, NotSerialized)  // _DSS: Device Set State
            {
            }
        }
    }

    Scope (\_SB.PCI0.I2C0)
    {
        Name (FMCN, Package (0x03)
        {
            0x005E, 
            0x00BF, 
            0x00000024
        })
    }

    Scope (\_SB.PCI0.I2C1)
    {
        Name (FMCN, Package (0x03)
        {
            0x005E, 
            0x00BF, 
            0x00000024
        })
    }

    Scope (\_SB.PCI0.I2C4)
    {
        Name (FMCN, Package (0x03)
        {
            0x005E, 
            0x00BF, 
            0x00000024
        })
    }

    Scope (\_SB.PCI0.SDXC)
    {
        Name (_CRS, Buffer (0x002A)  // _CRS: Current Resource Settings
        {
            /* 0000 */  0x8C, 0x25, 0x00, 0x01, 0x00, 0x01, 0x00, 0x1D,  // .%......
            /* 0008 */  0x00, 0x03, 0x00, 0x00, 0x10, 0x27, 0x17, 0x00,  // .....'..
            /* 0010 */  0x00, 0x19, 0x00, 0x28, 0x00, 0x00, 0x00, 0x07,  // ...(....
            /* 0018 */  0x00, 0x5C, 0x5F, 0x53, 0x42, 0x2E, 0x50, 0x43,  // .\_SB.PC
            /* 0020 */  0x49, 0x30, 0x2E, 0x47, 0x50, 0x49, 0x4F, 0x00,  // I0.GPIO.
            /* 0028 */  0x79, 0x00                                       // y.
        })
        Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
        {
            ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301") /* Device Properties for _DSD */, 
            Package (0x01)
            {
                Package (0x02)
                {
                    "cd-gpio", 
                    Package (0x04)
                    {
                        \_SB.PCI0.SDXC, , 
                        Zero, 
                        Zero, 
                        One
                    }
                }
            }
        })
    }

    Scope (\_SB.PCI0)
    {
        Device (PEPD)
        {
            Name (_HID, "INT33A1" /* Intel Power Engine */)  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0D80") /* Windows-compatible System Power Management Controller */)  // _CID: Compatible ID
            Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
            {
                ToBuffer (Arg0, Local0)
                If ((Local0 == ToUUID ("c4eb40a0-6cd2-11e2-bcfd-0800200c9a66") /* Modern Standby Intel */))
                {
                    ToInteger (Arg2, Local1)
                    If ((Local1 == Zero))
                    {
                        Return (Buffer (One)
                        {
                             0x7B                                             // {
                        })
                    }

                    If ((Local1 == One))
                    {
                        Return (Package (0x01)
                        {
                            Package (0x03)
                            {
                                \_SB.CP00, , 
                                Zero, 
                                Package (0x02)
                                {
                                    Zero, 
                                    Package (0x02)
                                    {
                                        0xFF, 
                                        Zero
                                    }
                                }
                            }
                        })
                    }

                    If ((Local1 == 0x02)){}
                    If ((Local1 == 0x03))
                    {
                        If (CondRefOf (\_SB.PCI0.LPCB.EC0.EDSX))
                        {
                            \_SB.PCI0.LPCB.EC0.EDSX (Zero)
                        }

                        If (CondRefOf (\_SB.MDSX))
                        {
                            \_SB.MDSX (Zero)
                        }
                    }

                    If ((Local1 == 0x04))
                    {
                        If (CondRefOf (\_SB.PCI0.LPCB.EC0.EDSX))
                        {
                            \_SB.PCI0.LPCB.EC0.EDSX (One)
                        }

                        If (CondRefOf (\_SB.MDSX))
                        {
                            \_SB.MDSX (One)
                        }
                    }

                    If ((Local1 == 0x05))
                    {
                        If (CondRefOf (\_SB.PCI0.LPCB.EC.S0IX))
                        {
                            \_SB.PCI0.LPCB.EC.S0IX (One)
                        }

                        If (CondRefOf (\_SB.PCI0.LPCB.EC0.S0IX))
                        {
                            \_SB.PCI0.LPCB.EC0.S0IX (One)
                        }

                        If (CondRefOf (\_SB.MS0X))
                        {
                            \_SB.MS0X (One)
                        }

                        If (CondRefOf (\_SB.PCI0.EGPM))
                        {
                            \_SB.PCI0.EGPM ()
                        }
                    }

                    If ((Local1 == 0x06))
                    {
                        If (CondRefOf (\_SB.PCI0.LPCB.EC.S0IX))
                        {
                            \_SB.PCI0.LPCB.EC.S0IX (Zero)
                        }

                        If (CondRefOf (\_SB.PCI0.LPCB.EC0.S0IX))
                        {
                            \_SB.PCI0.LPCB.EC0.S0IX (Zero)
                        }

                        If (CondRefOf (\_SB.MS0X))
                        {
                            \_SB.MS0X (Zero)
                        }

                        If (CondRefOf (\_SB.PCI0.RGPM))
                        {
                            \_SB.PCI0.RGPM ()
                        }
                    }

                    Return (Buffer (One)
                    {
                         0x00                                             // .
                    })
                }

                Return (Buffer (One)
                {
                     0x00                                             // .
                })
            }
        }
    }

    Scope (\_SB.PCI0.I2C0)
    {
        Device (D010)
        {
            Name (_HID, "ELAN0001")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_DDN, "ELAN Touchscreen")  // _DDN: DOS Device Name
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Name (_CRS, Buffer (0x002C)  // _CRS: Current Resource Settings
            {
                /* 0000 */  0x8E, 0x1E, 0x00, 0x01, 0x00, 0x01, 0x02, 0x00,  // ........
                /* 0008 */  0x00, 0x01, 0x06, 0x00, 0x80, 0x1A, 0x06, 0x00,  // ........
                /* 0010 */  0x10, 0x00, 0x5C, 0x5F, 0x53, 0x42, 0x2E, 0x50,  // ..\_SB.P
                /* 0018 */  0x43, 0x49, 0x30, 0x2E, 0x49, 0x32, 0x43, 0x30,  // CI0.I2C0
                /* 0020 */  0x00, 0x89, 0x06, 0x00, 0x07, 0x01, 0x1F, 0x00,  // ........
                /* 0028 */  0x00, 0x00, 0x79, 0x00                           // ..y.
            })
        }
    }

    Scope (\_SB.PCI0.I2C1)
    {
        Device (D015)
        {
            Name (_HID, "ELAN0000")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_DDN, "ELAN Touchpad")  // _DDN: DOS Device Name
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Name (_CRS, Buffer (0x002C)  // _CRS: Current Resource Settings
            {
                /* 0000 */  0x8E, 0x1E, 0x00, 0x01, 0x00, 0x01, 0x02, 0x00,  // ........
                /* 0008 */  0x00, 0x01, 0x06, 0x00, 0x80, 0x1A, 0x06, 0x00,  // ........
                /* 0010 */  0x15, 0x00, 0x5C, 0x5F, 0x53, 0x42, 0x2E, 0x50,  // ..\_SB.P
                /* 0018 */  0x43, 0x49, 0x30, 0x2E, 0x49, 0x32, 0x43, 0x31,  // CI0.I2C1
                /* 0020 */  0x00, 0x89, 0x06, 0x00, 0x0D, 0x01, 0x33, 0x00,  // ......3.
                /* 0028 */  0x00, 0x00, 0x79, 0x00                           // ..y.
            })
            Name (_S0W, 0x03)  // _S0W: S0 Device Wake State
            Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
            {
                0x05, 
                0x03
            })
        }
    }

    Scope (\_SB.PCI0.I2C4)
    {
        Device (NAU8)
        {
            Name (_HID, "10508825")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_DDN, "Nuvoton NAU8825 Codec")  // _DDN: DOS Device Name
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Name (_CRS, Buffer (0x002C)  // _CRS: Current Resource Settings
            {
                /* 0000 */  0x8E, 0x1E, 0x00, 0x01, 0x00, 0x01, 0x02, 0x00,  // ........
                /* 0008 */  0x00, 0x01, 0x06, 0x00, 0x80, 0x1A, 0x06, 0x00,  // ........
                /* 0010 */  0x1A, 0x00, 0x5C, 0x5F, 0x53, 0x42, 0x2E, 0x50,  // ..\_SB.P
                /* 0018 */  0x43, 0x49, 0x30, 0x2E, 0x49, 0x32, 0x43, 0x34,  // CI0.I2C4
                /* 0020 */  0x00, 0x89, 0x06, 0x00, 0x0D, 0x01, 0x3A, 0x00,  // ......:.
                /* 0028 */  0x00, 0x00, 0x79, 0x00                           // ..y.
            })
            Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
            {
                ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301") /* Device Properties for _DSD */, 
                Package (0x10)
                {
                    Package (0x02)
                    {
                        "nuvoton,jkdet-enable", 
                        One
                    }, 

                    Package (0x02)
                    {
                        "nuvoton,jkdet-pull-enable", 
                        Zero
                    }, 

                    Package (0x02)
                    {
                        "nuvoton,jkdet-pull-up", 
                        Zero
                    }, 

                    Package (0x02)
                    {
                        "nuvoton,jkdet-polarity", 
                        One
                    }, 

                    Package (0x02)
                    {
                        "nuvoton,vref-impedance", 
                        0x02
                    }, 

                    Package (0x02)
                    {
                        "nuvoton,micbias-voltage", 
                        0x06
                    }, 

                    Package (0x02)
                    {
                        "nuvoton,sar-hysteresis", 
                        One
                    }, 

                    Package (0x02)
                    {
                        "nuvoton,sar-voltage", 
                        Zero
                    }, 

                    Package (0x02)
                    {
                        "nuvoton,sar-compare-time", 
                        Zero
                    }, 

                    Package (0x02)
                    {
                        "nuvoton,sar-sampling-time", 
                        Zero
                    }, 

                    Package (0x02)
                    {
                        "nuvoton,short-key-debounce", 
                        0x02
                    }, 

                    Package (0x02)
                    {
                        "nuvoton,jack-insert-debounce", 
                        0x07
                    }, 

                    Package (0x02)
                    {
                        "nuvoton,jack-eject-debounce", 
                        0x07
                    }, 

                    Package (0x02)
                    {
                        "nuvoton,sar-threshold-num", 
                        0x04
                    }, 

                    Package (0x02)
                    {
                        "nuvoton,adcout-drive-strong", 
                        Zero
                    }, 

                    Package (0x02)
                    {
                        "nuvoton,sar-threshold", 
                        Package (0x04)
                        {
                            0x0C, 
                            0x1E, 
                            0x38, 
                            0x60
                        }
                    }
                }
            })
        }
    }

    Device (\_SB.PCI0.RP01.WF00)
    {
        Name (_UID, 0x923ACF1C)  // _UID: Unique ID
        Name (_DDN, "WIFI Device")  // _DDN: DOS Device Name
        Name (_ADR, 0x0000000000000000)  // _ADR: Address
    }

    Scope (\_SB.PCI0.RP01.WF00)
    {
        Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
        {
            0x10, 
            0x03
        })
        Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
        {
            ToBuffer (Arg0, Local0)
            If ((Local0 == ToUUID ("7266172c-220b-4b29-814f-75e4dd26b5fd") /* Unknown UUID */))
            {
                ToInteger (Arg2, Local1)
                If ((Local1 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x2D                                             // -
                    })
                }

                If ((Local1 == One)){}
                If ((Local1 == 0x02))
                {
                    CreateWordField (Arg3, Zero, CMDT)
                    CreateWordField (Arg3, 0x02, CMDP)
                    If ((CMDT == One))
                    {
                        If (CondRefOf (RSTT))
                        {
                            Return (RSTT) /* External reference */
                        }

                        Return (Zero)
                    }

                    If ((CMDT == 0x02))
                    {
                        If (CondRefOf (RSTT))
                        {
                            RSTT = CMDP /* \_SB_.PCI0.RP01.WF00._DSM.CMDP */
                        }

                        Return (Zero)
                    }

                    If ((CMDT == 0x03))
                    {
                        If (CondRefOf (PRRS))
                        {
                            Return (PRRS) /* External reference */
                        }

                        Return (Zero)
                    }

                    Return (Zero)
                }

                If ((Local1 == 0x03))
                {
                    Return (One)
                }

                If ((Local1 == 0x04)){}
                If ((Local1 == 0x05))
                {
                    If (CondRefOf (WFDL))
                    {
                        WFDL = Arg3
                    }
                }

                Return (Buffer (One)
                {
                     0x00                                             // .
                })
            }

            Return (Buffer (One)
            {
                 0x00                                             // .
            })
        }
    }

    Scope (\_SB.PCI0)
    {
        Device (TPM)
        {
            Name (_HID, EisaId ("PNP0C31"))  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0C31"))  // _CID: Compatible ID
            Name (_UID, 0x89E37D9C)  // _UID: Unique ID
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Name (_CRS, Buffer (0x0016)  // _CRS: Current Resource Settings
            {
                /* 0000 */  0x86, 0x09, 0x00, 0x01, 0x00, 0x00, 0xD4, 0xFE,  // ........
                /* 0008 */  0x00, 0x50, 0x00, 0x00, 0x47, 0x01, 0x31, 0x0C,  // .P..G.1.
                /* 0010 */  0x31, 0x0C, 0x01, 0x02, 0x79, 0x00               // 1...y.
            })
            OperationRegion (PPOP, SystemMemory, 0x7AFFE540, 0x015A)
            Field (PPOP, AnyAcc, NoLock, Preserve)
            {
                Offset (0x100), 
                PPIN,   8, 
                PPIP,   32, 
                RESU,   32, 
                CMDR,   32, 
                OARG,   32, 
                LCMD,   32, 
                FRET,   32
            }

            Name (TPM2, Package (0x02)
            {
                0x00000000, 
                0x00000000
            })
            Name (TPM3, Package (0x03)
            {
                0x00000000, 
                0x00000000, 
                0x00000000
            })
            Method (FUNC, 1, Serialized)
            {
                ToInteger (Arg0, Local0)
                If ((Local0 > 0x80))
                {
                    Return (Zero)
                }

                Local1 = (Local0 * 0x08)
                CreateField (PPOP, Local1, 0x08, TPPF)
                ToInteger (TPPF, Local0)
                Return (Local0)
            }

            Method (FSUP, 2, NotSerialized)
            {
                ToInteger (Arg0, Local0)
                ToInteger (Arg1, Local1)
                If ((Local0 > 0x80))
                {
                    Return (Zero)
                }

                If ((Local1 == One))
                {
                    If ((Local0 == Zero))
                    {
                        Return (One)
                    }

                    If ((Local0 == One))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x02))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x03))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x04))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x05))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x06))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x07))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x08))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x09))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x0A))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x0B))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x0E))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x0F))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x10))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x15))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x16))
                    {
                        Return (One)
                    }
                }

                If ((Local1 == Zero))
                {
                    If ((Local0 == Zero))
                    {
                        Return (One)
                    }

                    If ((Local0 == One))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x02))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x05))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x0E))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x11))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x12))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x15))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x16))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x17))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x18))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x19))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x1A))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x1B))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x1C))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x1D))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x1E))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x1F))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x20))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x21))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x22))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x60))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x61))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x62))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x63))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x64))
                    {
                        Return (One)
                    }

                    If ((Local0 == 0x65))
                    {
                        Return (One)
                    }
                }

                Return (Zero)
            }

            Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
            {
                ToBuffer (Arg0, Local0)
                If ((Local0 == ToUUID ("3dddfaa6-361b-4eb4-a424-8d10089d1653") /* Physical Presence Interface */))
                {
                    ToInteger (Arg2, Local1)
                    If ((Local1 == Zero))
                    {
                        Return (Buffer (0x02)
                        {
                             0xFF, 0x01                                       // ..
                        })
                    }

                    If ((Local1 == One))
                    {
                        Return ("1.2")
                    }

                    If ((Local1 == 0x02))
                    {
                        ToInteger (Arg1, Local0)
                        If ((Local0 == One))
                        {
                            Local1 = ObjectType (Arg3)
                            If ((Local1 == 0x04))
                            {
                                Local2 = DerefOf (Arg3 [Zero])
                            }

                            Local1 = ObjectType (Arg3)
                            If ((Local1 == 0x03))
                            {
                                ToInteger (Arg3, Local2)
                            }

                            Local1 = ^FSUP (Local2, One)
                            If ((Local1 == Zero))
                            {
                                Local1 = ^FSUP (Local2, Zero)
                                If ((Local1 == One))
                                {
                                    Return (Zero)
                                }

                                Return (One)
                            }

                            ^CMDR = Local2
                            ^OARG = Zero
                            ^USER = Zero
                            Return (Zero)
                        }

                        Return (0x02)
                    }

                    If ((Local1 == 0x03))
                    {
                        Local0 = One
                        ^TPM3 [Zero] = Local0
                        ^TPM2 [Zero] = Local0
                        ToInteger (Arg1, Local0)
                        If ((Local0 == One))
                        {
                            Local1 = Zero
                            ^TPM2 [Zero] = Local1
                            ^TPM2 [One] = ^CMDR /* \_SB_.PCI0.TPM_.CMDR */
                            Return (^TPM2) /* \_SB_.PCI0.TPM_.TPM2 */
                        }

                        If ((Local0 == 0x02))
                        {
                            Local1 = Zero
                            ^TPM3 [Zero] = Local1
                            ^TPM3 [One] = ^CMDR /* \_SB_.PCI0.TPM_.CMDR */
                            ^TPM3 [0x02] = ^OARG /* \_SB_.PCI0.TPM_.OARG */
                            Return (^TPM3) /* \_SB_.PCI0.TPM_.TPM3 */
                        }

                        Return (^TPM3) /* \_SB_.PCI0.TPM_.TPM3 */
                    }

                    If ((Local1 == 0x04))
                    {
                        Return (0x02)
                    }

                    If ((Local1 == 0x05))
                    {
                        Local1 = One
                        ^TPM3 [Zero] = Local1
                        ToInteger (Arg1, Local0)
                        If ((Local0 == One))
                        {
                            Local1 = Zero
                            ^TPM3 [Zero] = Local1
                            ^TPM3 [One] = ^LCMD /* \_SB_.PCI0.TPM_.LCMD */
                            ^TPM3 [0x02] = ^RESU /* \_SB_.PCI0.TPM_.RESU */
                        }

                        Return (^TPM3) /* \_SB_.PCI0.TPM_.TPM3 */
                    }

                    If ((Local1 == 0x06))
                    {
                        Return (0x03)
                    }

                    If ((Local1 == 0x07))
                    {
                        ToInteger (Arg1, Local0)
                        Local1 = ObjectType (Arg3)
                        If ((Local1 == 0x04))
                        {
                            Local2 = DerefOf (Arg3 [Zero])
                        }

                        Local1 = ObjectType (Arg3)
                        If ((Local1 == 0x03))
                        {
                            ToInteger (Arg3, Local2)
                        }

                        Local1 = ^FSUP (Local2, One)
                        If ((Local1 == Zero))
                        {
                            Local1 = ^FSUP (Local2, Zero)
                            If ((Local1 == One))
                            {
                                Return (Zero)
                            }

                            Return (One)
                        }

                        Local1 = ObjectType (Arg3)
                        If ((Local1 == 0x03))
                        {
                            Local0 = One
                        }

                        If ((Local0 == One))
                        {
                            ^CMDR = Local2
                            ^OARG = Zero
                            Return (0x00)
                        }

                        If ((Local0 == 0x02))
                        {
                            ^CMDR = Local2
                            Local3 = DerefOf (Arg3 [One])
                            ^OARG = Local3
                            Return (0x00)
                        }

                        Return (0x02)
                    }

                    If ((Local1 == 0x08))
                    {
                        ToInteger (Arg1, Local0)
                        If ((Local0 == One))
                        {
                            Local2 = DerefOf (Arg3 [Zero])
                            Local1 = ^FSUP (Local2, One)
                            If ((Local1 == Zero))
                            {
                                Return (0x00)
                            }

                            If ((Local2 == Zero))
                            {
                                Return (0x04)
                            }

                            If ((Local2 == 0x12))
                            {
                                Return (0x04)
                            }

                            If ((Local2 == 0x14))
                            {
                                Return (0x04)
                            }

                            If ((Local2 == 0x10))
                            {
                                Return (0x04)
                            }

                            Return (0x03)
                        }

                        Return (Zero)
                    }

                    Return (Buffer (One)
                    {
                         0x00                                             // .
                    })
                }

                If ((Local0 == ToUUID ("376054ed-cc13-4675-901c-4756d7f2d45d") /* TPM Memory Clear */))
                {
                    ToInteger (Arg2, Local1)
                    If ((Local1 == Zero))
                    {
                        Return (Buffer (One)
                        {
                             0x03                                             // .
                        })
                    }

                    If ((Local1 == One))
                    {
                        Return (0x00)
                    }

                    Return (Buffer (One)
                    {
                         0x00                                             // .
                    })
                }

                Return (Buffer (One)
                {
                     0x00                                             // .
                })
            }
        }
    }

    Scope (\_SB.PCI0.HDAS)
    {
        Device (MAXM)
        {
            Name (_HID, "MX98357A")  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_DDN, "Maxim Integrated 98357A Amplifier")  // _DDN: DOS Device Name
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Name (_CRS, Buffer (0x002A)  // _CRS: Current Resource Settings
            {
                /* 0000 */  0x8C, 0x25, 0x00, 0x01, 0x01, 0x01, 0x00, 0x02,  // .%......
                /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x17, 0x00,  // ........
                /* 0010 */  0x00, 0x19, 0x00, 0x28, 0x00, 0x00, 0x00, 0x63,  // ...(...c
                /* 0018 */  0x00, 0x5C, 0x5F, 0x53, 0x42, 0x2E, 0x50, 0x43,  // .\_SB.PC
                /* 0020 */  0x49, 0x30, 0x2E, 0x47, 0x50, 0x49, 0x4F, 0x00,  // I0.GPIO.
                /* 0028 */  0x79, 0x00                                       // y.
            })
            Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
            {
                ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301") /* Device Properties for _DSD */, 
                Package (0x02)
                {
                    Package (0x02)
                    {
                        "sdmode-gpio", 
                        Package (0x04)
                        {
                            \_SB.PCI0.HDAS.MAXM, , 
                            Zero, 
                            Zero, 
                            Zero
                        }
                    }, 

                    Package (0x02)
                    {
                        "sdmode-delay", 
                        0x05
                    }
                }
            })
        }
    }
}

