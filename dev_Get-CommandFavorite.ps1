function Get-FavCommand {
    <#
    .synopsis
        returns metadata on native/fav/common paths that 'get-command' may not find by default
    .notes
        future:
        - [ ] Json config? Or return PSCO verses hash ?
        - [ ] some queries should wildcard directories first, then files, like '~/*code*/**/foo' ?

    .example
        PS> Get-FavCommand
        # output

        # see also:
        Get-Command -CommandType Application
    #>
    [OutputType([System.Collections.Hashtable])]
    [CmdletBinding()]
    param(
        # filter
        [Alias('Type')]
        [Parameter(Position = 0)]
        [System.Management.Automation.CommandTypes]$CommandType
    )

    $commandList = @{

    }
    <#
    sample:
        C:\Program Files\Firefox Developer Edition\firefox.exe
        C:\Program Files\Mozilla Firefox\firefox.exe
    #>
    $PossibleSources = Get-ChildItem env: | Where-Object Value -Match ([regex]::Escape(':\Program Files\'))
    $PossibleSources | Join-String -sep "`n" -op "`nPossibleSources" | Write-Verbose

    $commandList['Firefox'] = Get-ChildItem "$env:ProgramFiles" -ea Continue -File -Filter 'firefox.exe' -Depth 1


    <# rfi: which var iss better?
    # "$Env:CommonProgramFiles"
    # "$Env:CommonProgramFilesW6432"

    #>
    $commandList['Git-Bash'] = @(
        # Get-ChildItem "$Env:CommonProgramFiles\git" -ea Continue -File -Filter 'git.exe' -Depth 1
        Get-ChildItem "$Env:ProgramFiles\git" -ea Continue -File -Filter 'git.exe' -Depth 1
        Get-ChildItem "$Env:ProgramFiles\git\usr\bin" -ea Continue -File -Depth 1 '*.exe'
    )

    $commandList['Chocolatey'] = Get-ChildItem $Env:ChocolateyInstall\bin | Where-Object { $_.Extension -match '\.(exe|cmd|sh)$' } | Sort-Object FullName

    # see others: -Path $env:ALLUSERSPROFILE, $Env:ChocolateyInstall, $Env:ProgramData


    # [pscustomobject]$commandList

    $commandList
    return

}


if ($false) {
    # Get-FavCommand -ov

    Get-ChildItem "$env:ProgramFiles" -ea stop -File -Filter 'firefox.exe' -Depth 1
    Hr
    H1 'last block'
    if ($true) {
        $PossibleSources = Get-ChildItem env: | Where-Object Value -Match ([regex]::Escape(':\Program Files\'))
        $PossibleSources | Join-String -sep "`n" -op (H1 'PossibleSources' -After 1 | Join-String -Separator '') | Join-String -sep '' -os "`n" {
            ($_.Key).padright(30), '=', ($_.Value[0..40] -join '') | Join-String -sep ' '
        }
    }
}