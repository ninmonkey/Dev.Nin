#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'F'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

function Test-AnyRegexMatch {
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


if (! $experimentToExport) {
    # $ErrorActionPreference = 'stop'

    $samples = 'cat', 'at', 'dog', '34'
    $regex = 'at', '\d+'
    $expect = 'cat', 'at', '34'


    $res = $samples | wheremini -pattern $regex
    $res -join ', '

    $samples | wheremini -pattern $regex
    | Should -Be $expect


    hr
    # wheremini -InputText $samples -pattern $regex -Debug -ea break
    wheremini -InputText $samples[0] -pattern $regex -Debug
    hr
    # ...
}