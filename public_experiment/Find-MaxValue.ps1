# using namespace Management.Automation

$experimentToExport.function += @(
    'Find-NumericMaxValue'
)
# $experimentToExport.alias += @(
#     'joinStr'
# )
$experimentToExport.update_typeDataScriptBlock += @(
    {
        Update-TypeData -TypeName 'Nin.NumericTypeInfo'  -DefaultDisplayPropertySet @(
            'Name', 'Type', 'MaxValue', 'MinValue'
        ) -Force
    }
)

function Find-NumericMaxValue {
    <#
    .synopsis
        Max and min values of all the standard built in types
    .description
        .todo:
            minimal format, shows using '{0:n0}'
    .notes
        see:
            - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_type_accelerators?view=powershell-7.2
            - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_numeric_literals?view=powershell-7.2
    .link
        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_numeric_literals?view=powershell-7.2
    .link
        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_type_accelerators?view=powershell-7.2

    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        #
    )
    begin {
        Write-Verbose @'
## Numeric type accelerators

| Accelerator                  | Description                     |
| ---------------------------- | ------------------------------- |
| [byte]                       | Byte (unsigned)                 |
| [sbyte]                      | Byte (signed)                   |
| [Int16]                      | 16-bit integer                  |
| [short]  alias for [int16]   | 16-bit integer                  |
| [UInt16]                     | 16-bit integer (unsigned)       |
| [ushort] 	alias for [uint16] | 16-bit integer (unsigned)       |
| [Int32]                      | 32-bit integer                  |
| [int] 	alias for [int32]  | 32-bit integer                  |
| [UInt32]                     | 32-bit integer (unsigned)       |
| [uint] 	alias for [uint32] | 32-bit integer (unsigned)       |
| [Int64]                      | 64-bit integer                  |
| [long] 	alias for [int64]  | 64-bit integer                  |
| [UInt64]                     | 64-bit integer (unsigned)       |
| [ulong] 	alias for [uint64] | 64-bit integer (unsigned)       |
| [bigint]                     | See BigInteger Struct           |
| [single]                     | Single precision floating point |
| [float] 	alias for [single] | Single precision floating point |
| [double]                     | Double precision floating point |
| [decimal]                    | 128-bit floating point          |
'@
    }

    process {

        $typeList = 'bigint', 'byte', 'decimal', 'double', 'float', 'int', 'int16', 'Int32', 'Int64', 'long', 'sbyte', 'short', 'single', 'uint', 'uint16', 'UInt32', 'UInt64', 'ulong', 'ushort'

        # Find-Type -Namespace *numeric* | ForEach-Object fullname

        $typeList | ForEach-Object -ea continue {
            $tName = $_
            $tinfo = $tName -as 'type'
            $meta = @{
                PSTypeName       = 'Dev.Nin.NumericTypeInfo'
                Name             = $tName
                Type             = $tInfo
                MaxValue         = $tinfo::MaxValue
                MinValue         = $tinfo::MinValue
                # MaxValueStr      = '{0:n0}' -f $tinfo::MaxValue
                MaxValueStr_1mil = '{0:n0}' -f @($tinfo::MaxValue / 1000000)
            }
            [pscustomobject]$meta

        } | Sort-Object MaxValue -Descending
    }

}


# Find-MaxValue | Format-Table -AutoSize
# hr
# Find-MaxValue
# | Format-Table -AutoSize