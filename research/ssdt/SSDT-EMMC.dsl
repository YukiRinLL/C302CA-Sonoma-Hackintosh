// C302CA (CAVE) / Skylake-Y, MrChromebox coreboot
// coreboot 的 SCS(00:1e) DSDT 不给 EMMC(1e.4) 声明 _CRS 中断资源，
// PCI config 的 Interrupt Pin 寄存器也为 0（ChromeOS 走 MSI）。
// macOS IOPCIDevice 读不到中断 → EmeraldSDHC 的 IOInterruptEventSource
// 创建失败 → 驱动拒绝在 eMMC 上 start → 反而挂到空的 SDXC(1e.6) 上。
// 本 SSDT 给 \_SB.PCI0.EMMC 补 _CRS：
//   - 64-bit MMIO（从 PCI BAR0+BAR1 动态读取，不硬编码地址）
//   - INTC=GSI22 中断（_PRT: 0x1E pin2→0x16）
// Skylake SCS 硬件引脚：eMMC→INTC(22), SDXC→INTD(23)。
DefinitionBlock ("", "SSDT", 2, "sqrl", "emmc", 0x00000000)
{
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.EMMC, DeviceObj)

    Scope (\_SB.PCI0.EMMC)
    {
        OperationRegion (EPCI, PCI_Config, 0x10, 0x10)
        Field (EPCI, DWordAcc, NoLock, Preserve)
        {
            BAR0, 32,
            BAR1, 32
        }

        Method (_CRS, 0, Serialized)
        {
            Name (BUF0, ResourceTemplate ()
            {
                QWordMemory (ResourceConsumer, PosDecode, MinFixed, MaxFixed,
                    NonCacheable, ReadWrite,
                    0x0000000000000000,
                    0x0000000000000000,
                    0x0000000000000FFF,
                    0x0000000000000000,
                    0x0000000000001000,
                    , )
                Interrupt (ResourceConsumer, Level, ActiveLow, Shared, , , )
                {
                    0x16
                }
            })
            // QWordMemory Min at buffer offset 0x0E, Max at 0x16
            CreateQWordField (BUF0, 0x0E, MMIN)
            CreateQWordField (BUF0, 0x16, MMAX)
            Local0 = BAR0
            And (Local0, 0xFFFFFFF0, Local0)
            Local1 = BAR1
            ShiftLeft (Local1, 32, Local1)
            Or (Local0, Local1, Local0)
            MMIN = Local0
            MMAX = Local0 + 0x0FFF
            Return (BUF0)
        }
    }
}
