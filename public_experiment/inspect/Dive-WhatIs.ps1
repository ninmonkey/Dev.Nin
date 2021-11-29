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

    some in:
        _Write-ErrorSummaryPrompt
    many error processing ones in:
        C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin\public_experiment\format\_formatErrorSummary.ps1
    many in:
        C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin\public_experiment\current\Pipe-Error.ps1
    many error proc in:
        C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin\public_experiment\cmd-code\Invoke-VSCodeViewError.ps1
    .notes
    .link
        Dev.Nin\__inspectErrorType

    #>
    [Alias(
        'dw',
        'Dive->WhatIsDump'
    )]
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

    [System.Exception] | Show-type
    [System.Exception] | Show-type -OutputFormat Csv

    [System.Management.Automation.ErrorRecord] | show-type
}