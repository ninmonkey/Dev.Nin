# & {
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
            # doesn't actually execute. it was an idea for later
            $rawText -replace '\.', '-'
        }
    }
    @{
        Label       = 'FileInfo'
        Description = 'Lookup Filetypes by program name'
        UrlTemplate = 'https://fileinfo.com/extension/<<q1>>'
        Tags        = 'Dicta', 'Files'
    }
    @{
        Label       = 'Define'
        Description = 'Lookup dictionary definitions'
        UrlTemplate = 'https://www.wolframalpha.com/input/?i=word+<<q1>>'
        Tags        = 'Wolfram', 'Language'
    }
) | ForEach-Object { [pscustomobject]$_ }

Set-ModuleMetada -key 'FavUrl.Top' -Value $Metadata
# }
