#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Format-NormalizeText'
        'Compare-NormalizedText'
    )
    $experimentToExport.alias += @(
        # ''
    )
}

function Format-NormalizeText {
    <#
    .synopsis
        normalizes line endings to "`n"
    #>
    param(
        [Alias('Text')]
        [Parameter(Mandatory, Position = 0)]
        $InputText
    )

    process {
        $InputText -split '\r?\n' -join "`n"
    }
}

function Compare-NormalizedText {
    <#
    .synopsis
        normalize line endings, then compare. **very slow**
    .description
        not 100% working,
        quick hack not to be use for long strings
    #>
    param(
        # First Sample
        [Parameter(Mandatory, Position = 0)]
        [Alias('TextA')]
        [string]$InputText1,

        # First Sample
        [Parameter(Mandatory, Position = 1)]
        [Alias('TextB')]
        [string]$InputText2
    )

    $Left = Format-NormalizeText $InputText1
    $Right = Format-NormalizeText $InputText2

    return ($Left -eq $Right)
}

if (! $experimentToExport) {
    # ...
}
