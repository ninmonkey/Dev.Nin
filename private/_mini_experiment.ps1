function _get_commandMine {
    <#
    .synopsis
        filter Get-Command -module * to mine
    #>
    param(
        # switch
        [Parameter()]
        [switch]$PassThru
    )

    $myModules = @(
        'cat'
        'CvSomething'
        'Dev.Nin'
        # 'JmSomething'
        'Ninmonkey.Console'
        'Ninmonkey.Powershell'
        'Ninmonkey*'
        'Portal.Powershell'
        'PowerShell.Jake'
    )

    if ($PassThru) {
        Get-Command -Module $myModules | Sort-Object Source, Name
        return
    }
    Get-Command -Module $myModules | Sort-Object Source, Name | Format-Wide -GroupBy Source
}