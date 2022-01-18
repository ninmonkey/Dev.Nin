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
        todo: #6 and #1

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
        [string]$PathQuery
    )

    begin {

        function _writeDirChange {
            param(
                $Destination
            )
            '{0} -> {1}' -f @(
                Get-Location | ForEach-Object Name
                $Destination.Name
            )
            | Write-Color 'blue'
        }
    }
    process {
        # original logic
        # if only one dir, use it

    }
    end {
        $toplevel = Get-ChildItem . -Directory
        $found_dir = $toplevel | Where-Object { $_.Name -like $PathQuery }
        if ($found_dir.count -eq 1) {
            _writeDirChange -dest $found_dir.Name
            Push-Location $found_dir
            return
        }

        h1 'Matching path[s]'
        $foundDir | To->RelativePath
        return


        # if ($toplevel.count -eq 1) {

        #     Push-Location $toplevel
        # }
        # Push-Location | Select-Object
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
    #Import-Module Dev.Nin -Force
    Push-Location 'G:\2021-github-downloads'
    Get-ChildItem . -dir

    go rust
    $expected = 'G:\2021-github-downloads\Rust\'
    Get-Location | Should -Be 'G:\2021-github-downloads\Rust'
}
