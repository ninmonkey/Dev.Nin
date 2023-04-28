

<#
gh gist view [<id> | <url>] [flags]
  --filename : intside gist
  --files : listing
  --raw : raw
 -- web : open browser
#>
function ConvertFrom-GistList {
    <#
    .synopsis
        splits gitub result to structured record
    .description
        todo verify it runs on piped
    .example
        PS>
            $myGistRaw = gh gist list --limit 100
            $myGistRaw | ForEach-Object {
                _parse_gistList $_
            }
    #>
    param(
        # Text Line
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$TextLine
    )
    # I have a regex already somewhere, just quick hack to go
    $parts = ($_ -split '\t')
    [pscustomobject]@{
        Id        = $parts[0]
        Desc      = $parts[1]
        FileCount = $parts[2]
        Visible   = $parts[3]
        Date      = [datetime]$parts[4]
    }
}



# $myGistRaw ??= gh gist list --limit 100
# $MyGist = $myGistRaw | ForEach-Object {
#     ConvertFrom-GistList $_
# }

# $myGistRaw.count, $myGist.count | Join-String -Separator ', ' | Label 'Counts'
# $myGistRaw, $myGist | ForEach-Object count | Label 'Count'
# $myGistRaw, $myGist | ForEach-Object count | Join-String -sep ', ' -op 'count: '
