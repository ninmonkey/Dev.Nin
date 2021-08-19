
$Metadata = @(
    @{
        Label = 'Table.AddColumn'
        # Description = 'Search Linux Man Pages'
        # UrlTemplate = 'https://www.mankier.com/1/<<q1>>'
    }
    @{
        Label = 'List.Select'
    }
) | ForEach-Object { [pscustomobject]$_ }

Set-ModuleMetada -key 'FavUrl.PowerQuery' -Value $Metadata
# }
