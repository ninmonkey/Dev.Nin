#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'F'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

function Find-FunctionInfo {
    <#
    .notes
        todo:
            1] search filename for funcs
            2] search recursive dirs for funcs
            3] search scriptblock for funcs
            4] search nested functions for functions (maybe expand -begin blocks)

    compare / move / merge / delete the funcs in
d
            'Get-FunctionDebugInfo'
            'Get-FunctionInfo2'
            'Get-FunctionInfo3'
            'Get-FunctionInfo4'

    #>
    [alias('Inspect->ScriptFunc')]
    [cmdletbinding()]
    param(
        [parameter()]
        [string]$Filename
    )
    process {
        lsFunc ($filename | Get-Item )
        | ForEach-Object Name | Sort-Object -Unique
    }

    # h1 'functions in script (dynamic path)'
    # lsfunc -Path $PSCommandPath
    # | ForEach-Object Name | Sort-Object -Unique | str csv -SingleQuote

}

if (! $experimentToExport) {
    # ...
}
