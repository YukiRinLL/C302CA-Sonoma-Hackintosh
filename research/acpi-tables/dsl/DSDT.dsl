/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20260408 (32-bit version)
 * Copyright (c) 2000 - 2026 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of DSDT.aml
 *
 * Original Table Header:
 *     Signature        "DSDT"
 *     Length           0x000049DB (18907)
 *     Revision         0x02
 *     Checksum         0x74
 *     OEM ID           "COREv4"
 *     OEM Table ID     "COREBOOT"
 *     OEM Revision     0x20110725 (537986853)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20250807 (539297799)
 */
DefinitionBlock ("", "DSDT", 2, "COREv4", "COREBOOT", 0x20110725)
{
    External (_SB_.CNOT, MethodObj)    // 1 Arguments
    External (_SB_.CP00._PSS, PkgObj)
    External (_SB_.DPTF.TPWR, DeviceObj)
    External (_SB_.MPDL, IntObj)
    External (_SB_.MPTS, MethodObj)    // 1 Arguments
    External (_SB_.MWAK, MethodObj)    // 1 Arguments
    External (_SB_.NAPE, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.A4GB, IntObj)
    External (_SB_.PCI0.A4GS, IntObj)
    External (_SB_.PCI0.EGPM, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.GFX0.LCD0, DeviceObj)
    External (_SB_.PCI0.LPCB.EC0_.PTS_, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.LPCB.EC0_.WAK_, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.RGPM, MethodObj)    // 0 Arguments
    External (A4GB, IntObj)
    External (A4GS, IntObj)
    External (DNVS, OpRegionObj)
    External (GNVS, OpRegionObj)
    External (MPDL, IntObj)
    External (OSFG, IntObj)

    Scope (\)
    {
        OperationRegion (GNVS, SystemMemory, 0x7AFFE6A0, 0x38)
    }

    Name (OSYS, Zero)
    Name (PICM, Zero)
    Name (PWRS, One)
    Method (_PIC, 1, NotSerialized)  // _PIC: Interrupt Model
    {
        PICM = Arg0
        If (CondRefOf (\_SB.NAPE))
        {
            \_SB.NAPE ()
        }
    }

    Scope (_SB)
    {
        Name (PCBA, 0xE0000000)
        Name (PCLN, 0x10000000)
        OperationRegion (PCFG, SystemMemory, PCBA, PCLN)
        Device (PERC)
        {
            Name (_HID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _HID: Hardware ID
            Name (RBUF, Buffer (0x30)
            {
                /* 0000 */  0x8A, 0x2B, 0x00, 0x00, 0x0D, 0x01, 0x00, 0x00,  // .+......
                /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                /* 0010 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00,  // ........
                /* 0018 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                /* 0020 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00,  // ........
                /* 0028 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79, 0x00   // ......y.
            })
            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                CreateQWordField (RBUF, 0x0E, MIN1)
                CreateQWordField (RBUF, 0x16, MAX1)
                CreateQWordField (RBUF, 0x26, LEN1)
                MIN1 = 0xE0000000
                MAX1 = ((MIN1 + 0x10000000) - One)
                LEN1 = 0x10000000
                Return (RBUF) /* \_SB_.PERC.RBUF */
            }
        }
    }

    Method (PNOT, 0, NotSerialized)
    {
        \_SB.CNOT (0x81)
    }

    Method (PPCN, 0, NotSerialized)
    {
        \_SB.CNOT (0x80)
    }

    Method (TNOT, 0, NotSerialized)
    {
        \_SB.CNOT (0x82)
    }

    Scope (_SB)
    {
        Method (_SWS, 0, NotSerialized)  // _SWS: System Wake Source
        {
            Return (PM1I) /* \PM1I */
        }
    }

    Scope (_GPE)
    {
        Method (_SWS, 0, NotSerialized)  // _SWS: System Wake Source
        {
            Return (GPEI) /* \GPEI */
        }
    }

    Name (DBG0, Zero)
    Method (_PTS, 1, NotSerialized)  // _PTS: Prepare To Sleep
    {
        DBG0 = 0x96
        If (CondRefOf (\_SB.PCI0.LPCB.EC0.PTS))
        {
            \_SB.PCI0.LPCB.EC0.PTS (Arg0)
        }

        If (CondRefOf (\_SB.MPTS))
        {
            \_SB.MPTS (Arg0)
        }

        If (CondRefOf (\_SB.PCI0.EGPM))
        {
            \_SB.PCI0.EGPM ()
        }
    }

    Method (_WAK, 1, NotSerialized)  // _WAK: Wake
    {
        DBG0 = 0x97
        If (CondRefOf (\_SB.PCI0.LPCB.EC0.WAK))
        {
            \_SB.PCI0.LPCB.EC0.WAK (Arg0)
        }

        If (CondRefOf (\_SB.MWAK))
        {
            \_SB.MWAK (Arg0)
        }

        If (CondRefOf (\_SB.PCI0.RGPM))
        {
            \_SB.PCI0.RGPM ()
        }

        Return (Package (0x02)
        {
            Zero, 
            Zero
        })
    }

    Field (GNVS, ByteAcc, NoLock, Preserve)
    {
        Offset (0x02), 
        SMIF,   8, 
        Offset (0x04), 
        PPCM,   8, 
        TLVL,   8, 
        LIDS,   8, 
        Offset (0x08), 
        Offset (0x0C), 
        PM1I,   64, 
        GPEI,   64, 
        DPTE,   8, 
        NHLA,   64, 
        NHLL,   32, 
        Offset (0x2B), 
        U2WE,   16, 
        U3WE,   16, 
        UIOR,   8, 
        Offset (0x38)
    }

    Name (SSFG, 0x0D)
    If (One)
    {
        SSFG &= 0xFE
    }

    If (Zero)
    {
        SSFG &= 0xF7
    }

    If (CondRefOf (\OSFG))
    {
        SSFG = OSFG /* External reference */
    }

    Name (_S0, Package (0x04)  // _S0_: S0 System State
    {
        Zero, 
        Zero, 
        Zero, 
        Zero
    })
    If ((SSFG & One))
    {
        Name (_S1, Package (0x04)  // _S1_: S1 System State
        {
            One, 
            Zero, 
            Zero, 
            Zero
        })
    }

    If ((SSFG & 0x04))
    {
        Name (_S3, Package (0x04)  // _S3_: S3 System State
        {
            0x05, 
            Zero, 
            Zero, 
            Zero
        })
    }

    If ((SSFG & 0x08))
    {
        Name (_S4, Package (0x04)  // _S4_: S4 System State
        {
            0x06, 
            0x04, 
            Zero, 
            Zero
        })
    }

    Name (_S5, Package (0x04)  // _S5_: S5 System State
    {
        0x07, 
        Zero, 
        Zero, 
        Zero
    })
    Scope (_SB)
    {
        Device (PCI0)
        {
            Name (_HID, EisaId ("PNP0A08") /* PCI Express Bus */)  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0A03") /* PCI Bus */)  // _CID: Compatible ID
            Name (_SEG, Zero)  // _SEG: PCI Segment
            Name (_UID, Zero)  // _UID: Unique ID
            Device (MCHC)
            {
                Name (_ADR, Zero)  // _ADR: Address
                OperationRegion (MCHP, PCI_Config, Zero, 0x0100)
                Field (MCHP, DWordAcc, NoLock, Preserve)
                {
                    Offset (0x40), 
                    EPEN,   1, 
                        ,   11, 
                    EPBR,   27, 
                    Offset (0x48), 
                    MHEN,   1, 
                        ,   14, 
                    MHBR,   24, 
                    Offset (0x60), 
                    PXEN,   1, 
                    PXSZ,   2, 
                        ,   23, 
                    PXBR,   13, 
                    Offset (0x68), 
                    DIEN,   1, 
                        ,   11, 
                    DIBR,   27, 
                    Offset (0x70), 
                    MEBA,   64, 
                    Offset (0xA0), 
                    TOM,    64, 
                    TUUD,   64, 
                    Offset (0xBC), 
                    TLUD,   32
                }
            }

            Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                Name (MCRS, Buffer (0x0236)
                {
                    /* 0000 */  0x88, 0x0D, 0x00, 0x02, 0x0C, 0x00, 0x00, 0x00,  // ........
                    /* 0008 */  0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x01,  // ........
                    /* 0010 */  0x87, 0x17, 0x00, 0x01, 0x0C, 0x03, 0x00, 0x00,  // ........
                    /* 0018 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF7, 0x0C,  // ........
                    /* 0020 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF8, 0x0C,  // ........
                    /* 0028 */  0x00, 0x00, 0x47, 0x01, 0xF8, 0x0C, 0xF8, 0x0C,  // ..G.....
                    /* 0030 */  0x01, 0x08, 0x87, 0x17, 0x00, 0x01, 0x0C, 0x03,  // ........
                    /* 0038 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00,  // ........
                    /* 0040 */  0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 0048 */  0x00, 0xF3, 0x00, 0x00, 0x87, 0x17, 0x00, 0x00,  // ........
                    /* 0050 */  0x0C, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 0058 */  0x0A, 0x00, 0xFF, 0xFF, 0x0B, 0x00, 0x00, 0x00,  // ........
                    /* 0060 */  0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x87, 0x17,  // ........
                    /* 0068 */  0x00, 0x00, 0x0C, 0x03, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 0070 */  0x00, 0x00, 0x0C, 0x00, 0xFF, 0x3F, 0x0C, 0x00,  // .....?..
                    /* 0078 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00,  // .....@..
                    /* 0080 */  0x87, 0x17, 0x00, 0x00, 0x0C, 0x03, 0x00, 0x00,  // ........
                    /* 0088 */  0x00, 0x00, 0x00, 0x40, 0x0C, 0x00, 0xFF, 0x7F,  // ...@....
                    /* 0090 */  0x0C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40,  // .......@
                    /* 0098 */  0x00, 0x00, 0x87, 0x17, 0x00, 0x00, 0x0C, 0x03,  // ........
                    /* 00A0 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x0C, 0x00,  // ........
                    /* 00A8 */  0xFF, 0xBF, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 00B0 */  0x00, 0x40, 0x00, 0x00, 0x87, 0x17, 0x00, 0x00,  // .@......
                    /* 00B8 */  0x0C, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC0,  // ........
                    /* 00C0 */  0x0C, 0x00, 0xFF, 0xFF, 0x0C, 0x00, 0x00, 0x00,  // ........
                    /* 00C8 */  0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x87, 0x17,  // ...@....
                    /* 00D0 */  0x00, 0x00, 0x0C, 0x03, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 00D8 */  0x00, 0x00, 0x0D, 0x00, 0xFF, 0x3F, 0x0D, 0x00,  // .....?..
                    /* 00E0 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00,  // .....@..
                    /* 00E8 */  0x87, 0x17, 0x00, 0x00, 0x0C, 0x03, 0x00, 0x00,  // ........
                    /* 00F0 */  0x00, 0x00, 0x00, 0x40, 0x0D, 0x00, 0xFF, 0x7F,  // ...@....
                    /* 00F8 */  0x0D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40,  // .......@
                    /* 0100 */  0x00, 0x00, 0x87, 0x17, 0x00, 0x00, 0x0C, 0x03,  // ........
                    /* 0108 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x0D, 0x00,  // ........
                    /* 0110 */  0xFF, 0xBF, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 0118 */  0x00, 0x40, 0x00, 0x00, 0x87, 0x17, 0x00, 0x00,  // .@......
                    /* 0120 */  0x0C, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC0,  // ........
                    /* 0128 */  0x0D, 0x00, 0xFF, 0xFF, 0x0D, 0x00, 0x00, 0x00,  // ........
                    /* 0130 */  0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x87, 0x17,  // ...@....
                    /* 0138 */  0x00, 0x00, 0x0C, 0x03, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 0140 */  0x00, 0x00, 0x0E, 0x00, 0xFF, 0x3F, 0x0E, 0x00,  // .....?..
                    /* 0148 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00,  // .....@..
                    /* 0150 */  0x87, 0x17, 0x00, 0x00, 0x0C, 0x03, 0x00, 0x00,  // ........
                    /* 0158 */  0x00, 0x00, 0x00, 0x40, 0x0E, 0x00, 0xFF, 0x7F,  // ...@....
                    /* 0160 */  0x0E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40,  // .......@
                    /* 0168 */  0x00, 0x00, 0x87, 0x17, 0x00, 0x00, 0x0C, 0x03,  // ........
                    /* 0170 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x0E, 0x00,  // ........
                    /* 0178 */  0xFF, 0xBF, 0x0E, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 0180 */  0x00, 0x40, 0x00, 0x00, 0x87, 0x17, 0x00, 0x00,  // .@......
                    /* 0188 */  0x0C, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC0,  // ........
                    /* 0190 */  0x0E, 0x00, 0xFF, 0xFF, 0x0E, 0x00, 0x00, 0x00,  // ........
                    /* 0198 */  0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x87, 0x17,  // ...@....
                    /* 01A0 */  0x00, 0x00, 0x0C, 0x03, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 01A8 */  0x00, 0x00, 0x0F, 0x00, 0xFF, 0xFF, 0x0F, 0x00,  // ........
                    /* 01B0 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00,  // ........
                    /* 01B8 */  0x87, 0x17, 0x00, 0x00, 0x0C, 0x01, 0x00, 0x00,  // ........
                    /* 01C0 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF,  // ........
                    /* 01C8 */  0xFF, 0xDF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 01D0 */  0x00, 0xE0, 0x8A, 0x2B, 0x00, 0x00, 0x0C, 0x01,  // ...+....
                    /* 01D8 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 01E0 */  0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 01E8 */  0xFF, 0xFF, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 01F0 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 01F8 */  0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 0200 */  0x87, 0x17, 0x00, 0x00, 0x0C, 0x03, 0x00, 0x00,  // ........
                    /* 0208 */  0x00, 0x00, 0x00, 0x00, 0x80, 0xFC, 0xFF, 0xFF,  // ........
                    /* 0210 */  0x7F, 0xFE, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 0218 */  0x00, 0x02, 0x87, 0x17, 0x00, 0x00, 0x0C, 0x03,  // ........
                    /* 0220 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xD4, 0xFE,  // ........
                    /* 0228 */  0xFF, 0x4F, 0xD4, 0xFE, 0x00, 0x00, 0x00, 0x00,  // .O......
                    /* 0230 */  0x00, 0x50, 0x00, 0x00, 0x79, 0x00               // .P..y.
                })
                CreateDWordField (MCRS, 0x01C2, PMIN)
                CreateDWordField (MCRS, 0x01C6, PMAX)
                CreateDWordField (MCRS, 0x01CE, PLEN)
                Local0 = (^MCHC.TLUD & 0xFFF00000)
                Local1 = ^MCHC.MEBA /* \_SB_.PCI0.MCHC.MEBA */
                If ((Local0 == Local1))
                {
                    Local0 = (^MCHC.TOM & 0x0000007FFFF00000)
                }

                PMIN = Local0
                PLEN = ((PMAX - PMIN) + One)
                If ((A4GS == Zero))
                {
                    CreateQWordField (MCRS, 0x01F8, MSEN)
                    MSEN = Zero
                }
                Else
                {
                    CreateQWordField (MCRS, 0x01E0, MMIN)
                    CreateQWordField (MCRS, 0x01E8, MMAX)
                    CreateQWordField (MCRS, 0x01F8, MLEN)
                    MLEN = A4GS /* External reference */
                    MMIN = A4GB /* External reference */
                    MMAX = ((MMIN + MLEN) - One)
                }

                Return (MCRS) /* \_SB_.PCI0._CRS.MCRS */
            }

            Method (GMHB, 0, Serialized)
            {
                Local0 = (^MCHC.MHBR << 0x0F)
                Return (Local0)
            }

            Method (GEPB, 0, Serialized)
            {
                Local0 = (^MCHC.EPBR << 0x0C)
                Return (Local0)
            }

            Method (GPCB, 0, Serialized)
            {
                Local0 = (^MCHC.PXBR << 0x1A)
                Return (Local0)
            }

            Method (GPCL, 0, Serialized)
            {
                Local0 = (0x10000000 >> ^MCHC.PXSZ) /* \_SB_.PCI0.MCHC.PXSZ */
                Return (Local0)
            }

            Method (GDMB, 0, Serialized)
            {
                Local0 = (^MCHC.DIBR << 0x0C)
                Return (Local0)
            }

            Device (PDRC)
            {
                Name (_HID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _HID: Hardware ID
                Name (_UID, One)  // _UID: Unique ID
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (BUF0, Buffer (0x56)
                    {
                        /* 0000 */  0x86, 0x09, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0008 */  0x00, 0x80, 0x00, 0x00, 0x86, 0x09, 0x00, 0x01,  // ........
                        /* 0010 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00,  // ........
                        /* 0018 */  0x86, 0x09, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0020 */  0x00, 0x10, 0x00, 0x00, 0x86, 0x09, 0x00, 0x00,  // ........
                        /* 0028 */  0x00, 0x00, 0xD9, 0xFE, 0x00, 0x40, 0x00, 0x00,  // .....@..
                        /* 0030 */  0x86, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0038 */  0x00, 0x00, 0x00, 0x01, 0x86, 0x09, 0x00, 0x00,  // ........
                        /* 0040 */  0x00, 0x00, 0xE0, 0xFE, 0x00, 0x00, 0x10, 0x00,  // ........
                        /* 0048 */  0x86, 0x09, 0x00, 0x01, 0x00, 0x00, 0xD0, 0xFE,  // ........
                        /* 0050 */  0x00, 0x04, 0x00, 0x00, 0x79, 0x00               // ....y.
                    })
                    CreateDWordField (BUF0, 0x04, MBR0)
                    MBR0 = GMHB ()
                    CreateDWordField (BUF0, 0x10, DBR0)
                    DBR0 = GDMB ()
                    CreateDWordField (BUF0, 0x1C, EBR0)
                    EBR0 = GEPB ()
                    CreateDWordField (BUF0, 0x34, FBR0)
                    FBR0 = 0xFF000000
                    Return (BUF0) /* \_SB_.PCI0.PDRC._CRS.BUF0 */
                }
            }

            Device (GFX0)
            {
                Name (_ADR, 0x00020000)  // _ADR: Address
                Method (_PS0, 0, NotSerialized)  // _PS0: Power State 0
                {
                }

                Method (_PS3, 0, NotSerialized)  // _PS3: Power State 3
                {
                }

                Method (_S0W, 0, NotSerialized)  // _S0W: S0 Device Wake State
                {
                    Return (0x03)
                }

                Method (_S3D, 0, NotSerialized)  // _S3D: S3 Device State
                {
                    Return (0x03)
                }
            }

            Name (PICP, Package (0x29)
            {
                Package (0x04)
                {
                    0x001FFFFF, 
                    Zero, 
                    Zero, 
                    0x10
                }, 

                Package (0x04)
                {
                    0x001FFFFF, 
                    One, 
                    Zero, 
                    0x11
                }, 

                Package (0x04)
                {
                    0x001FFFFF, 
                    0x02, 
                    Zero, 
                    0x12
                }, 

                Package (0x04)
                {
                    0x001FFFFF, 
                    0x03, 
                    Zero, 
                    0x13
                }, 

                Package (0x04)
                {
                    0x001EFFFF, 
                    Zero, 
                    Zero, 
                    0x14
                }, 

                Package (0x04)
                {
                    0x001EFFFF, 
                    One, 
                    Zero, 
                    0x15
                }, 

                Package (0x04)
                {
                    0x001EFFFF, 
                    0x02, 
                    Zero, 
                    0x16
                }, 

                Package (0x04)
                {
                    0x001EFFFF, 
                    0x03, 
                    Zero, 
                    0x17
                }, 

                Package (0x04)
                {
                    0x001DFFFF, 
                    Zero, 
                    Zero, 
                    0x10
                }, 

                Package (0x04)
                {
                    0x001DFFFF, 
                    One, 
                    Zero, 
                    0x11
                }, 

                Package (0x04)
                {
                    0x001DFFFF, 
                    0x02, 
                    Zero, 
                    0x12
                }, 

                Package (0x04)
                {
                    0x001DFFFF, 
                    0x03, 
                    Zero, 
                    0x13
                }, 

                Package (0x04)
                {
                    0x001CFFFF, 
                    Zero, 
                    Zero, 
                    0x10
                }, 

                Package (0x04)
                {
                    0x001CFFFF, 
                    One, 
                    Zero, 
                    0x11
                }, 

                Package (0x04)
                {
                    0x001CFFFF, 
                    0x02, 
                    Zero, 
                    0x12
                }, 

                Package (0x04)
                {
                    0x001CFFFF, 
                    0x03, 
                    Zero, 
                    0x13
                }, 

                Package (0x04)
                {
                    0x0019FFFF, 
                    Zero, 
                    Zero, 
                    0x20
                }, 

                Package (0x04)
                {
                    0x0019FFFF, 
                    One, 
                    Zero, 
                    0x21
                }, 

                Package (0x04)
                {
                    0x0019FFFF, 
                    0x02, 
                    Zero, 
                    0x22
                }, 

                Package (0x04)
                {
                    0x0016FFFF, 
                    Zero, 
                    Zero, 
                    0x10
                }, 

                Package (0x04)
                {
                    0x0016FFFF, 
                    One, 
                    Zero, 
                    0x11
                }, 

                Package (0x04)
                {
                    0x0016FFFF, 
                    0x02, 
                    Zero, 
                    0x12
                }, 

                Package (0x04)
                {
                    0x0016FFFF, 
                    0x03, 
                    Zero, 
                    0x13
                }, 

                Package (0x04)
                {
                    0x0017FFFF, 
                    Zero, 
                    Zero, 
                    0x10
                }, 

                Package (0x04)
                {
                    0x0015FFFF, 
                    Zero, 
                    Zero, 
                    0x10
                }, 

                Package (0x04)
                {
                    0x0015FFFF, 
                    One, 
                    Zero, 
                    0x11
                }, 

                Package (0x04)
                {
                    0x0015FFFF, 
                    0x02, 
                    Zero, 
                    0x12
                }, 

                Package (0x04)
                {
                    0x0015FFFF, 
                    0x03, 
                    Zero, 
                    0x13
                }, 

                Package (0x04)
                {
                    0x0014FFFF, 
                    Zero, 
                    Zero, 
                    0x10
                }, 

                Package (0x04)
                {
                    0x0014FFFF, 
                    One, 
                    Zero, 
                    0x11
                }, 

                Package (0x04)
                {
                    0x0014FFFF, 
                    0x02, 
                    Zero, 
                    0x12
                }, 

                Package (0x04)
                {
                    0x0014FFFF, 
                    0x03, 
                    Zero, 
                    0x13
                }, 

                Package (0x04)
                {
                    0x0013FFFF, 
                    Zero, 
                    Zero, 
                    0x14
                }, 

                Package (0x04)
                {
                    0x0001FFFF, 
                    Zero, 
                    Zero, 
                    0x10
                }, 

                Package (0x04)
                {
                    0x0001FFFF, 
                    One, 
                    Zero, 
                    0x11
                }, 

                Package (0x04)
                {
                    0x0001FFFF, 
                    0x02, 
                    Zero, 
                    0x12
                }, 

                Package (0x04)
                {
                    0x0001FFFF, 
                    0x03, 
                    Zero, 
                    0x13
                }, 

                Package (0x04)
                {
                    0x0002FFFF, 
                    Zero, 
                    Zero, 
                    0x10
                }, 

                Package (0x04)
                {
                    0x0004FFFF, 
                    Zero, 
                    Zero, 
                    0x10
                }, 

                Package (0x04)
                {
                    0x0005FFFF, 
                    Zero, 
                    Zero, 
                    0x10
                }, 

                Package (0x04)
                {
                    0x0008FFFF, 
                    Zero, 
                    Zero, 
                    0x10
                }
            })
            Name (PICN, Package (0x21)
            {
                Package (0x04)
                {
                    0x001FFFFF, 
                    Zero, 
                    LNKA, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x001FFFFF, 
                    One, 
                    LNKB, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x001FFFFF, 
                    0x02, 
                    LNKC, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x001FFFFF, 
                    0x03, 
                    LNKD, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x001DFFFF, 
                    Zero, 
                    LNKA, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x001DFFFF, 
                    One, 
                    LNKB, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x001DFFFF, 
                    0x02, 
                    LNKC, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x001DFFFF, 
                    0x03, 
                    LNKD, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x001CFFFF, 
                    Zero, 
                    LNKA, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x001CFFFF, 
                    One, 
                    LNKB, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x001CFFFF, 
                    0x02, 
                    LNKC, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x001CFFFF, 
                    0x03, 
                    LNKD, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x001BFFFF, 
                    Zero, 
                    LNKA, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x001BFFFF, 
                    One, 
                    LNKB, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x001BFFFF, 
                    0x02, 
                    LNKC, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x001BFFFF, 
                    0x03, 
                    LNKD, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0017FFFF, 
                    Zero, 
                    LNKA, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0016FFFF, 
                    Zero, 
                    LNKA, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0016FFFF, 
                    One, 
                    LNKB, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0016FFFF, 
                    0x02, 
                    LNKC, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0016FFFF, 
                    0x03, 
                    LNKD, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0014FFFF, 
                    Zero, 
                    LNKA, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0014FFFF, 
                    One, 
                    LNKB, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0014FFFF, 
                    0x02, 
                    LNKC, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0014FFFF, 
                    0x03, 
                    LNKD, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0001FFFF, 
                    Zero, 
                    LNKA, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0001FFFF, 
                    One, 
                    LNKB, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0001FFFF, 
                    0x02, 
                    LNKC, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0001FFFF, 
                    0x03, 
                    LNKD, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0002FFFF, 
                    Zero, 
                    LNKA, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0004FFFF, 
                    Zero, 
                    LNKA, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0005FFFF, 
                    Zero, 
                    LNKA, , 
                    Zero
                }, 

                Package (0x04)
                {
                    0x0008FFFF, 
                    Zero, 
                    LNKA, , 
                    Zero
                }
            })
            Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
            {
                If (PICM)
                {
                    Return (PICP) /* \_SB_.PCI0.PICP */
                }
                Else
                {
                    Return (PICN) /* \_SB_.PCI0.PICN */
                }
            }

            Method (GRXS, 1, Serialized)
            {
                OperationRegion (PREG, SystemMemory, GADD (Arg0), 0x04)
                Field (PREG, AnyAcc, NoLock, Preserve)
                {
                        ,   1, 
                    RXST,   1
                }

                Return (RXST) /* \_SB_.PCI0.GRXS.RXST */
            }

            Method (GTXS, 1, Serialized)
            {
                OperationRegion (PREG, SystemMemory, GADD (Arg0), 0x04)
                Field (PREG, AnyAcc, NoLock, Preserve)
                {
                    TXST,   1
                }

                Return (TXST) /* \_SB_.PCI0.GTXS.TXST */
            }

            Method (STXS, 1, Serialized)
            {
                OperationRegion (PREG, SystemMemory, GADD (Arg0), 0x04)
                Field (PREG, AnyAcc, NoLock, Preserve)
                {
                    TXST,   1
                }

                TXST = One
            }

            Method (CTXS, 1, Serialized)
            {
                OperationRegion (PREG, SystemMemory, GADD (Arg0), 0x04)
                Field (PREG, AnyAcc, NoLock, Preserve)
                {
                    TXST,   1
                }

                TXST = Zero
            }

            Method (GPMO, 2, Serialized)
            {
                OperationRegion (PREG, SystemMemory, GADD (Arg0), 0x04)
                Field (PREG, AnyAcc, NoLock, Preserve)
                {
                        ,   10, 
                    MODE,   3
                }

                MODE = Arg1
            }

            Method (GTXE, 2, Serialized)
            {
                OperationRegion (PREG, SystemMemory, GADD (Arg0), 0x04)
                Field (PREG, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x01), 
                    TXDI,   1
                }

                TXDI = !Arg1
            }

            Method (GRXE, 2, Serialized)
            {
                OperationRegion (PREG, SystemMemory, GADD (Arg0), 0x04)
                Field (PREG, AnyAcc, NoLock, Preserve)
                {
                        ,   9, 
                    RXDI,   1
                }

                RXDI = !Arg1
            }

            Method (GSCI, 2, Serialized)
            {
                OperationRegion (PREG, SystemMemory, GADD (Arg0), 0x04)
                Field (PREG, AnyAcc, NoLock, Preserve)
                {
                        ,   19, 
                    SCIR,   1
                }

                SCIR = Arg1
            }

            Device (GPIO)
            {
                Name (_HID, "INT344B")  // _HID: Hardware ID
                Name (_UID, One)  // _UID: Unique ID
                Name (_DDN, "GPIO Controller")  // _DDN: DOS Device Name
                Name (RBUF, Buffer (0x2F)
                {
                    /* 0000 */  0x86, 0x09, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x86, 0x09, 0x00, 0x01,  // ........
                    /* 0010 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 0018 */  0x86, 0x09, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 0020 */  0x00, 0x00, 0x00, 0x00, 0x89, 0x06, 0x00, 0x0D,  // ........
                    /* 0028 */  0x01, 0x00, 0x00, 0x00, 0x00, 0x79, 0x00         // .....y.
                })
                Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
                {
                    CreateDWordField (RBUF, 0x04, BAS0)
                    CreateDWordField (RBUF, 0x08, LEN0)
                    BAS0 = PCRB (0xAF)
                    LEN0 = 0x00010000
                    CreateDWordField (RBUF, 0x10, BAS1)
                    CreateDWordField (RBUF, 0x14, LEN1)
                    BAS1 = PCRB (0xAE)
                    LEN1 = 0x00010000
                    CreateDWordField (RBUF, 0x1C, BAS3)
                    CreateDWordField (RBUF, 0x20, LEN3)
                    BAS3 = PCRB (0xAC)
                    LEN3 = 0x00010000
                    CreateDWordField (RBUF, 0x29, IRQN)
                    Local0 = (PCRR (0xAF, 0x10) & 0x08)
                    If ((Local0 == Zero))
                    {
                        IRQN = 0x0E
                    }
                    Else
                    {
                        IRQN = 0x0F
                    }

                    Return (RBUF) /* \_SB_.PCI0.GPIO.RBUF */
                }

                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }
            }

            Method (GADD, 1, NotSerialized)
            {
                If (((Arg0 >= Zero) && (Arg0 <= 0x2F)))
                {
                    Local0 = 0xAF
                    Local1 = (Arg0 - Zero)
                }

                If (((Arg0 >= 0x30) && (Arg0 <= 0x77)))
                {
                    Local0 = 0xAE
                    Local1 = (Arg0 - 0x30)
                }

                If (((Arg0 >= 0x78) && (Arg0 <= 0x97)))
                {
                    Local0 = 0xAC
                    Local1 = (Arg0 - 0x78)
                }

                Local2 = PCRB (Local0)
                Local2 += 0x0400
                Return ((Local2 + (Local1 * 0x08)))
            }

            OperationRegion (ITSS, SystemMemory, 0xFDC43100, 0x08)
            Field (ITSS, ByteAcc, NoLock, Preserve)
            {
                PIRA,   8, 
                PIRB,   8, 
                PIRC,   8, 
                PIRD,   8, 
                PIRE,   8, 
                PIRF,   8, 
                PIRG,   8, 
                PIRH,   8
            }

            Name (IREN, 0x80)
            Name (IREM, 0x0F)
            Device (LNKA)
            {
                Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                Name (_UID, One)  // _UID: Unique ID
                Name (_PRS, Buffer (0x06)  // _PRS: Possible Resource Settings
                {
                     0x23, 0x78, 0xDC, 0x18, 0x79, 0x00               // #x..y.
                })
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (RTLA, Buffer (0x06)
                    {
                         0x23, 0x00, 0x00, 0x18, 0x79, 0x00               // #...y.
                    })
                    CreateWordField (RTLA, One, IRQ0)
                    IRQ0 = Zero
                    IRQ0 = (One << (PIRA & IREM))
                    Return (RTLA) /* \_SB_.PCI0.LNKA._CRS.RTLA */
                }

                Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                {
                    CreateWordField (Arg0, One, IRQ0)
                    FindSetRightBit (IRQ0, Local0)
                    Local0--
                    PIRA = Local0
                }

                Method (_STA, 0, Serialized)  // _STA: Status
                {
                    If ((PIRA & IREN))
                    {
                        Return (0x09)
                    }
                    Else
                    {
                        Return (0x0B)
                    }
                }

                Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                {
                    PIRA |= IREN /* \_SB_.PCI0.IREN */
                }
            }

            Device (LNKB)
            {
                Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                Name (_UID, 0x02)  // _UID: Unique ID
                Name (_PRS, Buffer (0x06)  // _PRS: Possible Resource Settings
                {
                     0x23, 0x78, 0xDC, 0x18, 0x79, 0x00               // #x..y.
                })
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (RTLA, Buffer (0x06)
                    {
                         0x23, 0x00, 0x00, 0x18, 0x79, 0x00               // #...y.
                    })
                    CreateWordField (RTLA, One, IRQ0)
                    IRQ0 = Zero
                    IRQ0 = (One << (PIRB & IREM))
                    Return (RTLA) /* \_SB_.PCI0.LNKB._CRS.RTLA */
                }

                Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                {
                    CreateWordField (Arg0, One, IRQ0)
                    FindSetRightBit (IRQ0, Local0)
                    Local0--
                    PIRB = Local0
                }

                Method (_STA, 0, Serialized)  // _STA: Status
                {
                    If ((PIRB & IREN))
                    {
                        Return (0x09)
                    }
                    Else
                    {
                        Return (0x0B)
                    }
                }

                Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                {
                    PIRB |= IREN /* \_SB_.PCI0.IREN */
                }
            }

            Device (LNKC)
            {
                Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                Name (_UID, 0x03)  // _UID: Unique ID
                Name (_PRS, Buffer (0x06)  // _PRS: Possible Resource Settings
                {
                     0x23, 0x78, 0xDC, 0x18, 0x79, 0x00               // #x..y.
                })
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (RTLA, Buffer (0x06)
                    {
                         0x23, 0x00, 0x00, 0x18, 0x79, 0x00               // #...y.
                    })
                    CreateWordField (RTLA, One, IRQ0)
                    IRQ0 = Zero
                    IRQ0 = (One << (PIRC & IREM))
                    Return (RTLA) /* \_SB_.PCI0.LNKC._CRS.RTLA */
                }

                Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                {
                    CreateWordField (Arg0, One, IRQ0)
                    FindSetRightBit (IRQ0, Local0)
                    Local0--
                    PIRC = Local0
                }

                Method (_STA, 0, Serialized)  // _STA: Status
                {
                    If ((PIRC & IREN))
                    {
                        Return (0x09)
                    }
                    Else
                    {
                        Return (0x0B)
                    }
                }

                Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                {
                    PIRC |= IREN /* \_SB_.PCI0.IREN */
                }
            }

            Device (LNKD)
            {
                Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                Name (_UID, 0x04)  // _UID: Unique ID
                Name (_PRS, Buffer (0x06)  // _PRS: Possible Resource Settings
                {
                     0x23, 0x78, 0xDC, 0x18, 0x79, 0x00               // #x..y.
                })
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (RTLA, Buffer (0x06)
                    {
                         0x23, 0x00, 0x00, 0x18, 0x79, 0x00               // #...y.
                    })
                    CreateWordField (RTLA, One, IRQ0)
                    IRQ0 = Zero
                    IRQ0 = (One << (PIRD & IREM))
                    Return (RTLA) /* \_SB_.PCI0.LNKD._CRS.RTLA */
                }

                Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                {
                    CreateWordField (Arg0, One, IRQ0)
                    FindSetRightBit (IRQ0, Local0)
                    Local0--
                    PIRD = Local0
                }

                Method (_STA, 0, Serialized)  // _STA: Status
                {
                    If ((PIRD & IREN))
                    {
                        Return (0x09)
                    }
                    Else
                    {
                        Return (0x0B)
                    }
                }

                Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                {
                    PIRD |= IREN /* \_SB_.PCI0.IREN */
                }
            }

            Device (LNKE)
            {
                Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                Name (_UID, 0x05)  // _UID: Unique ID
                Name (_PRS, Buffer (0x06)  // _PRS: Possible Resource Settings
                {
                     0x23, 0x78, 0xDC, 0x18, 0x79, 0x00               // #x..y.
                })
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (RTLA, Buffer (0x06)
                    {
                         0x23, 0x00, 0x00, 0x18, 0x79, 0x00               // #...y.
                    })
                    CreateWordField (RTLA, One, IRQ0)
                    IRQ0 = Zero
                    IRQ0 = (One << (PIRE & IREM))
                    Return (RTLA) /* \_SB_.PCI0.LNKE._CRS.RTLA */
                }

                Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                {
                    CreateWordField (Arg0, One, IRQ0)
                    FindSetRightBit (IRQ0, Local0)
                    Local0--
                    PIRE = Local0
                }

                Method (_STA, 0, Serialized)  // _STA: Status
                {
                    If ((PIRE & IREN))
                    {
                        Return (0x09)
                    }
                    Else
                    {
                        Return (0x0B)
                    }
                }

                Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                {
                    PIRE |= IREN /* \_SB_.PCI0.IREN */
                }
            }

            Device (LNKF)
            {
                Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                Name (_UID, 0x06)  // _UID: Unique ID
                Name (_PRS, Buffer (0x06)  // _PRS: Possible Resource Settings
                {
                     0x23, 0x78, 0xDC, 0x18, 0x79, 0x00               // #x..y.
                })
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (RTLA, Buffer (0x06)
                    {
                         0x23, 0x00, 0x00, 0x18, 0x79, 0x00               // #...y.
                    })
                    CreateWordField (RTLA, One, IRQ0)
                    IRQ0 = Zero
                    IRQ0 = (One << (PIRF & IREM))
                    Return (RTLA) /* \_SB_.PCI0.LNKF._CRS.RTLA */
                }

                Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                {
                    CreateWordField (Arg0, One, IRQ0)
                    FindSetRightBit (IRQ0, Local0)
                    Local0--
                    PIRF = Local0
                }

                Method (_STA, 0, Serialized)  // _STA: Status
                {
                    If ((PIRF & IREN))
                    {
                        Return (0x09)
                    }
                    Else
                    {
                        Return (0x0B)
                    }
                }

                Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                {
                    PIRF |= IREN /* \_SB_.PCI0.IREN */
                }
            }

            Device (LNKG)
            {
                Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                Name (_UID, 0x07)  // _UID: Unique ID
                Name (_PRS, Buffer (0x06)  // _PRS: Possible Resource Settings
                {
                     0x23, 0x78, 0xDC, 0x18, 0x79, 0x00               // #x..y.
                })
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (RTLA, Buffer (0x06)
                    {
                         0x23, 0x00, 0x00, 0x18, 0x79, 0x00               // #...y.
                    })
                    CreateWordField (RTLA, One, IRQ0)
                    IRQ0 = Zero
                    IRQ0 = (One << (PIRG & IREM))
                    Return (RTLA) /* \_SB_.PCI0.LNKG._CRS.RTLA */
                }

                Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                {
                    CreateWordField (Arg0, One, IRQ0)
                    FindSetRightBit (IRQ0, Local0)
                    Local0--
                    PIRG = Local0
                }

                Method (_STA, 0, Serialized)  // _STA: Status
                {
                    If ((PIRG & IREN))
                    {
                        Return (0x09)
                    }
                    Else
                    {
                        Return (0x0B)
                    }
                }

                Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                {
                    PIRG |= IREN /* \_SB_.PCI0.IREN */
                }
            }

            Device (LNKH)
            {
                Name (_HID, EisaId ("PNP0C0F") /* PCI Interrupt Link Device */)  // _HID: Hardware ID
                Name (_UID, 0x08)  // _UID: Unique ID
                Name (_PRS, Buffer (0x06)  // _PRS: Possible Resource Settings
                {
                     0x23, 0x78, 0xDC, 0x18, 0x79, 0x00               // #x..y.
                })
                Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (RTLA, Buffer (0x06)
                    {
                         0x23, 0x00, 0x00, 0x18, 0x79, 0x00               // #...y.
                    })
                    CreateWordField (RTLA, One, IRQ0)
                    IRQ0 = Zero
                    IRQ0 = (One << (PIRH & IREM))
                    Return (RTLA) /* \_SB_.PCI0.LNKH._CRS.RTLA */
                }

                Method (_SRS, 1, Serialized)  // _SRS: Set Resource Settings
                {
                    CreateWordField (Arg0, One, IRQ0)
                    FindSetRightBit (IRQ0, Local0)
                    Local0--
                    PIRH = Local0
                }

                Method (_STA, 0, Serialized)  // _STA: Status
                {
                    If ((PIRH & IREN))
                    {
                        Return (0x09)
                    }
                    Else
                    {
                        Return (0x0B)
                    }
                }

                Method (_DIS, 0, Serialized)  // _DIS: Disable Device
                {
                    PIRH |= IREN /* \_SB_.PCI0.IREN */
                }
            }

            Device (LPCB)
            {
                Name (_ADR, 0x001F0000)  // _ADR: Address
                Name (_DDN, "LPC Bus Device")  // _DDN: DOS Device Name
                OperationRegion (LPCP, PCI_Config, Zero, 0x0100)
                Field (LPCP, DWordAcc, NoLock, Preserve)
                {
                    Offset (0x98), 
                    LGEN,   1, 
                    Offset (0x9A), 
                    LADR,   16
                }

                Method (GLGM, 0, Serialized)
                {
                    Local0 = (LADR << 0x10)
                    Return (Local0)
                }

                Device (DMAC)
                {
                    Name (_HID, EisaId ("PNP0200") /* PC-class DMA Controller */)  // _HID: Hardware ID
                    Name (_CRS, Buffer (0x25)  // _CRS: Current Resource Settings
                    {
                        /* 0000 */  0x47, 0x01, 0x00, 0x00, 0x00, 0x00, 0x01, 0x20,  // G...... 
                        /* 0008 */  0x47, 0x01, 0x81, 0x00, 0x81, 0x00, 0x01, 0x11,  // G.......
                        /* 0010 */  0x47, 0x01, 0x93, 0x00, 0x93, 0x00, 0x01, 0x0D,  // G.......
                        /* 0018 */  0x47, 0x01, 0xC0, 0x00, 0xC0, 0x00, 0x01, 0x20,  // G...... 
                        /* 0020 */  0x2A, 0x10, 0x01, 0x79, 0x00                     // *..y.
                    })
                }

                Device (FWH)
                {
                    Name (_HID, EisaId ("INT0800") /* Intel 82802 Firmware Hub Device */)  // _HID: Hardware ID
                    Name (_DDN, "Firmware Hub")  // _DDN: DOS Device Name
                    Name (_CRS, Buffer (0x0E)  // _CRS: Current Resource Settings
                    {
                        /* 0000 */  0x86, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF,  // ........
                        /* 0008 */  0x00, 0x00, 0x00, 0x01, 0x79, 0x00               // ....y.
                    })
                }

                Device (HPET)
                {
                    Name (_HID, EisaId ("PNP0103") /* HPET System Timer */)  // _HID: Hardware ID
                    Name (_CID, EisaId ("PNP0C01") /* System Board */)  // _CID: Compatible ID
                    Name (_DDN, "High Precision Event Timer")  // _DDN: DOS Device Name
                    Name (_CRS, Buffer (0x0E)  // _CRS: Current Resource Settings
                    {
                        /* 0000 */  0x86, 0x09, 0x00, 0x01, 0x00, 0x00, 0xD0, 0xFE,  // ........
                        /* 0008 */  0x00, 0x04, 0x00, 0x00, 0x79, 0x00               // ....y.
                    })
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        Return (0x0F)
                    }
                }

                Device (MATH)
                {
                    Name (_HID, EisaId ("PNP0C04") /* x87-compatible Floating Point Processing Unit */)  // _HID: Hardware ID
                    Name (_CRS, Buffer (0x0D)  // _CRS: Current Resource Settings
                    {
                        /* 0000 */  0x47, 0x01, 0xF0, 0x00, 0xF0, 0x00, 0x01, 0x01,  // G.......
                        /* 0008 */  0x22, 0x00, 0x20, 0x79, 0x00                     // ". y.
                    })
                }

                Device (PIC)
                {
                    Name (_HID, EisaId ("PNP0000") /* 8259-compatible Programmable Interrupt Controller */)  // _HID: Hardware ID
                    Name (_DDN, "8259 Interrupt Controller")  // _DDN: DOS Device Name
                    Name (_CRS, Buffer (0x8D)  // _CRS: Current Resource Settings
                    {
                        /* 0000 */  0x47, 0x01, 0x20, 0x00, 0x20, 0x00, 0x01, 0x02,  // G. . ...
                        /* 0008 */  0x47, 0x01, 0x24, 0x00, 0x24, 0x00, 0x01, 0x02,  // G.$.$...
                        /* 0010 */  0x47, 0x01, 0x28, 0x00, 0x28, 0x00, 0x01, 0x02,  // G.(.(...
                        /* 0018 */  0x47, 0x01, 0x2C, 0x00, 0x2C, 0x00, 0x01, 0x02,  // G.,.,...
                        /* 0020 */  0x47, 0x01, 0x30, 0x00, 0x30, 0x00, 0x01, 0x02,  // G.0.0...
                        /* 0028 */  0x47, 0x01, 0x34, 0x00, 0x34, 0x00, 0x01, 0x02,  // G.4.4...
                        /* 0030 */  0x47, 0x01, 0x38, 0x00, 0x38, 0x00, 0x01, 0x02,  // G.8.8...
                        /* 0038 */  0x47, 0x01, 0x3C, 0x00, 0x3C, 0x00, 0x01, 0x02,  // G.<.<...
                        /* 0040 */  0x47, 0x01, 0xA0, 0x00, 0xA0, 0x00, 0x01, 0x02,  // G.......
                        /* 0048 */  0x47, 0x01, 0xA4, 0x00, 0xA4, 0x00, 0x01, 0x02,  // G.......
                        /* 0050 */  0x47, 0x01, 0xA8, 0x00, 0xA8, 0x00, 0x01, 0x02,  // G.......
                        /* 0058 */  0x47, 0x01, 0xAC, 0x00, 0xAC, 0x00, 0x01, 0x02,  // G.......
                        /* 0060 */  0x47, 0x01, 0xB0, 0x00, 0xB0, 0x00, 0x01, 0x02,  // G.......
                        /* 0068 */  0x47, 0x01, 0xB4, 0x00, 0xB4, 0x00, 0x01, 0x02,  // G.......
                        /* 0070 */  0x47, 0x01, 0xB8, 0x00, 0xB8, 0x00, 0x01, 0x02,  // G.......
                        /* 0078 */  0x47, 0x01, 0xBC, 0x00, 0xBC, 0x00, 0x01, 0x02,  // G.......
                        /* 0080 */  0x47, 0x01, 0xD0, 0x04, 0xD0, 0x04, 0x01, 0x02,  // G.......
                        /* 0088 */  0x22, 0x04, 0x00, 0x79, 0x00                     // "..y.
                    })
                }

                Device (LDRC)
                {
                    Name (_HID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _HID: Hardware ID
                    Name (_UID, 0x02)  // _UID: Unique ID
                    Name (_DDN, "Legacy Device Resources")  // _DDN: DOS Device Name
                    Name (_CRS, Buffer (0x52)  // _CRS: Current Resource Settings
                    {
                        /* 0000 */  0x47, 0x01, 0x2E, 0x00, 0x2E, 0x00, 0x01, 0x02,  // G.......
                        /* 0008 */  0x47, 0x01, 0x4E, 0x00, 0x4E, 0x00, 0x01, 0x02,  // G.N.N...
                        /* 0010 */  0x47, 0x01, 0x61, 0x00, 0x61, 0x00, 0x01, 0x01,  // G.a.a...
                        /* 0018 */  0x47, 0x01, 0x63, 0x00, 0x63, 0x00, 0x01, 0x01,  // G.c.c...
                        /* 0020 */  0x47, 0x01, 0x65, 0x00, 0x65, 0x00, 0x01, 0x01,  // G.e.e...
                        /* 0028 */  0x47, 0x01, 0x67, 0x00, 0x67, 0x00, 0x01, 0x01,  // G.g.g...
                        /* 0030 */  0x47, 0x01, 0x80, 0x00, 0x80, 0x00, 0x01, 0x01,  // G.......
                        /* 0038 */  0x47, 0x01, 0x92, 0x00, 0x92, 0x00, 0x01, 0x01,  // G.......
                        /* 0040 */  0x47, 0x01, 0xB2, 0x00, 0xB2, 0x00, 0x01, 0x02,  // G.......
                        /* 0048 */  0x47, 0x01, 0x00, 0x18, 0x00, 0x18, 0x01, 0xFF,  // G.......
                        /* 0050 */  0x79, 0x00                                       // y.
                    })
                }

                Device (RTC)
                {
                    Name (_HID, EisaId ("PNP0B00") /* AT Real-Time Clock */)  // _HID: Hardware ID
                    Name (_DDN, "Real Time Clock")  // _DDN: DOS Device Name
                    Name (_CRS, Buffer (0x0A)  // _CRS: Current Resource Settings
                    {
                        /* 0000 */  0x47, 0x01, 0x70, 0x00, 0x70, 0x00, 0x01, 0x08,  // G.p.p...
                        /* 0008 */  0x79, 0x00                                       // y.
                    })
                }

                Device (TIMR)
                {
                    Name (_HID, EisaId ("PNP0100") /* PC-class System Timer */)  // _HID: Hardware ID
                    Name (_DDN, "8254 Timer")  // _DDN: DOS Device Name
                    Name (_CRS, Buffer (0x15)  // _CRS: Current Resource Settings
                    {
                        /* 0000 */  0x47, 0x01, 0x40, 0x00, 0x40, 0x00, 0x01, 0x04,  // G.@.@...
                        /* 0008 */  0x47, 0x01, 0x50, 0x00, 0x50, 0x00, 0x10, 0x04,  // G.P.P...
                        /* 0010 */  0x22, 0x01, 0x00, 0x79, 0x00                     // "..y.
                    })
                }
            }

            Scope (LPCB)
            {
                Device (EC0)
                {
                    Name (_HID, EisaId ("PNP0C09") /* Embedded Controller Device */)  // _HID: Hardware ID
                    Name (_UID, One)  // _UID: Unique ID
                    Name (_GPE, 0x50)  // _GPE: General Purpose Events
                    Name (TOFS, 0xC8)
                    Name (TNCA, 0xFC)
                    Name (TNOP, 0xFD)
                    Name (TBAD, 0xFE)
                    Name (TNPR, 0xFF)
                    Name (DWRN, 0x0F)
                    Name (DLOW, 0x0A)
                    OperationRegion (ERAM, EmbeddedControl, Zero, 0x20)
                    Field (ERAM, ByteAcc, Lock, Preserve)
                    {
                        RAMV,   8, 
                        TSTB,   8, 
                        TSTC,   8, 
                        KBLV,   8, 
                        FAND,   8, 
                        PATI,   8, 
                        PATT,   8, 
                        PATC,   8, 
                        CHGL,   8, 
                        TBMD,   1, 
                        DDPN,   3, 
                        STTB,   1, 
                        Offset (0x0A), 
                        DFUD,   1, 
                        FLSH,   1, 
                        PFAN,   1, 
                        KBLE,   1, 
                        LTBR,   1, 
                        LEDC,   1, 
                        MTNS,   1, 
                        KEYB,   1, 
                        PSTR,   1, 
                        P80P,   1, 
                        THRM,   1, 
                        SBKL,   1, 
                        WIFI,   1, 
                        HOST,   1, 
                        GPIO,   1, 
                        I2CB,   1, 
                        CHRG,   1, 
                        BATT,   1, 
                        SBAT,   1, 
                        HANG,   1, 
                        PMUI,   1, 
                        DSEC,   1, 
                        UPDC,   1, 
                        UMUX,   1, 
                        MSFF,   1, 
                        TVST,   1, 
                        TCMV,   1, 
                        RTCD,   1, 
                        FPRD,   1, 
                        TPAD,   1, 
                        RWSG,   1, 
                        DEVE,   1, 
                        Offset (0x0E), 
                        Offset (0x12), 
                        BTID,   8, 
                        USPP,   8, 
                        RFWU,   8, 
                        PBOK,   8, 
                        BSRF,   8
                    }

                    OperationRegion (EMEM, EmbeddedControl, 0x20, 0xE0)
                    Field (EMEM, ByteAcc, Lock, Preserve)
                    {
                        TIN0,   8, 
                        TIN1,   8, 
                        TIN2,   8, 
                        TIN3,   8, 
                        TIN4,   8, 
                        TIN5,   8, 
                        TIN6,   8, 
                        TIN7,   8, 
                        TIN8,   8, 
                        TIN9,   8, 
                        Offset (0x10), 
                        FAN0,   16, 
                        FAN1,   16, 
                        Offset (0x24), 
                        BTVR,   8, 
                        Offset (0x30), 
                        LIDS,   1, 
                        PBTN,   1, 
                        WPDI,   1, 
                        RECK,   1, 
                        RECD,   1, 
                        Offset (0x40), 
                        BTVO,   32, 
                        BTPR,   32, 
                        BTRA,   32, 
                        ACEX,   1, 
                        BTEX,   1, 
                        BFDC,   1, 
                        BFCG,   1, 
                        BFCR,   1, 
                        BFIV,   1, 
                        BFCT,   1, 
                        Offset (0x4D), 
                        BTCN,   8, 
                        BTIX,   8, 
                        Offset (0x50), 
                        BTDA,   32, 
                        BTDV,   32, 
                        BTDF,   32, 
                        BTCC,   32, 
                        BMFG,   64, 
                        BMOD,   64, 
                        BSER,   64, 
                        BTYP,   64, 
                        Offset (0x80), 
                        ALS0,   16, 
                        Offset (0xA6), 
                        GPUD,   8, 
                        Offset (0xA7), 
                        PWRT,   8, 
                        EOVD,   8
                    }

                    Name (ENS0, Zero)
                    Name (RES0, Zero)
                    Method (S0IX, 1, Serialized)
                    {
                        If ((Arg0 == One))
                        {
                            ENS0 = One
                            Sleep (0xD2)
                            Notify (CREC, One) // Device Check
                        }
                        Else
                        {
                            RES0 = One
                            Notify (CREC, 0x02) // Device Wake
                        }
                    }

                    Device (LID0)
                    {
                        Name (_HID, EisaId ("PNP0C0D") /* Lid Device */)  // _HID: Hardware ID
                        Method (_LID, 0, NotSerialized)  // _LID: Lid Status
                        {
                            Return (LIDS) /* \_SB_.PCI0.LPCB.EC0_.LIDS */
                        }

                        Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
                        {
                            0x70, 
                            0x05
                        })
                    }

                    Method (TINS, 1, Serialized)
                    {
                        Switch (ToInteger (Arg0))
                        {
                            Case (Zero)
                            {
                                Return (TIN0) /* \_SB_.PCI0.LPCB.EC0_.TIN0 */
                            }
                            Case (One)
                            {
                                Return (TIN1) /* \_SB_.PCI0.LPCB.EC0_.TIN1 */
                            }
                            Case (0x02)
                            {
                                Return (TIN2) /* \_SB_.PCI0.LPCB.EC0_.TIN2 */
                            }
                            Case (0x03)
                            {
                                Return (TIN3) /* \_SB_.PCI0.LPCB.EC0_.TIN3 */
                            }
                            Case (0x04)
                            {
                                Return (TIN4) /* \_SB_.PCI0.LPCB.EC0_.TIN4 */
                            }
                            Case (0x05)
                            {
                                Return (TIN5) /* \_SB_.PCI0.LPCB.EC0_.TIN5 */
                            }
                            Case (0x06)
                            {
                                Return (TIN6) /* \_SB_.PCI0.LPCB.EC0_.TIN6 */
                            }
                            Case (0x07)
                            {
                                Return (TIN7) /* \_SB_.PCI0.LPCB.EC0_.TIN7 */
                            }
                            Case (0x08)
                            {
                                Return (TIN8) /* \_SB_.PCI0.LPCB.EC0_.TIN8 */
                            }
                            Case (0x09)
                            {
                                Return (TIN9) /* \_SB_.PCI0.LPCB.EC0_.TIN9 */
                            }
                            Default
                            {
                                Return (TIN0) /* \_SB_.PCI0.LPCB.EC0_.TIN0 */
                            }

                        }
                    }

                    Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                    {
                        Name (ECMD, Buffer (0x12)
                        {
                            /* 0000 */  0x47, 0x01, 0x62, 0x00, 0x62, 0x00, 0x00, 0x01,  // G.b.b...
                            /* 0008 */  0x47, 0x01, 0x66, 0x00, 0x66, 0x00, 0x00, 0x01,  // G.f.f...
                            /* 0010 */  0x79, 0x00                                       // y.
                        })
                        Return (ECMD) /* \_SB_.PCI0.LPCB.EC0_._CRS.ECMD */
                    }

                    Method (_REG, 2, NotSerialized)  // _REG: Region Availability
                    {
                        PWRS = ACEX /* \_SB_.PCI0.LPCB.EC0_.ACEX */
                        PNOT ()
                    }

                    Method (TSRD, 1, Serialized)
                    {
                        Local0 = TINS (Arg0)
                        If ((Local0 == TNCA))
                        {
                            Return (Zero)
                        }

                        If ((Local0 == TNPR))
                        {
                            Return (Zero)
                        }

                        If ((Local0 == TNOP))
                        {
                            Return (Zero)
                        }

                        If ((Local0 == TBAD))
                        {
                            Return (Zero)
                        }

                        Local0 += TOFS /* \_SB_.PCI0.LPCB.EC0_.TOFS */
                        Local0 *= 0x0A
                        Return (Local0)
                    }

                    Method (_Q01, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: LID CLOSE"
                        Notify (LID0, 0x80) // Status Change
                    }

                    Method (_Q02, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: LID OPEN"
                        Notify (CREC, 0x02) // Device Wake
                        Notify (LID0, 0x80) // Status Change
                    }

                    Method (_Q03, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: POWER BUTTON"
                    }

                    Method (_Q04, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: AC CONNECTED"
                        PWRS = ACEX /* \_SB_.PCI0.LPCB.EC0_.ACEX */
                        Notify (AC, 0x80) // Status Change
                        PNOT ()
                    }

                    Method (_Q05, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: AC DISCONNECTED"
                        PWRS = ACEX /* \_SB_.PCI0.LPCB.EC0_.ACEX */
                        Notify (AC, 0x80) // Status Change
                        PNOT ()
                    }

                    Method (_Q06, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: BATTERY LOW"
                        Notify (BAT0, 0x80) // Status Change
                    }

                    Method (_Q07, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: BATTERY CRITICAL"
                        Notify (BAT0, 0x80) // Status Change
                    }

                    Method (_Q08, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: BATTERY INFO"
                        Notify (BAT0, 0x81) // Information Change
                    }

                    Method (_Q0A, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: THERMAL OVERLOAD"
                        Notify (_TZ, 0x80) // Status Change
                    }

                    Method (_Q0B, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: THERMAL"
                        Notify (_TZ, 0x80) // Status Change
                    }

                    Method (_Q0D, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: KEY PRESSED"
                        Notify (CREC, 0x02) // Device Wake
                    }

                    Method (_Q10, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: THERMAL SHUTDOWN"
                        Notify (_TZ, 0x80) // Status Change
                    }

                    Method (_Q11, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: BATTERY SHUTDOWN"
                        Notify (BAT0, 0x80) // Status Change
                    }

                    Method (_Q12, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                    }

                    Method (_Q13, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                    }

                    Method (_Q16, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: GOT PD EVENT"
                        Notify (^CREC.ECPD, 0x80) // Status Change
                        If (CondRefOf (\_SB.DPTF.TPWR))
                        {
                            Notify (^^^^DPTF.TPWR, 0x81) // Information Change
                        }
                    }

                    Method (_Q17, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: BATTERY STATUS"
                        Notify (BAT0, 0x80) // Status Change
                        PNOT ()
                    }

                    Method (_Q18, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: PANIC"
                        Notify (CREC, 0xB0) // Device-Specific
                    }

                    Method (_Q1B, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: MKBP"
                        Notify (CREC, 0x80) // Status Change
                    }

                    Method (_Q1C, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: USB MUX"
                        Notify (^CREC.ECPD, 0x80) // Status Change
                    }

                    Method (_Q1D, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: TABLET mode switch Event"
                        Notify (CREC, 0x02) // Device Wake
                        ^^^^DPTF.TPET ()
                        Notify (^CREC.TBMC, 0x80) // Status Change
                        If ((TBMD == One))
                        {
                            Notify (VBTN, 0xCC) // Hardware-Specific
                        }
                        Else
                        {
                            Notify (VBTN, 0xCD) // Hardware-Specific
                        }
                    }

                    Method (_Q21, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        Debug = "EC: Body Detect Change Event"
                    }

                    Mutex (PATM, 0x01)
                    Method (PAT0, 2, Serialized)
                    {
                        If (Acquire (PATM, 0x03E8))
                        {
                            Return (Zero)
                        }

                        PATI = ToInteger (Arg0)
                        Local1 = (ToInteger (Arg1) / 0x0A)
                        PATT = (Local1 - TOFS) /* \_SB_.PCI0.LPCB.EC0_.TOFS */
                        PATC = 0x02
                        Release (PATM)
                        Return (One)
                    }

                    Method (PAT1, 2, Serialized)
                    {
                        If (Acquire (PATM, 0x03E8))
                        {
                            Return (Zero)
                        }

                        PATI = ToInteger (Arg0)
                        Local1 = (ToInteger (Arg1) / 0x0A)
                        PATT = (Local1 - TOFS) /* \_SB_.PCI0.LPCB.EC0_.TOFS */
                        PATC = 0x03
                        Release (PATM)
                        Return (One)
                    }

                    Method (PATD, 1, Serialized)
                    {
                        If (Acquire (PATM, 0x03E8))
                        {
                            Return (Zero)
                        }

                        PATI = ToInteger (Arg0)
                        PATT = Zero
                        PATC = Zero
                        PATC = One
                        Release (PATM)
                        Return (One)
                    }

                    Method (_Q09, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
                    {
                        If (!Acquire (PATM, 0x03E8))
                        {
                            Local0 = PATI /* \_SB_.PCI0.LPCB.EC0_.PATI */
                            While ((Local0 != 0xFF))
                            {
                                Local0 = PATI /* \_SB_.PCI0.LPCB.EC0_.PATI */
                            }

                            Release (PATM)
                        }
                    }

                    Method (CHGS, 1, Serialized)
                    {
                        CHGL = ToInteger (Arg0)
                    }

                    Method (CHGD, 0, Serialized)
                    {
                        CHGL = 0xFF
                    }

                    Method (RCTM, 0, NotSerialized)
                    {
                        Return (TBMD) /* \_SB_.PCI0.LPCB.EC0_.TBMD */
                    }

                    Method (RCDP, 0, NotSerialized)
                    {
                        If ((DDPN == Zero))
                        {
                            Return (TBMD) /* \_SB_.PCI0.LPCB.EC0_.TBMD */
                        }
                        Else
                        {
                            Local0 = (DDPN - One)
                            Return (Local0)
                        }
                    }

                    Device (AC)
                    {
                        Name (_HID, "ACPI0003" /* Power Source Device */)  // _HID: Hardware ID
                        Name (_PCL, Package (0x01)  // _PCL: Power Consumer List
                        {
                            _SB, 
                        })
                        Method (_PSR, 0, NotSerialized)  // _PSR: Power Source
                        {
                            Return (ACEX) /* \_SB_.PCI0.LPCB.EC0_.ACEX */
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }
                    }

                    Mutex (BATM, 0x00)
                    Method (BTSW, 1, NotSerialized)
                    {
                        If ((Arg0 != Zero))
                        {
                            Return (One)
                        }

                        Return (Zero)
                    }

                    Method (BSTA, 1, Serialized)
                    {
                        If (Acquire (BATM, 0x03E8))
                        {
                            Return (Zero)
                        }

                        If ((~BTSW (Arg0) & BTEX))
                        {
                            Local0 = 0x1F
                        }
                        Else
                        {
                            Local0 = 0x0F
                        }

                        Release (BATM)
                        Return (Local0)
                    }

                    Name (BRSS, Zero)
                    Name (BRI1, Zero)
                    Name (BRI2, Zero)
                    Name (BRI3, Zero)
                    Name (BRS1, Buffer (0x20)
                    {
                         0x00                                             // .
                    })
                    Name (BRS2, Buffer (0x20)
                    {
                         0x00                                             // .
                    })
                    Name (BRS3, Buffer (0x20)
                    {
                         0x00                                             // .
                    })
                    Method (BRSX, 1, Serialized)
                    {
                        If (((Arg0 == Zero) || (Arg0 > 0x03)))
                        {
                            Return ("")
                        }

                        If (((Arg0 == One) && (BRI1 == One)))
                        {
                            Return (BRS1) /* \_SB_.PCI0.LPCB.EC0_.BRS1 */
                        }

                        If (((Arg0 == 0x02) && (BRI2 == One)))
                        {
                            Return (BRS2) /* \_SB_.PCI0.LPCB.EC0_.BRS2 */
                        }

                        If (((Arg0 == 0x03) && (BRI3 == One)))
                        {
                            Return (BRS3) /* \_SB_.PCI0.LPCB.EC0_.BRS3 */
                        }

                        If ((BRSS == 0xFF))
                        {
                            BSRF = Zero
                            BRSS = BSRF /* \_SB_.PCI0.LPCB.EC0_.BSRF */
                            If ((BRSS == 0xFF))
                            {
                                BRSS = Zero
                            }
                        }

                        If ((BRSS == Zero))
                        {
                            If ((Arg0 == One))
                            {
                                Local0 = ToString (Concatenate (BMOD, Zero), Ones)
                            }
                            ElseIf ((Arg0 == 0x02))
                            {
                                Local0 = ToString (Concatenate (BSER, Zero), Ones)
                            }
                            ElseIf ((Arg0 == 0x03))
                            {
                                Local0 = ToString (Concatenate (BMFG, Zero), Ones)
                            }
                        }
                        Else
                        {
                            BSRF = Arg0
                            Local0 = Buffer (0x21){}
                            Local2 = Zero
                            While ((Local2 < (SizeOf (Local0) - One)))
                            {
                                Local1 = BSRF /* \_SB_.PCI0.LPCB.EC0_.BSRF */
                                If ((Local1 == Zero))
                                {
                                    Break
                                }

                                Local0 [Local2] = Local1
                                Local2++
                            }

                            Local0 [Local2] = Zero
                            Local0 = ToString (Local0, Ones)
                        }

                        If ((Arg0 == One))
                        {
                            BRS1 = Local0
                            BRI1 = One
                        }

                        If ((Arg0 == 0x02))
                        {
                            BRS2 = Local0
                            BRI2 = One
                        }

                        If ((Arg0 == 0x03))
                        {
                            BRS3 = Local0
                            BRI3 = One
                        }

                        Return (Local0)
                    }

                    Method (BBIF, 2, Serialized)
                    {
                        If (Acquire (BATM, 0x03E8))
                        {
                            Return (Arg1)
                        }

                        If (BTSW (Arg0))
                        {
                            Release (BATM)
                            Return (Arg1)
                        }

                        Arg1 [0x02] = BTDF /* \_SB_.PCI0.LPCB.EC0_.BTDF */
                        Arg1 [0x04] = BTDV /* \_SB_.PCI0.LPCB.EC0_.BTDV */
                        Local0 = BTDA /* \_SB_.PCI0.LPCB.EC0_.BTDA */
                        Arg1 [One] = Local0
                        Local2 = ((Local0 * DWRN) / 0x64)
                        Arg1 [0x05] = Local2
                        Local2 = ((Local0 * DLOW) / 0x64)
                        Arg1 [0x06] = Local2
                        Arg1 [0x09] = BRSX (One)
                        Arg1 [0x0A] = BRSX (0x02)
                        Arg1 [0x0C] = BRSX (0x03)
                        Release (BATM)
                        Return (Arg1)
                    }

                    Method (BBIX, 2, Serialized)
                    {
                        If (Acquire (BATM, 0x03E8))
                        {
                            Return (Arg1)
                        }

                        If (BTSW (Arg0))
                        {
                            Release (BATM)
                            Return (Arg1)
                        }

                        Arg1 [0x03] = BTDF /* \_SB_.PCI0.LPCB.EC0_.BTDF */
                        Arg1 [0x05] = BTDV /* \_SB_.PCI0.LPCB.EC0_.BTDV */
                        Local0 = BTDA /* \_SB_.PCI0.LPCB.EC0_.BTDA */
                        Arg1 [0x02] = Local0
                        Local2 = ((Local0 * DWRN) / 0x64)
                        Arg1 [0x06] = Local2
                        Local2 = ((Local0 * DLOW) / 0x64)
                        Arg1 [0x07] = Local2
                        Arg1 [0x08] = BTCC /* \_SB_.PCI0.LPCB.EC0_.BTCC */
                        Arg1 [0x10] = BRSX (One)
                        Arg1 [0x11] = BRSX (0x02)
                        Arg1 [0x13] = BRSX (0x03)
                        Release (BATM)
                        Return (Arg1)
                    }

                    Method (BBST, 4, Serialized)
                    {
                        If (Acquire (BATM, 0x03E8))
                        {
                            Return (Arg1)
                        }

                        If (BTSW (Arg0))
                        {
                            Release (BATM)
                            Return (Arg1)
                        }

                        Local1 = Zero
                        If (ACEX)
                        {
                            If (BFCG)
                            {
                                Local1 = 0x02
                            }
                            ElseIf (BFDC)
                            {
                                Local1 = One
                            }
                        }
                        Else
                        {
                            Local1 = One
                        }

                        If (BFCR)
                        {
                            Local1 |= 0x04
                        }

                        Arg1 [Zero] = Local1
                        If ((Local1 != DerefOf (Arg2)))
                        {
                            Arg2 = Local1
                            If ((Arg0 == Zero))
                            {
                                Notify (BAT0, 0x80) // Status Change
                            }
                        }

                        Arg1 [One] = BTPR /* \_SB_.PCI0.LPCB.EC0_.BTPR */
                        Local1 = BTRA /* \_SB_.PCI0.LPCB.EC0_.BTRA */
                        If (((Arg3 && ACEX) && !(BFDC && BFCG)))
                        {
                            Local2 = BTDF /* \_SB_.PCI0.LPCB.EC0_.BTDF */
                            Local3 = (Local2 >> 0x04)
                            If (((Local1 > (Local2 - Local3)) && (Local1 < (Local2 + 
                                Local3))))
                            {
                                Local1 = Local2
                            }
                        }

                        Arg1 [0x02] = Local1
                        Arg1 [0x03] = BTVO /* \_SB_.PCI0.LPCB.EC0_.BTVO */
                        Release (BATM)
                        Return (Arg1)
                    }

                    Device (BAT0)
                    {
                        Name (_HID, EisaId ("PNP0C0A") /* Control Method Battery */)  // _HID: Hardware ID
                        Name (_UID, One)  // _UID: Unique ID
                        Name (_PCL, Package (0x01)  // _PCL: Power Consumer List
                        {
                            _SB, 
                        })
                        Name (PBIF, Package (0x0D)
                        {
                            One, 
                            0xFFFFFFFF, 
                            0xFFFFFFFF, 
                            One, 
                            0xFFFFFFFF, 
                            0x03, 
                            0xFFFFFFFF, 
                            One, 
                            One, 
                            "", 
                            "", 
                            "LION", 
                            ""
                        })
                        Name (PBIX, Package (0x14)
                        {
                            Zero, 
                            One, 
                            0xFFFFFFFF, 
                            0xFFFFFFFF, 
                            One, 
                            0xFFFFFFFF, 
                            0x03, 
                            0xFFFFFFFF, 
                            Zero, 
                            0x00018000, 
                            0x01F4, 
                            0x0A, 
                            0xFFFFFFFF, 
                            0xFFFFFFFF, 
                            One, 
                            One, 
                            "", 
                            "", 
                            "LION", 
                            ""
                        })
                        Name (PBST, Package (0x04)
                        {
                            Zero, 
                            0xFFFFFFFF, 
                            0xFFFFFFFF, 
                            0xFFFFFFFF
                        })
                        Name (BSTP, Zero)
                        Name (BFWK, One)
                        Method (BFWE, 0, NotSerialized)
                        {
                            BFWK = One
                        }

                        Method (BFWD, 0, NotSerialized)
                        {
                            BFWK = Zero
                        }

                        Method (_STA, 0, Serialized)  // _STA: Status
                        {
                            Return (BSTA (Zero))
                        }

                        Method (_BIF, 0, Serialized)  // _BIF: Battery Information
                        {
                            Return (BBIF (Zero, PBIF))
                        }

                        Method (_BIX, 0, Serialized)  // _BIX: Battery Information Extended
                        {
                            Return (BBIX (Zero, PBIX))
                        }

                        Method (_BST, 0, Serialized)  // _BST: Battery Status
                        {
                            Return (BBST (Zero, PBST, RefOf (BSTP), BFWK))
                        }
                    }

                    Device (CREC)
                    {
                        Name (_HID, "GOOG0004")  // _HID: Hardware ID
                        Name (_UID, One)  // _UID: Unique ID
                        Name (_DDN, "EC Command Device")  // _DDN: DOS Device Name
                        Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
                        {
                            0x70, 
                            0x05
                        })
                        Device (CKSC)
                        {
                            Name (_HID, "GOOG0007")  // _HID: Hardware ID
                            Name (_UID, One)  // _UID: Unique ID
                            Name (_DDN, "EC MKBP Device")  // _DDN: DOS Device Name
                            Method (_STA, 0, NotSerialized)  // _STA: Status
                            {
                                If ((DFUD || KEYB))
                                {
                                    Return (0x0F)
                                }

                                Return (Zero)
                            }
                        }

                        Device (ECPD)
                        {
                            Name (_HID, "GOOG0003")  // _HID: Hardware ID
                            Name (_UID, One)  // _UID: Unique ID
                            Name (_DDN, "EC PD Device")  // _DDN: DOS Device Name
                            Method (_STA, 0, NotSerialized)  // _STA: Status
                            {
                                Return (0x0F)
                            }
                        }

                        Device (TBMC)
                        {
                            Name (_HID, "GOOG0006")  // _HID: Hardware ID
                            Name (_UID, One)  // _UID: Unique ID
                            Name (_DDN, "Tablet Motion Control")  // _DDN: DOS Device Name
                            Method (TBMC, 0, NotSerialized)
                            {
                                If ((RCTM () == One))
                                {
                                    Return (One)
                                }
                                Else
                                {
                                    Return (Zero)
                                }
                            }

                            Method (_STA, 0, NotSerialized)  // _STA: Status
                            {
                                If ((MTNS == One))
                                {
                                    Return (0x0F)
                                }
                                Else
                                {
                                    Return (Zero)
                                }
                            }
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }
                    }

                    Device (ALS)
                    {
                        Name (_HID, "ACPI0008" /* Ambient Light Sensor Device */)  // _HID: Hardware ID
                        Name (_UID, One)  // _UID: Unique ID
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Method (_ALI, 0, NotSerialized)  // _ALI: Ambient Light Illuminance
                        {
                            Return (ALS0) /* \_SB_.PCI0.LPCB.EC0_.ALS0 */
                        }

                        Name (_ALP, 0x0A)  // _ALP: Ambient Light Polling
                        Name (_ALR, Package (0x02)  // _ALR: Ambient Light Response
                        {
                            Package (0x02)
                            {
                                0x46, 
                                0x1E
                            }, 

                            Package (0x02)
                            {
                                0x96, 
                                0x03E8
                            }
                        })
                    }

                    Scope (CREC)
                    {
                        Device (KBLT)
                        {
                            Name (_HID, "GOOG0002")  // _HID: Hardware ID
                            Name (_UID, One)  // _UID: Unique ID
                            Method (_STA, 0, NotSerialized)  // _STA: Status
                            {
                                Return (0x0F)
                            }
                        }
                    }

                    Scope (\_SB)
                    {
                        Device (KBLT)
                        {
                            Name (_HID, "GOOG0002")  // _HID: Hardware ID
                            Name (_UID, One)  // _UID: Unique ID
                            Method (_STA, 0, NotSerialized)  // _STA: Status
                            {
                                Return (Zero)
                            }

                            Method (KBQC, 0, NotSerialized)
                            {
                                Return (^^PCI0.LPCB.EC0.KBLV) /* \_SB_.PCI0.LPCB.EC0_.KBLV */
                            }

                            Method (KBCM, 1, NotSerialized)
                            {
                                ^^PCI0.LPCB.EC0.KBLV = Arg0
                            }
                        }
                    }

                    Device (VBTN)
                    {
                        Name (_HID, "INT33D6" /* Intel Virtual Buttons Device */)  // _HID: Hardware ID
                        Name (_DDN, "Tablet Virtual Buttons")  // _DDN: DOS Device Name
                        Method (VBDL, 0, NotSerialized)
                        {
                        }

                        Method (VGBS, 0, NotSerialized)
                        {
                            If ((RCTM () == One))
                            {
                                Return (Zero)
                            }
                            Else
                            {
                                Return (0x40)
                            }
                        }

                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }
                    }

                    Device (VBTO)
                    {
                        Name (_HID, "INT33D3" /* Intel GPIO Buttons */)  // _HID: Hardware ID
                        Name (_CID, "PNP0C60" /* Display Sensor Device */)  // _CID: Compatible ID
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }
                    }
                }

                Device (SIO)
                {
                    Name (_UID, Zero)  // _UID: Unique ID
                    Name (_ADR, Zero)  // _ADR: Address
                    Device (ECMM)
                    {
                        Name (_HID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _HID: Hardware ID
                        Name (_UID, 0x04)  // _UID: Unique ID
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Name (_CRS, Buffer (0x0A)  // _CRS: Current Resource Settings
                        {
                            /* 0000 */  0x47, 0x01, 0x00, 0x09, 0x00, 0x09, 0x08, 0xFF,  // G.......
                            /* 0008 */  0x79, 0x00                                       // y.
                        })
                    }

                    Device (ECUI)
                    {
                        Name (_HID, EisaId ("PNP0C02") /* PNP Motherboard Resources */)  // _HID: Hardware ID
                        Name (_UID, 0x03)  // _UID: Unique ID
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Name (_CRS, Buffer (0x22)  // _CRS: Current Resource Settings
                        {
                            /* 0000 */  0x47, 0x01, 0x00, 0x02, 0x00, 0x02, 0x01, 0x01,  // G.......
                            /* 0008 */  0x47, 0x01, 0x04, 0x02, 0x04, 0x02, 0x01, 0x01,  // G.......
                            /* 0010 */  0x47, 0x01, 0x00, 0x08, 0x00, 0x08, 0x08, 0x80,  // G.......
                            /* 0018 */  0x47, 0x01, 0x80, 0x08, 0x80, 0x08, 0x08, 0x80,  // G.......
                            /* 0020 */  0x79, 0x00                                       // y.
                        })
                    }
                }

                Scope (^^PCI0)
                {
                    Device (PS2K)
                    {
                        Name (_UID, Zero)  // _UID: Unique ID
                        Name (_HID, "GOOG000A")  // _HID: Hardware ID
                        Name (_CID, Package (0x02)  // _CID: Compatible ID
                        {
                            EisaId ("PNP0303") /* IBM Enhanced Keyboard (101/102-key, PS/2 Mouse) */, 
                            EisaId ("PNP030B")
                        })
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }

                        Name (_CRS, Buffer (0x16)  // _CRS: Current Resource Settings
                        {
                            /* 0000 */  0x47, 0x01, 0x60, 0x00, 0x60, 0x00, 0x01, 0x01,  // G.`.`...
                            /* 0008 */  0x47, 0x01, 0x64, 0x00, 0x64, 0x00, 0x01, 0x01,  // G.d.d...
                            /* 0010 */  0x23, 0x02, 0x00, 0x01, 0x79, 0x00               // #...y.
                        })
                    }
                }
            }

            Device (HDAS)
            {
                Name (_ADR, 0x001F0003)  // _ADR: Address
                Name (_DDN, "Audio Controller")  // _DDN: DOS Device Name
                Name (UUID, ToUUID ("a69f886e-6ceb-4594-a41f-7b5dce24c553") /* Unknown UUID */)
                Name (_S0W, 0x03)  // _S0W: S0 Device Wake State
                Name (NBUF, Buffer (0x30)
                {
                    /* 0000 */  0x8A, 0x2B, 0x00, 0x00, 0x0D, 0x10, 0x00, 0x00,  // .+......
                    /* 0008 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 0010 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 0018 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 0020 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00,  // ........
                    /* 0028 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79, 0x00   // ......y.
                })
                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If ((Arg0 == UUID))
                    {
                        If ((Arg2 == Zero))
                        {
                            If ((((Arg1 == One) && (NHLA != Zero)) && (
                                NHLL != Zero)))
                            {
                                Return (Buffer (One)
                                {
                                     0x03                                             // .
                                })
                            }
                            Else
                            {
                                Return (Buffer (One)
                                {
                                     0x01                                             // .
                                })
                            }
                        }

                        If ((Arg2 == One))
                        {
                            CreateQWordField (NBUF, 0x0E, NBAS)
                            CreateQWordField (NBUF, 0x16, NMAS)
                            CreateQWordField (NBUF, 0x26, NLEN)
                            NBAS = NHLA /* \NHLA */
                            NMAS = NHLA /* \NHLA */
                            NLEN = NHLL /* \NHLL */
                            Return (NBUF) /* \_SB_.PCI0.HDAS.NBUF */
                        }
                    }

                    Return (Buffer (One)
                    {
                         0x00                                             // .
                    })
                }
            }

            Method (IRQM, 1, Serialized)
            {
                Name (IQAA, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        Zero, 
                        Zero, 
                        0x10
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        One, 
                        Zero, 
                        0x11
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        Zero, 
                        0x12
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        Zero, 
                        0x13
                    }
                })
                Name (IQAP, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        Zero, 
                        LNKA, , 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        One, 
                        LNKB, , 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        LNKC, , 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        LNKD, , 
                        Zero
                    }
                })
                Name (IQBA, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        Zero, 
                        Zero, 
                        0x11
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        One, 
                        Zero, 
                        0x12
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        Zero, 
                        0x13
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        Zero, 
                        0x10
                    }
                })
                Name (IQBP, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        Zero, 
                        LNKB, , 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        One, 
                        LNKC, , 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        LNKD, , 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        LNKA, , 
                        Zero
                    }
                })
                Name (IQCA, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        Zero, 
                        Zero, 
                        0x12
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        One, 
                        Zero, 
                        0x13
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        Zero, 
                        0x10
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        Zero, 
                        0x11
                    }
                })
                Name (IQCP, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        Zero, 
                        LNKC, , 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        One, 
                        LNKD, , 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        LNKA, , 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        LNKB, , 
                        Zero
                    }
                })
                Name (IQDA, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        Zero, 
                        Zero, 
                        0x13
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        One, 
                        Zero, 
                        0x10
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        Zero, 
                        0x11
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        Zero, 
                        0x12
                    }
                })
                Name (IQDP, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        Zero, 
                        LNKD, , 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        One, 
                        LNKA, , 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        LNKB, , 
                        Zero
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        LNKC, , 
                        Zero
                    }
                })
                Switch (ToInteger (Arg0))
                {
                    Case (Package (0x04)
                        {
                            One, 
                            0x05, 
                            0x09, 
                            0x0D
                        }

)
                    {
                        If (PICM)
                        {
                            Return (IQAA) /* \_SB_.PCI0.IRQM.IQAA */
                        }
                        Else
                        {
                            Return (IQAP) /* \_SB_.PCI0.IRQM.IQAP */
                        }
                    }
                    Case (Package (0x04)
                        {
                            0x02, 
                            0x06, 
                            0x0A, 
                            0x0E
                        }

)
                    {
                        If (PICM)
                        {
                            Return (IQBA) /* \_SB_.PCI0.IRQM.IQBA */
                        }
                        Else
                        {
                            Return (IQBP) /* \_SB_.PCI0.IRQM.IQBP */
                        }
                    }
                    Case (Package (0x04)
                        {
                            0x03, 
                            0x07, 
                            0x0B, 
                            0x0F
                        }

)
                    {
                        If (PICM)
                        {
                            Return (IQCA) /* \_SB_.PCI0.IRQM.IQCA */
                        }
                        Else
                        {
                            Return (IQCP) /* \_SB_.PCI0.IRQM.IQCP */
                        }
                    }
                    Case (Package (0x04)
                        {
                            0x04, 
                            0x08, 
                            0x0C, 
                            0x10
                        }

)
                    {
                        If (PICM)
                        {
                            Return (IQDA) /* \_SB_.PCI0.IRQM.IQDA */
                        }
                        Else
                        {
                            Return (IQDP) /* \_SB_.PCI0.IRQM.IQDP */
                        }
                    }
                    Default
                    {
                        If (PICM)
                        {
                            Return (IQDA) /* \_SB_.PCI0.IRQM.IQDA */
                        }
                        Else
                        {
                            Return (IQDP) /* \_SB_.PCI0.IRQM.IQDP */
                        }
                    }

                }
            }

            Device (RP01)
            {
                Name (_ADR, 0x001C0000)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, 0x4C, 0x04)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x03), 
                    RPPN,   8
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP02)
            {
                Name (_ADR, 0x001C0001)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, 0x4C, 0x04)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x03), 
                    RPPN,   8
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP03)
            {
                Name (_ADR, 0x001C0002)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, 0x4C, 0x04)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x03), 
                    RPPN,   8
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP04)
            {
                Name (_ADR, 0x001C0003)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, 0x4C, 0x04)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x03), 
                    RPPN,   8
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP05)
            {
                Name (_ADR, 0x001C0004)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, 0x4C, 0x04)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x03), 
                    RPPN,   8
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP06)
            {
                Name (_ADR, 0x001C0005)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, 0x4C, 0x04)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x03), 
                    RPPN,   8
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP07)
            {
                Name (_ADR, 0x001C0006)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, 0x4C, 0x04)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x03), 
                    RPPN,   8
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP08)
            {
                Name (_ADR, 0x001C0007)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, 0x4C, 0x04)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x03), 
                    RPPN,   8
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP09)
            {
                Name (_ADR, 0x001D0000)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, 0x4C, 0x04)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x03), 
                    RPPN,   8
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP10)
            {
                Name (_ADR, 0x001D0001)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, 0x4C, 0x04)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x03), 
                    RPPN,   8
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP11)
            {
                Name (_ADR, 0x001D0002)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, 0x4C, 0x04)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x03), 
                    RPPN,   8
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP12)
            {
                Name (_ADR, 0x001D0003)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, 0x4C, 0x04)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x03), 
                    RPPN,   8
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP13)
            {
                Name (_ADR, 0x001D0004)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, 0x4C, 0x04)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x03), 
                    RPPN,   8
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP14)
            {
                Name (_ADR, 0x001D0005)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, 0x4C, 0x04)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x03), 
                    RPPN,   8
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP15)
            {
                Name (_ADR, 0x001D0006)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, 0x4C, 0x04)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x03), 
                    RPPN,   8
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Device (RP16)
            {
                Name (_ADR, 0x001D0007)  // _ADR: Address
                OperationRegion (RPCS, PCI_Config, 0x4C, 0x04)
                Field (RPCS, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x03), 
                    RPPN,   8
                }

                Method (_PRT, 0, NotSerialized)  // _PRT: PCI Routing Table
                {
                    Return (IRQM (RPPN))
                }
            }

            Method (GPCR, 2, NotSerialized)
            {
                If ((Arg0 == Zero))
                {
                    Local0 = 0xFD000000
                }
                ElseIf ((Arg0 == One))
                {
                    Local0 = Zero
                }
                Else
                {
                    Debug = Concatenate (Concatenate ("Invalid Die index (", Arg0), ")\n")
                    Return (Zero)
                }

                Return ((Local0 + (Arg1 << 0x10)))
            }

            Method (RPCR, 3, Serialized)
            {
                OperationRegion (PCRD, SystemMemory, (GPCR (Arg0, Arg1) + Arg2), 0x04)
                Field (PCRD, DWordAcc, NoLock, Preserve)
                {
                    DATA,   32
                }

                Return (DATA) /* \_SB_.PCI0.RPCR.DATA */
            }

            Method (APCR, 4, Serialized)
            {
                OperationRegion (PCRD, SystemMemory, (GPCR (Arg0, Arg1) + Arg2), 0x04)
                Field (PCRD, DWordAcc, NoLock, Preserve)
                {
                    DATA,   32
                }

                DATA &= Arg3
                RPCR (Arg0, Arg1, Arg2)
            }

            Method (OPCR, 4, Serialized)
            {
                OperationRegion (PCRD, SystemMemory, (GPCR (Arg0, Arg1) + Arg2), 0x04)
                Field (PCRD, DWordAcc, NoLock, Preserve)
                {
                    DATA,   32
                }

                DATA |= Arg3
                RPCR (Arg0, Arg1, Arg2)
            }

            Method (WPCR, 4, Serialized)
            {
                OperationRegion (PCRD, SystemMemory, (GPCR (Arg0, Arg1) + Arg2), 0x04)
                Field (PCRD, DWordAcc, NoLock, Preserve)
                {
                    DATA,   32
                }

                DATA = Arg3
                RPCR (Arg0, Arg1, Arg2)
            }

            Method (PCRB, 1, NotSerialized)
            {
                Return (GPCR (Zero, Arg0))
            }

            Method (PCRR, 2, Serialized)
            {
                Return (RPCR (Zero, Arg0, Arg1))
            }

            Method (PCRA, 3, Serialized)
            {
                APCR (Zero, Arg0, Arg1, Arg2)
            }

            Method (PCRO, 3, Serialized)
            {
                OPCR (Zero, Arg0, Arg1, Arg2)
            }

            Method (PCRW, 3, Serialized)
            {
                WPCR (Zero, Arg0, Arg1, Arg2)
            }

            Device (PMC)
            {
                Name (_ADR, 0x001F0002)  // _ADR: Address
                Name (_DDN, "Power Management Controller")  // _DDN: DOS Device Name
                OperationRegion (PMCP, PCI_Config, Zero, 0x0100)
                Field (PMCP, AnyAcc, NoLock, Preserve)
                {
                    Offset (0x48), 
                        ,   12, 
                    PWRM,   20
                }

                OperationRegion (PMCM, SystemMemory, (PWRM << 0x0C), 0x3F)
                Field (PMCM, DWordAcc, NoLock, Preserve)
                {
                    Offset (0x1C), 
                    Offset (0x1F), 
                    PMFS,   1, 
                    Offset (0x20), 
                    MPMC,   32, 
                    Offset (0x24), 
                        ,   20, 
                    UWAB,   1
                }
            }

            Device (I2C0)
            {
                Name (_ADR, 0x00150000)  // _ADR: Address
                Name (_DDN, "Serial IO I2C Controller 0")  // _DDN: DOS Device Name
            }

            Device (I2C1)
            {
                Name (_ADR, 0x00150001)  // _ADR: Address
                Name (_DDN, "Serial IO I2C Controller 1")  // _DDN: DOS Device Name
            }

            Device (I2C2)
            {
                Name (_ADR, 0x00150002)  // _ADR: Address
                Name (_DDN, "Serial IO I2C Controller 2")  // _DDN: DOS Device Name
            }

            Device (I2C3)
            {
                Name (_ADR, 0x00150003)  // _ADR: Address
                Name (_DDN, "Serial IO I2C Controller 3")  // _DDN: DOS Device Name
            }

            Device (I2C4)
            {
                Name (_ADR, 0x00190002)  // _ADR: Address
                Name (_DDN, "Serial IO I2C Controller 4")  // _DDN: DOS Device Name
            }

            Device (I2C5)
            {
                Name (_ADR, 0x00190001)  // _ADR: Address
                Name (_DDN, "Serial IO I2C Controller 5")  // _DDN: DOS Device Name
            }

            Device (SPI0)
            {
                Name (_ADR, 0x001E0002)  // _ADR: Address
                Name (_DDN, "Serial IO SPI Controller 0")  // _DDN: DOS Device Name
            }

            Device (SPI1)
            {
                Name (_ADR, 0x001E0003)  // _ADR: Address
                Name (_DDN, "Serial IO SPI Controller 1")  // _DDN: DOS Device Name
            }

            Device (UAR0)
            {
                Name (_ADR, 0x001E0000)  // _ADR: Address
                Name (_DDN, "Serial IO UART Controller 0")  // _DDN: DOS Device Name
            }

            Device (UAR1)
            {
                Name (_ADR, 0x001E0001)  // _ADR: Address
                Name (_DDN, "Serial IO UART Controller 1")  // _DDN: DOS Device Name
            }

            Device (UAR2)
            {
                Name (_ADR, 0x00190000)  // _ADR: Address
                Name (_DDN, "Serial IO UART Controller 2")  // _DDN: DOS Device Name
            }

            Device (SBUS)
            {
                Name (_ADR, 0x001F0004)  // _ADR: Address
            }

            Device (EMMC)
            {
                Name (_ADR, 0x001E0004)  // _ADR: Address
                Name (_DDN, "eMMC Controller")  // _DDN: DOS Device Name
                Name (UUID, ToUUID ("e5c937d0-3553-4d7a-9117-ea4d19c3434d") /* Device Labeling Interface */)
                Name (TEMP, Zero)
                OperationRegion (EMCR, PCI_Config, Zero, 0x0100)
                Field (EMCR, WordAcc, NoLock, Preserve)
                {
                    Offset (0x84), 
                    PMCR,   16, 
                    Offset (0xA2), 
                        ,   2, 
                    PGEN,   1
                }

                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If ((Arg0 == UUID))
                    {
                        If ((Arg2 == 0x09))
                        {
                            If ((Arg1 == 0x03))
                            {
                                Return (Package (0x05)
                                {
                                    Zero, 
                                    Ones, 
                                    Ones, 
                                    Ones, 
                                    Ones
                                })
                            }
                        }
                    }

                    Return (Buffer (One)
                    {
                         0x00                                             // .
                    })
                }

                Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                {
                    PGEN = Zero
                    PCRA (0xC0, 0x0600, 0x7FFFFFBA)
                    Sleep (0x02)
                    PCRO (0xC0, 0x0600, 0x80000045)
                    PMCR &= 0xFFFC
                    TEMP = PMCR /* \_SB_.PCI0.EMMC.PMCR */
                }

                Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                {
                    PGEN = One
                    PMCR |= 0x03
                    TEMP = PMCR /* \_SB_.PCI0.EMMC.PMCR */
                }

                Device (CARD)
                {
                    Name (_ADR, 0x08)  // _ADR: Address
                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                    {
                        Return (Zero)
                    }
                }
            }

            Device (SDXC)
            {
                Name (_ADR, 0x001E0006)  // _ADR: Address
                Name (_DDN, "SD Controller")  // _DDN: DOS Device Name
                Name (TEMP, Zero)
                OperationRegion (SDCR, PCI_Config, Zero, 0x0100)
                Field (SDCR, WordAcc, NoLock, Preserve)
                {
                    Offset (0x84), 
                    PMCR,   16, 
                    Offset (0xA2), 
                        ,   2, 
                    PGEN,   1
                }

                Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                {
                    PCRA (0xAC, 0x04C4, 0xFFFFEFFF)
                    PCRA (0xAC, 0x04CC, 0xFFFFEFFF)
                    PCRA (0xAC, 0x04D4, 0xFFFFEFFF)
                    PCRA (0xAC, 0x04DC, 0xFFFFEFFF)
                    PCRA (0xAC, 0x04E4, 0xFFFFEFFF)
                    PCRA (0xAC, 0x04F4, 0xFFFFEFFF)
                    PGEN = Zero
                    PCRA (0xC0, 0x0600, 0xFFFFFE7A)
                    Sleep (0x02)
                    PCRO (0xC0, 0x0600, 0x0185)
                    PMCR &= 0xFFFC
                    TEMP = PMCR /* \_SB_.PCI0.SDXC.PMCR */
                }

                Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                {
                    PGEN = One
                    PMCR |= 0x03
                    TEMP = PMCR /* \_SB_.PCI0.SDXC.PMCR */
                    PCRO (0xAC, 0x04C4, 0x1000)
                    PCRO (0xAC, 0x04CC, 0x1000)
                    PCRO (0xAC, 0x04D4, 0x1000)
                    PCRO (0xAC, 0x04DC, 0x1000)
                    PCRO (0xAC, 0x04E4, 0x1000)
                    PCRO (0xAC, 0x04F4, 0x1000)
                }

                Device (CARD)
                {
                    Name (_ADR, 0x08)  // _ADR: Address
                    Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
                    {
                        Return (One)
                    }
                }
            }

            Method (UPWE, 3, Serialized)
            {
                Local0 = (Arg1 + ((Arg0 - One) * 0x10))
                OperationRegion (PSCR, SystemMemory, ((Arg2 << 0x10) + Local0), 0x10)
                Field (PSCR, DWordAcc, NoLock, Preserve)
                {
                    PSCT,   32
                }

                Local0 = PSCT /* \_SB_.PCI0.UPWE.PSCT */
                Local0 &= 0xFFFFFFFF7F01FFED
                Local0 |= 0x06000000
                PSCT = Local0
            }

            Method (UWES, 3, Serialized)
            {
                Local0 = Arg0
                While (One)
                {
                    FindSetRightBit (Local0, Local1)
                    If ((Local1 == Zero))
                    {
                        Break
                    }

                    UPWE (Local1, Arg1, Arg2)
                    Local0 &= (Local0 - One)
                }
            }

            Device (XHCI)
            {
                Name (_ADR, 0x00140000)  // _ADR: Address
                Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
                {
                    0x6D, 
                    0x03
                })
                Method (_DSW, 3, NotSerialized)  // _DSW: Device Sleep Wake
                {
                    PMEE = Arg0
                    UWES ((U2WE & 0x03FF), 0x0480, XMEM)
                    UWES ((U3WE & 0x3F), 0x0540, XMEM)
                }

                Name (_S3D, 0x03)  // _S3D: S3 Device State
                Name (_S4D, 0x03)  // _S4D: S4 Device State
                Name (_S0W, 0x03)  // _S0W: S0 Device Wake State
                Name (_S3W, 0x03)  // _S3W: S3 Device Wake State
                Name (_S4W, 0x03)  // _S4W: S4 Device Wake State
                OperationRegion (XPRT, PCI_Config, Zero, 0x0100)
                Field (XPRT, AnyAcc, NoLock, Preserve)
                {
                    DVID,   16, 
                    Offset (0x10), 
                    Offset (0x12), 
                    XMEM,   16, 
                    Offset (0x50), 
                        ,   2, 
                    STGE,   1, 
                    Offset (0x74), 
                    D0D3,   2, 
                    Offset (0x75), 
                    PMEE,   1, 
                        ,   6, 
                    PMES,   1, 
                    Offset (0xA2), 
                        ,   2, 
                    D3HE,   1
                }

                OperationRegion (XREG, SystemMemory, ((XMEM << 0x10) + 0x8000), 0x0200)
                Field (XREG, DWordAcc, Lock, Preserve)
                {
                    Offset (0x1C4), 
                        ,   2, 
                    UPSW,   2
                }

                Method (_PSC, 0, Serialized)  // _PSC: Power State Current
                {
                    Return (D0D3) /* \_SB_.PCI0.XHCI.D0D3 */
                }

                Method (_PS0, 0, Serialized)  // _PS0: Power State 0
                {
                    If ((DVID != 0xFFFF))
                    {
                        If (!((XMEM == 0xFFFF) || (XMEM == Zero)))
                        {
                            D3HE = Zero
                            STGE = Zero
                            If ((D0D3 == 0x03))
                            {
                                Local0 = Zero
                                D0D3 = Local0
                                Local0 = D0D3 /* \_SB_.PCI0.XHCI.D0D3 */
                            }

                            UPSW = Zero
                            If (^^PMC.UWAB)
                            {
                                ^^PMC.MPMC = One
                                Local0 = 0x0A
                                While (^^PMC.PMFS)
                                {
                                    If (!Local0)
                                    {
                                        Break
                                    }

                                    Local0--
                                    Sleep (0x0A)
                                }
                            }
                        }
                    }
                }

                Method (_PS3, 0, Serialized)  // _PS3: Power State 3
                {
                    If ((DVID != 0xFFFF))
                    {
                        If (!((XMEM == 0xFFFF) || (XMEM == Zero)))
                        {
                            PMES = One
                            PMEE = One
                            If ((D0D3 == 0x03))
                            {
                                Local0 = Zero
                                D0D3 = Local0
                                Local0 = D0D3 /* \_SB_.PCI0.XHCI.D0D3 */
                            }

                            UPSW = 0x03
                            D3HE = One
                            STGE = One
                            Local0 = 0x03
                            D0D3 = Local0
                            Local0 = D0D3 /* \_SB_.PCI0.XHCI.D0D3 */
                            If (^^PMC.UWAB)
                            {
                                ^^PMC.MPMC = 0x03
                                Local0 = 0x0A
                                While (^^PMC.PMFS)
                                {
                                    If (!Local0)
                                    {
                                        Break
                                    }

                                    Local0--
                                    Sleep (0x0A)
                                }
                            }
                        }
                    }
                }

                Device (RHUB)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Method (GPLD, 1, Serialized)
                    {
                        Local0 = Package (0x01)
                            {
                                Buffer (0x10){}
                            }
                        CreateField (DerefOf (Local0 [Zero]), Zero, 0x07, REV)
                        REV = 0x02
                        CreateField (DerefOf (Local0 [Zero]), 0x40, One, VISI)
                        VISI = Arg0
                        Return (Local0)
                    }

                    Device (HS01)
                    {
                        Name (_ADR, One)  // _ADR: Address
                    }

                    Device (HS02)
                    {
                        Name (_ADR, 0x02)  // _ADR: Address
                    }

                    Device (HS03)
                    {
                        Name (_ADR, 0x03)  // _ADR: Address
                    }

                    Device (HS04)
                    {
                        Name (_ADR, 0x04)  // _ADR: Address
                    }

                    Device (HS05)
                    {
                        Name (_ADR, 0x05)  // _ADR: Address
                    }

                    Device (HS06)
                    {
                        Name (_ADR, 0x06)  // _ADR: Address
                    }

                    Device (HS07)
                    {
                        Name (_ADR, 0x07)  // _ADR: Address
                    }

                    Device (HS08)
                    {
                        Name (_ADR, 0x08)  // _ADR: Address
                    }

                    Device (HS09)
                    {
                        Name (_ADR, 0x09)  // _ADR: Address
                    }

                    Device (HS10)
                    {
                        Name (_ADR, 0x0A)  // _ADR: Address
                    }

                    Device (USR1)
                    {
                        Name (_ADR, 0x0B)  // _ADR: Address
                    }

                    Device (USR2)
                    {
                        Name (_ADR, 0x0C)  // _ADR: Address
                    }

                    Device (SS01)
                    {
                        Name (_ADR, 0x0D)  // _ADR: Address
                    }

                    Device (SS02)
                    {
                        Name (_ADR, 0x0E)  // _ADR: Address
                    }

                    Device (SS03)
                    {
                        Name (_ADR, 0x0F)  // _ADR: Address
                    }

                    Device (SS04)
                    {
                        Name (_ADR, 0x10)  // _ADR: Address
                    }

                    Device (SS05)
                    {
                        Name (_ADR, 0x11)  // _ADR: Address
                    }

                    Device (SS06)
                    {
                        Name (_ADR, 0x12)  // _ADR: Address
                    }
                }
            }

            Device (HECI)
            {
                Name (_ADR, 0x00160000)  // _ADR: Address
            }

            Method (_OSC, 4, NotSerialized)  // _OSC: Operating System Capabilities
            {
                If ((Arg0 == ToUUID ("33db4d5b-1ff7-401c-9657-7441c03dd766") /* PCI Host Bridge Device */))
                {
                    Return (Arg3)
                }
                Else
                {
                    CreateDWordField (Arg3, Zero, CDW1)
                    CDW1 |= 0x04
                    Return (Arg3)
                }
            }

            Scope (GFX0)
            {
                OperationRegion (GFXC, PCI_Config, Zero, 0x0100)
                Field (GFXC, DWordAcc, NoLock, Preserve)
                {
                    Offset (0x10), 
                    BAR0,   64, 
                    Offset (0xE4), 
                    ASLE,   32, 
                    Offset (0xFC), 
                    ASLS,   32
                }

                OperationRegion (GFRG, SystemMemory, (BAR0 & 0xFFFFFFFFFFFFFFF0), 0x00400000)
                Field (GFRG, DWordAcc, NoLock, Preserve)
                {
                    Offset (0xC8254), 
                    BCLV,   16
                }

                Field (GFRG, DWordAcc, NoLock, Preserve)
                {
                    Offset (0xC8256), 
                    BCLM,   16
                }

                Name (BRLV, Zero)
                Name (BRVA, Zero)
                Device (BOX3)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    OperationRegion (OPRG, SystemMemory, ASLS, 0x0400)
                    Field (OPRG, DWordAcc, NoLock, Preserve)
                    {
                        Offset (0x58), 
                        MBOX,   32, 
                        Offset (0x300), 
                        ARDY,   1, 
                        Offset (0x304), 
                        ASLC,   32, 
                        TCHE,   32, 
                        ALSI,   32, 
                        BCLP,   32, 
                        PFIT,   32, 
                        CBLV,   32
                    }

                    Method (XBCM, 1, Serialized)
                    {
                        If ((ASLS == Zero))
                        {
                            Return (Ones)
                        }

                        If (((MBOX & 0x04) == Zero))
                        {
                            Return (Ones)
                        }

                        Local1 = ((Arg0 * 0xFF) / 0x64)
                        If ((Local1 > 0xFF))
                        {
                            Local1 = 0xFF
                        }

                        BCLP = (Local1 | 0x80000000)
                        If ((ARDY == Zero))
                        {
                            Return (Ones)
                        }

                        ASLC = 0x02
                        ASLE = One
                        Local0 = 0x20
                        While ((Local0 > Zero))
                        {
                            Sleep (One)
                            If (((ASLC & 0x02) == Zero))
                            {
                                Local1 = ((ASLC >> 0x0C) & 0x03)
                                If ((Local1 == Zero))
                                {
                                    Return (Zero)
                                }
                                Else
                                {
                                    Return (Ones)
                                }
                            }

                            Local0--
                        }

                        Return (Ones)
                    }
                }

                Device (LEGA)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Method (DRCL, 2, NotSerialized)
                    {
                        Return (((Arg0 + (Arg1 / 0x02)) / Arg1))
                    }

                    Method (XBCM, 1, NotSerialized)
                    {
                        BCLV = DRCL ((Arg0 * BCLM), 0x64)
                    }

                    Method (XBQC, 0, NotSerialized)
                    {
                        If ((BCLM == Zero))
                        {
                            Return (Zero)
                        }

                        Local0 = DRCL ((BCLV * 0x64), BCLM)
                        Local1 = 0x02
                        While ((Local1 < (SizeOf (BRIG) - One)))
                        {
                            Local2 = DerefOf (BRIG [Local1])
                            Local3 = DerefOf (BRIG [(Local1 + One)])
                            If ((Local0 < Local3))
                            {
                                If (((Local0 < Local2) || ((Local0 - Local2) < (Local3 - 
                                    Local0))))
                                {
                                    Return (Local2)
                                }
                                Else
                                {
                                    Return (Local3)
                                }
                            }

                            Local1++
                        }

                        Return (Local3)
                    }
                }

                Method (XBCM, 1, NotSerialized)
                {
                    BRLV = Arg0
                    BRVA = One
                    If ((^BOX3.XBCM (Arg0) == Ones))
                    {
                        If ((BCLM != Zero))
                        {
                            ^LEGA.XBCM (Arg0)
                        }
                    }
                }

                Method (XBQC, 0, NotSerialized)
                {
                    If ((BCLM == Zero))
                    {
                        If ((BRVA != Zero))
                        {
                            Return (BRLV) /* \_SB_.PCI0.GFX0.BRLV */
                        }

                        Local0 = DerefOf (BRIG [Zero])
                        Return (Local0)
                    }

                    Local0 = ^LEGA.XBQC ()
                    If (((BRVA != Zero) && (Local0 != BRLV)))
                    {
                        If ((BRCT == Zero))
                        {
                            BRCT = One
                            XBCM (BRLV)
                            Local0 = ^LEGA.XBQC ()
                            BRCT = Zero
                        }
                    }

                    BRLV = Local0
                    BRVA = One
                    Return (Local0)
                }

                Name (BRCT, Zero)
                Method (BRID, 1, NotSerialized)
                {
                    Local0 = Match (BRIG, MEQ, Arg0, MTR, Zero, 0x02)
                    If ((Local0 == Ones))
                    {
                        Return ((SizeOf (BRIG) - One))
                    }

                    Return (Local0)
                }

                Method (XBCL, 0, NotSerialized)
                {
                    BRCT = One
                    Return (BRIG) /* \_SB_.PCI0.GFX0.BRIG */
                }

                Method (_DOS, 1, NotSerialized)  // _DOS: Disable Output Switching
                {
                }

                Method (DECB, 0, NotSerialized)
                {
                    If (BRCT)
                    {
                        Notify (LCD0, 0x87) // Device-Specific
                    }
                    Else
                    {
                        Local0 = BRID (XBQC ())
                        If ((Local0 != 0x02))
                        {
                            Local0--
                        }

                        XBCM (DerefOf (BRIG [Local0]))
                    }
                }

                Method (INCB, 0, NotSerialized)
                {
                    If (BRCT)
                    {
                        Notify (LCD0, 0x86) // Device-Specific
                    }
                    Else
                    {
                        Local0 = BRID (XBQC ())
                        If ((Local0 != (SizeOf (BRIG) - One)))
                        {
                            Local0++
                        }

                        XBCM (DerefOf (BRIG [Local0]))
                    }
                }
            }

            Scope (GFX0)
            {
                Name (BRIG, Package (0x67)
                {
                    0x64, 
                    0x64, 
                    Zero, 
                    One, 
                    0x02, 
                    0x03, 
                    0x04, 
                    0x05, 
                    0x06, 
                    0x07, 
                    0x08, 
                    0x09, 
                    0x0A, 
                    0x0B, 
                    0x0C, 
                    0x0D, 
                    0x0E, 
                    0x0F, 
                    0x10, 
                    0x11, 
                    0x12, 
                    0x13, 
                    0x14, 
                    0x15, 
                    0x16, 
                    0x17, 
                    0x18, 
                    0x19, 
                    0x1A, 
                    0x1B, 
                    0x1C, 
                    0x1D, 
                    0x1E, 
                    0x1F, 
                    0x20, 
                    0x21, 
                    0x22, 
                    0x23, 
                    0x24, 
                    0x25, 
                    0x26, 
                    0x27, 
                    0x28, 
                    0x29, 
                    0x2A, 
                    0x2B, 
                    0x2C, 
                    0x2D, 
                    0x2E, 
                    0x2F, 
                    0x30, 
                    0x31, 
                    0x32, 
                    0x33, 
                    0x34, 
                    0x35, 
                    0x36, 
                    0x37, 
                    0x38, 
                    0x39, 
                    0x3A, 
                    0x3B, 
                    0x3C, 
                    0x3D, 
                    0x3E, 
                    0x3F, 
                    0x40, 
                    0x41, 
                    0x42, 
                    0x43, 
                    0x44, 
                    0x45, 
                    0x46, 
                    0x47, 
                    0x48, 
                    0x49, 
                    0x4A, 
                    0x4B, 
                    0x4C, 
                    0x4D, 
                    0x4E, 
                    0x4F, 
                    0x50, 
                    0x51, 
                    0x52, 
                    0x53, 
                    0x54, 
                    0x55, 
                    0x56, 
                    0x57, 
                    0x58, 
                    0x59, 
                    0x5A, 
                    0x5B, 
                    0x5C, 
                    0x5D, 
                    0x5E, 
                    0x5F, 
                    0x60, 
                    0x61, 
                    0x62, 
                    0x63, 
                    0x64
                })
            }
        }

        Name (CHPS, Package (0x08)
        {
            Package (0x08)
            {
                Zero, 
                Zero, 
                Zero, 
                Zero, 
                0xFF, 
                0x1338, 
                "mA", 
                Zero
            }, 

            Package (0x08)
            {
                Zero, 
                Zero, 
                Zero, 
                Zero, 
                0x27, 
                0x09C0, 
                "mA", 
                Zero
            }, 

            Package (0x08)
            {
                Zero, 
                Zero, 
                Zero, 
                Zero, 
                0x1C, 
                0x0700, 
                "mA", 
                Zero
            }, 

            Package (0x08)
            {
                Zero, 
                Zero, 
                Zero, 
                Zero, 
                0x13, 
                0x04C0, 
                "mA", 
                Zero
            }, 

            Package (0x08)
            {
                Zero, 
                Zero, 
                Zero, 
                Zero, 
                0x0D, 
                0x0340, 
                "mA", 
                Zero
            }, 

            Package (0x08)
            {
                Zero, 
                Zero, 
                Zero, 
                Zero, 
                0x0A, 
                0x0280, 
                "mA", 
                Zero
            }, 

            Package (0x08)
            {
                Zero, 
                Zero, 
                Zero, 
                Zero, 
                0x06, 
                0x0180, 
                "mA", 
                Zero
            }, 

            Package (0x08)
            {
                Zero, 
                Zero, 
                Zero, 
                Zero, 
                0x02, 
                0x80, 
                "mA", 
                Zero
            }
        })
        Name (DTRT, Package (0x05)
        {
            Package (0x08)
            {
                PCI0.B0D4, , 
                PCI0.B0D4, , 
                0x64, 
                0x0A, 
                Zero, 
                Zero, 
                Zero, 
                Zero
            }, 

            Package (0x08)
            {
                PCI0.B0D4, , 
                DPTF.TSR0, , 
                0x64, 
                0x64, 
                Zero, 
                Zero, 
                Zero, 
                Zero
            }, 

            Package (0x08)
            {
                DPTF.TCHG, , 
                DPTF.TSR1, , 
                0x64, 
                0x32, 
                Zero, 
                Zero, 
                Zero, 
                Zero
            }, 

            Package (0x08)
            {
                PCI0.B0D4, , 
                DPTF.TSR2, , 
                0x64, 
                0x64, 
                Zero, 
                Zero, 
                Zero, 
                Zero
            }, 

            Package (0x08)
            {
                DPTF.TCHG, , 
                DPTF.TSR3, , 
                0x64, 
                0x32, 
                Zero, 
                Zero, 
                Zero, 
                Zero
            }
        })
        Name (MPPC, Package (0x03)
        {
            0x02, 
            Package (0x06)
            {
                Zero, 
                0x0640, 
                0x2710, 
                0x03E8, 
                0x03E8, 
                0xC8
            }, 

            Package (0x06)
            {
                One, 
                0x1F40, 
                0x1F40, 
                0x03E8, 
                0x03E8, 
                0x03E8
            }
        })
        Device (DPTF)
        {
            Name (_HID, EisaId ("INT3400") /* Intel Dynamic Power Performance Management */)  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (IDSP, Package (0x03)
            {
                ToUUID ("42a441d6-ae6a-462b-a84b-4a8ce79027d3") /* Unknown UUID */, 
                ToUUID ("97c68ae7-15fa-499c-b8c9-5da81d606e0a") /* Unknown UUID */, 
                ToUUID ("16caf1b7-dd38-40ed-b1c1-1b8a1913d531") /* Unknown UUID */
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If ((DPTE == One))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Method (_OSC, 4, Serialized)  // _OSC: Operating System Capabilities
            {
                If ((DerefOf (IDSP [Zero]) == Arg0))
                {
                    TINI ()
                    ^TCHG.INIT ()
                }

                Return (Arg3)
            }

            Name (TRTR, One)
            Method (_TRT, 0, NotSerialized)  // _TRT: Thermal Relationship Table
            {
                Return (DTRT) /* \_SB_.DTRT */
            }

            Method (CTOK, 1, NotSerialized)
            {
                Local0 = (Arg0 * 0x0A)
                Local0 += 0x0AAC
                Return (Local0)
            }

            Method (TEVT, 1, NotSerialized)
            {
                If ((ToInteger (Arg0) == One))
                {
                    Notify (TSR0, 0x90) // Device-Specific
                }

                If ((ToInteger (Arg0) == 0x02))
                {
                    Notify (TSR1, 0x90) // Device-Specific
                }

                If ((ToInteger (Arg0) == 0x03))
                {
                    Notify (TSR2, 0x90) // Device-Specific
                }

                If ((ToInteger (Arg0) == 0x04))
                {
                    Notify (TSR3, 0x90) // Device-Specific
                }
            }

            Method (TINI, 0, NotSerialized)
            {
                ^TSR0.PATD ()
                ^TSR1.PATD ()
                ^TSR2.PATD ()
                ^TSR3.PATD ()
            }

            Method (TPET, 0, NotSerialized)
            {
                Notify (TSR0, 0x81) // Information Change
                Notify (TSR1, 0x81) // Information Change
                Notify (TSR2, 0x81) // Information Change
                Notify (TSR3, 0x81) // Information Change
            }

            Method (DTRP, 2, Serialized)
            {
                If (CondRefOf (\_SB.PCI0.LPCB.EC0.RCDP))
                {
                    If ((^^PCI0.LPCB.EC0.RCDP () == One))
                    {
                        Return (CTOK (Arg0))
                    }
                }

                Return (CTOK (Arg1))
            }

            Device (TSR0)
            {
                Name (_HID, EisaId ("INT3403") /* DPTF Temperature Sensor */)  // _HID: Hardware ID
                Name (_UID, One)  // _UID: Unique ID
                Name (PTYP, 0x03)
                Name (TMPI, One)
                Name (_STR, Unicode ("WiFi"))  // _STR: Description String
                Name (GTSH, 0x14)
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    If ((DPTE == One))
                    {
                        Return (0x0F)
                    }
                    Else
                    {
                        Return (Zero)
                    }
                }

                Method (_TMP, 0, Serialized)  // _TMP: Temperature
                {
                    Return (^^^PCI0.LPCB.EC0.TSRD (TMPI))
                }

                Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
                {
                    Return (DTRP (0x34, 0x32))
                }

                Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
                {
                    Return (DTRP (0x50, 0x50))
                }

                Name (PATC, 0x02)
                Method (PAT0, 1, Serialized)
                {
                    ^^^PCI0.LPCB.EC0.PAT0 (TMPI, Arg0)
                }

                Method (PAT1, 1, Serialized)
                {
                    ^^^PCI0.LPCB.EC0.PAT1 (TMPI, Arg0)
                }

                Method (PATD, 0, Serialized)
                {
                    ^^^PCI0.LPCB.EC0.PATD (TMPI)
                }
            }

            Device (TSR1)
            {
                Name (_HID, EisaId ("INT3403") /* DPTF Temperature Sensor */)  // _HID: Hardware ID
                Name (_UID, 0x02)  // _UID: Unique ID
                Name (PTYP, 0x03)
                Name (TMPI, 0x02)
                Name (_STR, Unicode ("PD"))  // _STR: Description String
                Name (GTSH, 0x14)
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    If ((DPTE == One))
                    {
                        Return (0x0F)
                    }
                    Else
                    {
                        Return (Zero)
                    }
                }

                Method (_TMP, 0, Serialized)  // _TMP: Temperature
                {
                    Return (^^^PCI0.LPCB.EC0.TSRD (TMPI))
                }

                Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
                {
                    Return (DTRP (0x34, 0x32))
                }

                Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
                {
                    Return (DTRP (0x50, 0x50))
                }

                Name (PATC, 0x02)
                Method (PAT0, 1, Serialized)
                {
                    ^^^PCI0.LPCB.EC0.PAT0 (TMPI, Arg0)
                }

                Method (PAT1, 1, Serialized)
                {
                    ^^^PCI0.LPCB.EC0.PAT1 (TMPI, Arg0)
                }

                Method (PATD, 0, Serialized)
                {
                    ^^^PCI0.LPCB.EC0.PATD (TMPI)
                }
            }

            Device (TSR2)
            {
                Name (_HID, EisaId ("INT3403") /* DPTF Temperature Sensor */)  // _HID: Hardware ID
                Name (_UID, 0x03)  // _UID: Unique ID
                Name (PTYP, 0x03)
                Name (TMPI, 0x03)
                Name (_STR, Unicode ("DRAM"))  // _STR: Description String
                Name (GTSH, 0x14)
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    If ((DPTE == One))
                    {
                        Return (0x0F)
                    }
                    Else
                    {
                        Return (Zero)
                    }
                }

                Method (_TMP, 0, Serialized)  // _TMP: Temperature
                {
                    Return (^^^PCI0.LPCB.EC0.TSRD (TMPI))
                }

                Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
                {
                    Return (DTRP (0x34, 0x32))
                }

                Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
                {
                    Return (DTRP (0x50, 0x50))
                }

                Name (PATC, 0x02)
                Method (PAT0, 1, Serialized)
                {
                    ^^^PCI0.LPCB.EC0.PAT0 (TMPI, Arg0)
                }

                Method (PAT1, 1, Serialized)
                {
                    ^^^PCI0.LPCB.EC0.PAT1 (TMPI, Arg0)
                }

                Method (PATD, 0, Serialized)
                {
                    ^^^PCI0.LPCB.EC0.PATD (TMPI)
                }
            }

            Device (TSR3)
            {
                Name (_HID, EisaId ("INT3403") /* DPTF Temperature Sensor */)  // _HID: Hardware ID
                Name (_UID, 0x04)  // _UID: Unique ID
                Name (PTYP, 0x03)
                Name (TMPI, 0x04)
                Name (_STR, Unicode ("Charger"))  // _STR: Description String
                Name (GTSH, 0x14)
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    If ((DPTE == One))
                    {
                        Return (0x0F)
                    }
                    Else
                    {
                        Return (Zero)
                    }
                }

                Method (_TMP, 0, Serialized)  // _TMP: Temperature
                {
                    Return (^^^PCI0.LPCB.EC0.TSRD (TMPI))
                }

                Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
                {
                    Return (DTRP (0x44, 0x44))
                }

                Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
                {
                    Return (DTRP (0x55, 0x55))
                }

                Name (PATC, 0x02)
                Method (PAT0, 1, Serialized)
                {
                    ^^^PCI0.LPCB.EC0.PAT0 (TMPI, Arg0)
                }

                Method (PAT1, 1, Serialized)
                {
                    ^^^PCI0.LPCB.EC0.PAT1 (TMPI, Arg0)
                }

                Method (PATD, 0, Serialized)
                {
                    ^^^PCI0.LPCB.EC0.PATD (TMPI)
                }
            }

            Device (TCHG)
            {
                Name (_HID, "INT3403" /* DPTF Temperature Sensor */)  // _HID: Hardware ID
                Name (_UID, Zero)  // _UID: Unique ID
                Name (PTYP, 0x0B)
                Name (_STR, Unicode ("Battery Charger"))  // _STR: Description String
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    If ((DPTE == One))
                    {
                        Return (0x0F)
                    }
                    Else
                    {
                        Return (Zero)
                    }
                }

                Method (PPSS, 0, NotSerialized)
                {
                    Return (CHPS) /* \_SB_.CHPS */
                }

                Method (PPPC, 0, NotSerialized)
                {
                    Local0 = SizeOf (CHPS)
                    Local0--
                    If ((^^^PCI0.LPCB.EC0.ACEX == Zero))
                    {
                        Return (Local0)
                    }
                    Else
                    {
                        Return (Zero)
                    }

                    Return (Zero)
                }

                Method (SPPC, 1, NotSerialized)
                {
                    Local0 = DerefOf (DerefOf (CHPS [ToInteger (Arg0)]) [0x04]
                        )
                    ^^^PCI0.LPCB.EC0.CHGS (Local0)
                }

                Method (INIT, 0, NotSerialized)
                {
                    ^^^PCI0.LPCB.EC0.CHGD ()
                }
            }
        }

        Scope (PCI0)
        {
            Device (B0D4)
            {
                Name (_ADR, 0x00040000)  // _ADR: Address
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    If ((DPTE == One))
                    {
                        Return (0x0F)
                    }
                    Else
                    {
                        Return (Zero)
                    }
                }

                Method (_PPC, 0, NotSerialized)  // _PPC: Performance Present Capabilities
                {
                    Return (Zero)
                }

                Method (SPPC, 1, NotSerialized)
                {
                    PPCM = Arg0
                    PPCN ()
                }

                Method (_PSS, 0, NotSerialized)  // _PSS: Performance Supported States
                {
                    If (CondRefOf (\_SB.CP00._PSS))
                    {
                        Return (^^^CP00._PSS) /* External reference */
                    }
                    Else
                    {
                        Return (Package (0x01)
                        {
                            Package (0x06)
                            {
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero, 
                                Zero
                            }
                        })
                    }
                }

                Method (_PDL, 0, NotSerialized)  // _PDL: P-state Depth Limit
                {
                    If (CondRefOf (\_SB.MPDL))
                    {
                        Return (MPDL) /* External reference */
                    }
                    ElseIf (CondRefOf (\_SB.CP00._PSS))
                    {
                        Local0 = SizeOf (^^^CP00._PSS)
                        Local0--
                        Return (Local0)
                    }
                    Else
                    {
                        Return (Zero)
                    }
                }

                Method (PPCC, 0, NotSerialized)
                {
                    Return (MPPC) /* \_SB_.MPPC */
                }

                Method (_CRT, 0, NotSerialized)  // _CRT: Critical Temperature
                {
                    Return (^^^DPTF.CTOK (0x63))
                }

                Method (_PSV, 0, NotSerialized)  // _PSV: Passive Temperature
                {
                    Return (^^^DPTF.CTOK (0x50))
                }
            }
        }
    }
}

