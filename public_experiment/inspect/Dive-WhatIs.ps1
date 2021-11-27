#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Dive-WhatIsDump'
    )
    $experimentToExport.alias += @(
        'dw'
        'Dive->WhatIsDump'
    )
}

function Dive-WhatIsDump {
    <#
    .synopsis
        Stuff
    .description
        .

    #>
    [Alias('dw', 'Dive->WhatIsDump')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        #
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )
    begin {
        $Str = @{
            NullStr = "[`u{2400}]"
            Sep     = '➝'
        }
    }
    process {
        if ($Null -eq $InputObject) {
            $Str.NullStr; return;
        }
        $target = $InputObject
        $t = $error[0].InvocationInfo
        $out_prop1 | iter->prop | ForEach-Object name
        $out_prop2 = $t | Get-Member -MemberType Properties | ForEach-Object Name


        $target = $error[0]
        $t_iInfo = $target.InvocationInfo
        $t_iInfo | Iter->PropName | str ul -Sort
        $t_iInfo

        $t_prop_iter = $target
        $t_prop_iter | Iter->PropName | str ul -Sort
        $t_prop_iter

        $t | Iter->PropName | str ul -Sort -op 'Props: '
        $t.psobject.methods | str ul -Sort -op 'Props: '
        # $t.psobject.me
        $t
        $t | Get-Member -MemberType Methods | ForEach-Object Name | Sort-Object -Unique | str csv ' ' -op 'Methods: '
        $t = $error[0].InvocationInfo
        $out_prop1 | iter->prop | ForEach-Object name
        $out_prop2 = $t | Get-Member -MemberType Properties | ForEach-Object Name
        $t | Write-Endcap Bold
    }
    end {
    }

}

if (! $experimentToExport) {
    # ...
}