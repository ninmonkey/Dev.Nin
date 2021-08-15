& {
    $Metadata = @(
        @{
            Label       = 'man'
            Description = 'Search Linux Man Pages'
            UrlTemplate = 'https://www.mankier.com/1/<<q1>>'
        }
        @{
            Label        = 'PowerQuery'
            Description  = 'Docs by Function name'
            UrlTemplate  = 'https://docs.microsoft.com/en-us/powerquery-m/<<q1>>'
            FormatScript = {
                param($rawText)
                $rawText -replace '\.', '-'
            }
        }
    ) | ForEach-Object { [pscustomobject]$_ }

    _Set-ModuleMetada -key 'FavUrl.Top' -Value $Metadata
}
