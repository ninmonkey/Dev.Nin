
$experimentToExport.function += @(
    '_Regex-ProcessNamedGroups'
)
$experimentToExport.alias += @(        
)

    
    
function _Regex-ProcessNamedGroups {
    <#
    .synopsis
        returns objects with named groups
    .description
        from: <https://gist.github.com/IISResetMe/654b302383a687bd92faa8c8c3ab28fa>
    .notes
        because it's dtnet, checkout the regex flag (?n) to only capture named groups

    #>
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [AllowEmptyString()]
        [string[]]$InputString,
  
        [Parameter(Mandatory = $true, ValueFromRemainingArguments = $true)]
        [string[]]$Pattern
    )
  
    process {
        foreach ($string in $InputString | Where-Object { $_ }) {
            foreach ($p in $Pattern) {
                if ($string -match $p) {
                    if ($PropertyNames = $Matches.Keys | Where-Object { $_ -is [string] }) {
                        $Properties = $PropertyNames | ForEach-Object -Begin { $t = @{} } -Process { $t[$_] = $Matches[$_] } -End { $t }
                        [PSCustomObject]$Properties
                    }
                    break
                }
            }
        }
    }
}