

<#
gh gist view [<id> | <url>] [flags]
  --filename : intside gist
  --files : listing
  --raw : raw
 -- web : open browser
#>
function _parse_gistList {
    <#
    .synopsis
        splits gitub result to structured record
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



$myGistRaw ??= gh gist list --limit 100
$MyGist = $myGistRaw | ForEach-Object {
    _parse_gistList $_
}

$myGistRaw.count, $myGist.count | Join-String -Separator ', ' | Label 'Counts'
# $myGistRaw, $myGist | ForEach-Object count | Label 'Count'
# $myGistRaw, $myGist | ForEach-Object count | Join-String -sep ', ' -op 'count: '