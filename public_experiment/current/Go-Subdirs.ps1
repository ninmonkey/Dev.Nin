#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Dive-SubDirectory'
    )
    $experimentToExport.alias += @(
        'Go'
        'Dive->Directory'
    )
}

function Dive-SubDirectory {
    <#
    .synopsis
        Stuff
    .description
        - [ ] todo

        special tab-complete syntax that's sugar for

            go data<tab>

        is sugar for

            go *data*<menuComplete>

        while not 1 match
            curPrefix += <substr from tab2>
            if curPrefix | one-or-none:
                then goto curPrefix
            else
                loop

    .notes
        related https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/register-argumentcompleter?view=powershell-7.3#example-3--register-a-custom-native-argument-completer

    #>
    [Alias('Go', 'Dive->Directory')]
    [CmdletBinding()]
    param(
        [parameter(Mandatory , Position = 0, ValueFromRemainingArguments, ValueFromPipeline)]
        [string]$Query
    )

    begin {
        Write-Warning 'still WIP'
        function _writeDirChange {
            param(
                $Destination
            )
            '{0} -> {1}' -f @(
                Get-Location | ForEach-Object Name
                $Destination.Name
            )
            | write-color 'blue'
        }
    }
    process {
        # original logic
        # if only one dir, use it
        $toplevel = Get-ChildItem . -Directory
        if ($toplevel.count -eq 1) {

            Push-Location $toplevel
        }
        Push-Location | Select-Object
    }
    end {
        <#
    # original:
    if ($toplevel.count -eq 1) {
        '{0} -> {1}' -f @(
            Get-Location | ForEach-Object Name
            $toplevel.Name
        )
        | write-color 'blue'

        Push-Location $toplevel
    }
    Push-Location | Select-Object
    #>
    }
}

if (! $experimentToExport) {
    # ...
}
