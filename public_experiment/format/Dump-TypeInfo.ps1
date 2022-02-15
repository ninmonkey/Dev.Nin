#Requires -Version 7
using namespace System.Collections.Generic

# using namespace
if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_dumpPsTypeName'
        'compareNumericTypes'
        'disMin'
    )
    $experimentToExport.alias += @(
        'Dump->TNames'
    )
}

function compareNumericTypes {
    <#
    .synopsis
        compare full type names, min, max, etc
    .example
        @(
            234
            2395563459
            [double]::MaxValue
        ) | compareNumericTypes

        # output:

                            Input Type                             Min                   Max IsPrimitive UnderlyingSystemType
                            ----- ----                             ---                   --- ----------- --------------------
            1.79769313486232E+308 System.Double -1.79769313486232E+308 1.79769313486232E+308        True System.Double
                                234 System.Int32             -2147483648            2147483647        True System.Int32
                        2395563459 System.Int64    -9223372036854775808   9223372036854775807        True System.Int64
    #>
    param(
        # input as any type
        [parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputObject
    )
    begin {
        $numList = [List[object]]::new()
    }
    process {
        $numList.AddRange( $InputObject )
    }
    end {
        $numList
        | ForEach-Object {
            $tinfo = $_.GetType()
            [pscustomobject]@{
                'Input'                = $_
                'Type'                 = $tinfo
                'Min'                  = $tinfo::MinValue
                'Max'                  = $tinfo::MaxValue
                'IsPrimitive'          = $tinfo.IsPrimitive
                'UnderlyingSystemType' = $tinfo.UnderlyingSystemType
            }

        } | Sort-Object Type
    }
}

function disMin {
    <#
    .synopsis
        invoke dism with defaults
    #>
    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [scriptblock]$sb
    )
    $splatDis = @{
        ScriptBlock = $sb
        Minimal     = $true
    }

    Sci->Dism @splatDis
  | bat -l cs
}

# $nums = @(
#     234
#     2395563459
#     [double]::MaxValue
# )
# $nums | compareTypes
# $nums | ForEach-Object {
#     [pscustomobject]@{
#         'Input' = $_
#         'Type'  = $_.GetType()
#     }

# }




function _dumpPsTypeName {
    <#
    .synopsis
        dump a bunch of type info, as formatted text
    .description
    see this to see how to map typeinfo to a string that's url
        <https://github.com/SeeminglyScience/ClassExplorer/blob/signature-query/src/ClassExplorer/SignatureWriter.cs>
    .EXAMPLE
        PS> (ls . -file | f 1) | _dumpPsTypeName
        PS> (gi .) | _dumpPsTypeName
    #>
    [alias('Dump->TNames')]
    param(
        [alias('Target')]
        [parameter(position = 0, valueFromPipeline)]
        [object]$InputObject
    )

    # $TInfo = $InputObject -as 'type'
    # if ($InputObject -is 'type') {
    #     $Target = $inputObject.GetTypeInfo()
    # }
    # $TypeName | Write-Debug
    # $TypeName -as [type] | Write-Debug
    hr
    $tinfo = $InputObject.GetType()
    if (($null -eq $tinfo) -or ($null -eq $InputObject)) {
        return
    }
    $tinfo.BaseType.FullName | label 'baseType.fullname'
    [string]$tinfo.BaseType | label 'base [str]'
    [string]$tinfo | label 'root [str]'

    $tinfo.psobject.psbase.TypeNameOfValue | label 'psobject->psbase->TypeNameOfValue'
    hr
    $TypeNames = $InputObject.PSTypeNames
    # Wait-Debugger

    $str_op = @'
<#
$obj.PSTypeNames:
'@
    $str_op2 = @'
<#
$obj[0].PSTypeNames:
'@
    $str_os = @'
#>
'@

    $str_op
    $TypeNames | str str "`n" -SingleQuote -Sort -Unique
    | Format-IndentText -Depth 2

    $str_op2
    ($InputObject)?[0].PSTypeNames
    | str str "`n" -SingleQuote -Sort -Unique
    | Format-IndentText -Depth 2

    if ($InputObject.count -gt 1) {
        h1 'child'
        # ($InputObject).pstypenames
        @($InputObject)[0].pstypenames

    }
    $str_os

    # interfaces

}




if (! $experimentToExport) {
    # ...
}
