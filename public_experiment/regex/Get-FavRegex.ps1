


if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Get-SavedRegex'
    )
    $experimentToExport.alias += @(
        'regex->Saved' # 'Get-SavedRegex'
        'savedRegex' # 'Get-SavedRegex'
    )
}
# }

function Get-SavedRegex {
    <#
    .synopsis
        minimal quick saved list
    #>
    [Alias('regex->Saved', 'savedRegex')]
    [cmdletbinding()]
    param(

        # First parameter to the regex
        [Alias('Var1')]
        [Parameter()]
        [string]$Variable1
    )
    begin {
        $SavedHardcoded = @(
            @{
                'Name'        = 'Find-JsonSettingSkipCommented'
                'Description' = '...stuff'
                'Tags'        = @('Json', 'Config')                # 'Variables' = @{
                #     'Pattern' = [regex]::escape(  )
                # }
                'Web'         = 'https://regex101.com/r/S6R8l9/1'
                'Pattern'     = @'
(?x)
(?<!\/\/\s*)
(?<QueryStr>
{{var1}}              # ex: \"editor\.quickSuggestions\"
)
'@
            }
        )

    }
    process {
        $selectedRegex = $SavedHardcoded
        | Where-Object Name -EQ 'Find-JsonSettingSkipCommented'
        #| % Pattern
        $selectedRegex | Format-Table -auto | Out-String
        | Join-String -op 'Selected: ' | Write-Debug

    }
    end {
        $Variable1 ??= $selectedRegex['Var1Default']
        $regexVar1 = [regex]::Escape('{{var1}}')
        $FinalText = $selectedRegex['Pattern'] -replace $regexVar1, $Variable1
        return $FinalText
    }
}
