
if ( $experimentToExport ) {
    $experimentToExport.function += @(
        # 'Get-WhatObjectType' ?
        'Where-MatchAnyRegex'
    )
    $experimentToExport.alias += @(        
        '?RegexAny',
        '?RegexAny🔍'        
    )
}
# }
    
function Where-MatchAnyRegex {
    <#
    .synopsis
        When you want to filter for any match, and you don't care which matched
    #>


    [Alias('?RegexAny', '?RegexAny🔍')]
    [cmdletbinding()]
    param(

        # Regex
        [Alias('Regex')]
        [Parameter(Mandatory, Position = 0)]
        [string[]]$Pattern,

        # sample text
        [Alias('Text')]
        [Parameter(Mandatory, Position = 1, ValueFromPipeline)]
        [string]$InputText

        # todo: [Parameter(Mandatory, ParameterSetName='ByProperty', Position = 0)]
        # search property of an object instead of text
        # [string]$Property,
    )
    process {
        $AnyMatches = $false
        Write-Debug "Evaluate: '$InputText' -match '$curRegex'"
        foreach ($curRegex in $Pattern) {
            if ($InputText -match $curRegex) {
                Write-Debug "First match: '$InputText' matches '$curRegex'"
                $AnyMatches = $true
                break
            }
        }
        if ($AnyMatches) {
            $InputText
        }
    }
}
if ( ! $experimentToExport ) {
}