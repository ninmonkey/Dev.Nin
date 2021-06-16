
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
    param (
        
    )
    begin {        
        $PropertyColorList = Get-PSReadLineOption | prop | % Name | ? { $_ -match 'color' } | sort -Unique
    }
    process {
        $ThemeSettings = $PropertyColorList | % { 
            $ColorName = $_
            $ColorValue = (Get-PSReadLineOption).$ColorName
            [pscustomobject]@{
                'Name' = $ColorName 
                'Value' = $ColorValue
            }
        }
        $ThemeSettings
        | ConvertTo-Json -depth 3
    }
    end {}
}

Dev-ExportPSReadlineTheme