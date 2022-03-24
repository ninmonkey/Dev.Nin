#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_new-ESearchFilter_byFiletype' # '_new-ESearchFilter_byFiletype'
        '_getRipgrepDefinedTypelist'
    )
    $experimentToExport.alias += @(
        'es->NewFiletypeFilter' # '_new-ESearchFilter_byFiletype'
        'es->ImportRgFiletype' # '_getRipgrepDefinedTypelist'

    )
}


function _getRipgrepDefinedTypelist {
    <#
    .Synopsis
        import type lists from RipGrep
    .example
        PS> _getRipgrepDefinedTypelist -ListLanguages
    .example
        PS> _getRipgrepDefinedTypelist | Fl
    #>
    # to auto split, to use for terms later
    [Alias('es->ImportRgFiletype')]
    [CmdletBinding()]
    param(
        # show languages instead, maybe for autocompletions
        [switch]$ListLanguages
    )
    end {
        $regexLang = '^(?<Lang>.*?):(?<Glob>.*)$'
        $stdout = & 'rg' @('--type-list')

        $query = $stdout | ForEach-Object {
            $line = $_
            if ($line -notmatch $regexLang) {
                Write-Error -Message ("RexexMatchFailed: '$($line)' match $($regexLang)' failed")
                return
            }
            $meta = @{
                Lang = $Matches.Lang
                Glob = $Matches.Glob
            }
            try {
                $maybePattern = $meta.Glob | _new-ESearchFilter_byFiletype -ea stop
            } catch {
                Write-Error -Message "Something failed parsing glob: $($meta.Glob)"
                $maybePattern = $Null
            }
            $meta['MaybePattern'] = $maybePattern
            [pscustomobject]$meta
        }

        if ($ListLanguages) {
            return $query.lang | Sort-Object -Unique
        }

        return $query
    }

}

<#
naming?
    Build-ESearchQueryFilterString
    _new-ESearchFilter_byFiletype.ps1
    createFilter_fileExtensionGroup.ps1
#>
function _new-ESearchFilter_byFiletype {
    <#
    .synopsis
        take type lists, like : ripgrep --type-list
    .description
       .
    .example
          .
          PS> '*.cdxml, *.ps1, *.ps1xml, *.psd1, *.psm1'
          | _new_ESearchFilter_byFiletype

        # output

            '( ext:cdxml;ps1;ps1xml;psd1;psm1 )'

    .outputs
          [string]

    #>
    [Alias(

        '_newEsQueryTerm_filetype',
        'es->NewFiletypeFilter',
        'createFilter_fileExtensionGroup.ps1'
    )]
    [CmdletBinding()]
    param(
        [Alias('FiletypeList')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$InputObject
    )

    begin {
    }
    process {

        $parsedTerms = $InputObject -replace '\*\.' -replace '^\s*', '' -split ',\s+'
        $filterString = $parsedTerms | Sort-Object -Unique
        | Join-String -op '( ext:' -os ' )' -sep ';'
        # split terms
        $dbg = [ordered]@{
            '1: init'         = $InputObject
            '2: terms'        = $parsedTerms
            '3: filterString' = $filterString
        }
        $dbg | Format-Dict | Write-Information

        $filterString
    }
    end {
    }
}
