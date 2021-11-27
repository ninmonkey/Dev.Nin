#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Get-NinStartAppId'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

function Get-NinStartAppId {
    <#
    .example
        🐒> Get-NinStartAppId
        Xbox Game Bar: Microsoft.XboxGamingOverlay_8wekyb3d8bbwe!App
        DAX Studio: {6D809377-6AF0-444B-8957-A3773F02200E}\DAX Studio\DaxStudio.exe
    #>
    param()
    $selected = Get-StartApps -ov 'start' | Sort-Object Name | ForEach-Object {
        $_.AppId | Label $_.Name
    } | fzf -MultiSelect
    $selected
}


if (! $experimentToExport) {
    # ...
}