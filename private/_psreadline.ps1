
function Dev-ExportPSReadlineTheme {
    <#
    .synopsis
        export all colors, so future values will be fetched too
    .description
        .
    .example
        PS>
    .notes
        .
    #>
    param ()
    $PropertyColorList = Get-PSReadLineOption | prop | ForEach-Object Name | Where-Object { $_ -match 'color' } | Sort-Object -Unique
    $ThemeSettings = $PropertyColorList | ForEach-Object {
        $ColorName = $_
        $ColorValue = (Get-PSReadLineOption).$ColorName
        [pscustomobject]@{
            'Name'  = $ColorName
            'Value' = $ColorValue
        }
    }
    $ThemeSettings
    | ConvertTo-Json -Depth 3
}

# Dev-ExportPSReadlineTheme
