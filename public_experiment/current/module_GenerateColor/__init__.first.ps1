
if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Nancy'
    )
    $experimentToExport.alias += @(
    )
    $experimentToExport.variable += @(
        '__nancy'
    )

}

<#

the "Real" module init is in:
    ../module_GenerateDataColor.ps1

#>
. {
    [hashtable]$script:__nancy = @{
        RootInitPath = Get-Item $PSCommandPath
    }
    $__nancy.AnimationFrames = @{
        BlockSequence        = 0x2586..0x258f | Convert-CharFromCodepoint
        BlockSequenceAndBack = @(0x2586..0x258f) + @(0x258f..0x2586) | Convert-CharFromCodepoint
    }
    $__nancy.Delimiter = @(
        '▸', '⇢', '⁞', '┐', '⇽', '▂'
    )
    $__nancy.Others = '⁞🐛💻▸⇢📄📁⁞ ┐⇽▂🏠🖧'
    $__nancy.CommandCategories = @(
        'DevTool💻'
        'Conversion📏'
        'Style🎨'
        'Format🎨'
        'ArgCompleter🧙‍♂️'
        'NativeApp💻'
        'ExamplesRef📚'
        'TextProcessing📚'
        'Regex🔍'
        'Prompt💻'
        'Cli_Interactive🖐'
        'Experimental🧪'
        'UnderPublic🕵️‍♀️'
        'My🐒 Validation🕵'
    ) | Sort-Object -Unique

}

function Nancy {
    <#
    .synopsis
        Get Semantic Names to Unicode Strings
    #>
    $script:__nancy
}


if (! $experimentToExport) {
    # ...
}
