#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'String-NinReplace'
    )
    $experimentToExport.alias += @(
        'StrReplace'
        '-Replace'
    )
}

function String-NinReplace {
    <#
    .synopsis
        sugar for "$x | %{ $_ -replace $regex, $replacement }"
    .description
       .
    .example
          .
    .outputs
          [string
    .link
        Irregular
    .link
        Dev.Nin\Match-String
    .link
        Dev.Nin\Split-String
    .link
        Dev.Nin\Where-MatchAnyText
    .link
        Ninmonkey.Console\ConvertFrom-NumberedFilepath

    #>
    [Alias(
        'StrReplace'
        # '-replace' # tab complete do;esn't initialize on prefix '-'
    )]
    [CmdletBinding()]
    param(
        # source text
        [parameter(Mandatory, ValueFromPipeline)]
        [string]$InputText,

        # regex pattern
        [Alias('Pattern')]
        [AllowEmptyString()]
        [Parameter(
            ParameterSetName = 'BasicRegex',
            Mandatory, Position = 0
        )]
        [string]$RegexPattern,

        # replacement pattern
        [parameter(
            ParameterSetName = 'BasicRegex',
            Position = 1)]
        [AllowEmptyString()]
        [string]$SubstitutionString = [string]::Empty,

        # keeping the parameter set[s] undeclared for now, to simplify code
        [Alias('Template')]
        [parameter(Mandatory, ParameterSetName = 'ReplaceTemplate')]
        [ValidateSet(
            # [ArgumentCompletions(
            'Markdown_Underscore', 'Markdown_InvertUnderscore',
            'Markdown_EscapeSpace', 'Markdown_InvertEscapeSpace'
        )]
        [AllowEmptyString()]
        [string]$ReplacementMode#  = [string]::Empty

    )

    # future: generate dynamically, using hashtable or yml/json config files
    begin {
        # default config
        switch ($PSCmdlet.ParameterSetName) {
            'BasicRegex' {
                break
            }
            'ReplaceTemplate' {
                switch ($ReplacementMode) {
                    'Markdown_Underscore' {
                        $RegexPattern = '\s'
                        $SubstitutionString = '_'
                        break
                    }
                    'Markdown_InvertUnderscore' {
                        $RegexPattern = '_'
                        $SubstitutionString = ' '
                        break
                    }

                    'Markdown_EscapeSpace' {
                        $RegexPattern = '\s'
                        $SubstitutionString = '%20'
                        break
                    }
                    'Markdown_InvertEscapeSpace' {
                        $RegexPattern = [regex]::escape( '%20' )
                        $SubstitutionString = ' '
                        break
                    }
                    default {
                        # throw "Unhandled template: $($ReplacementMode)"
                    }

                }
                # break # was this bad?
            }
            default {
                throw "Unhandled ParameterSet: $($PSCmdlet.ParameterSetName)"
            }
        }

        Label 'regex' $RegexPattern | Write-Debug
        Label 'substitute' $SubstitutionString | Write-Debug
    }
    process {
        @{
            Regex      = $RegexPattern
            Substitute = $SubstitutionString
        } | Out-Default | Write-Debug
        switch ($PSCmdlet.ParameterSetName) {
            'BasicRegex' {
                $InputText | ForEach-Object { $_ -replace $RegexPattern, $SubstitutionString }
            }
            'ReplaceTemplate' {
                $InputText | ForEach-Object { $_ -replace $RegexPattern, $SubstitutionString }
            }
            default {
                throw "Unhandled ParameterSet: $($PSCmdlet.ParameterSetName)"
            }
        }
    }
    end {
    }
}

if (! $experimentToExport) {
    # ...
}
