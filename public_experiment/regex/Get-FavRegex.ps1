


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
    param()
    begin {
        $SavedHardcoded = @(
            @{
                'Name'        = 'Find-JsonSettingSkipCommented'
                'Description' = '...stuff'
                'Tags'        = @('Json', 'Config')
                'Web'         = 'https://regex101.com/r/S6R8l9/1'
                'Pattern'     = @'
(?x)
(?<!\/\/\s*)
(?<QueryStr>
\"editor\.quickSuggestions\"
)
'@
            }
        )

    }
    process {
    }
    end {
        return $SavedHardcoded
    }
}
