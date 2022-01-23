
if ( $experimentToExport ) {
    $experimentToExport.function += @(
        # 'Get-WhatObjectType' ?
        'Where-MatchAnyText'
    )
    $experimentToExport.alias += @(
        # '?RegexAnyStr',
        '?MatchAnyStr'
    )
}
# }

function Where-MatchAnyText {
    <#
    .synopsis
        When you want to filter for any match, and you don't care which matched
    .notes
        the "right" name might be 'Test-MatchAnyText'
    #>
    [Alias(
        # '?RegexAnyStr', '?RegexAny🔍', '?StrAny',
        # '?RegexAnyStr'
        '?MatchAnyStr'
    )]
    [cmdletbinding()]
    param(

        # Regex
        [Alias('Regex')]
        [Parameter(Mandatory, Position = 0)]
        [string[]]$Pattern,

        # sample text
        # future: todo: make InputText an array
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
if (! $experimentToExport) {

}
