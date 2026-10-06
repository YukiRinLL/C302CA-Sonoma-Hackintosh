// C302CA (CAVE) / Skylake-Y, MrChromebox coreboot
// XHCI(00:14.0) 在 macOS 中消失：DSDT 的 _PS0 依赖 PMC(0x0600) 寄存器序列
// 上电，macOS 电源管理将控制器切到 D3 后 _PS0 可能恢复失败，导致
// IOPCIDevice 被注销，AppleUSBXHCIPCI 无法匹配。
// 修复：覆盖 _PS3 为 no-op（保持 D0），覆盖 _S3D/_S4D 为 0（不支持 D3），
// 注入 AAPL 控制器属性帮助 AppleUSBXHCIPCI 匹配。
DefinitionBlock ("", "SSDT", 2, "sqrl", "xhc", 0x00000000)
{
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.XHCI, DeviceObj)

    Scope (\_SB.PCI0.XHCI)
    {
        // 不支持 D3，macOS 不会尝试切到 D3hot
        Name (_S3D, 0x00)
        Name (_S4D, 0x00)

        // 覆盖 _PS3 为 no-op，保持控制器在 D0
        Method (_PS3, 0, Serialized)
        {
        }

        // _PS0 保持原样（DSDT 已定义，coreboot 会调用）
        // 注入 macOS USB 控制器属性
        Method (_DSM, 4, NotSerialized)
        {
            If (LEqual (Arg0, ToUUID ("4B61726F-6C69-6E61-736B-000000000000")))
            {
                Return (0x00)
            }
            If (LEqual (Arg0, ToUUID ("5009115F-5C1E-4A5B-8C4F-0E6C5E3FA51C")))
            {
                Return (Package (0x02)
                {
                    "AAPL,current-available", 0x00000000
                })
            }
            Return (Buffer (One) { 0x00 })
        }
    }
}
