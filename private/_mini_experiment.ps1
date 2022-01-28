
function Get-MyCommand {
    <#
    .synopsis
        mostly sugar for: "gcm -m (_enumerateMyModule) *"
    .description
        filter Get-Command -module * to mine
    .link
        Ninmonkey.Console\_enumerateMyModule
    #>
    [Alias('gcmMy')]
    param(
        # switch
        [Parameter()]
        [switch]$PassThru,

        # regex-style command filter
        [Alias('Regex')]
        [Parameter(Position = 0, ValueFromPipeline)]
        [switch]$CommandPattern
    )

    # todo: enhance: cached _enumerateMyModules

    $myModules = @(
        'Dev.Nin'
        # 'JmSomething'
        'Ninmonkey\.Console'
        'Ninmonkey\.Profile'
        'Ninmonkey\.Powershell'
        'Ninmonkey.*'
        'Portal\.Powershell'
        'PowerShell\.Jake'
    ) | Sort-Object -Unique

    $results = Get-Command -Module $myModules
    | Sort-Object Source, Name
    | Where-Object {
        $_.Name -match $CommandPattern
    }
    | Sort-Object Source, Name

    if ($PassThru) {
        return $results
    }

    $Results | Format-Wide -GroupBy Source
}
