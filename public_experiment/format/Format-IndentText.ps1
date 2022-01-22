#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Format-IndentText'
        'Format-UnindentText'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

# $experimentFuncMetadata += @{
#     # metadataRecord
#     Command = 'Format-IndentText'
#     Tags    = 'TextProcessing📚', 'Style🎨' # todo: build, from function docstrings
# }
function Format-UnindentText {
    <#
    .synopsis
         remove prefix depth of X
    .notes
        Future impl, should be a smart alias to Dev.Nin\Format-IndentText ?
    .LINK
        Dev.Nin\Format-IndentText

    #>
    [cmdletbinding()]
    param(
        # text to modify
        [Parameter(Mandatory)]
        [string[]]$InputText,

        # takes absolute value of
        [Parameter(Mandatory)]
        [int]$Depth)

    $Depth = [math]::Abs( $depth )

    $replaceRegex = '^\ {{{0}}}' -f @(4 * $Depth)
    Write-Debug $replaceRegex

    $InputText -join "`n" -split '\r?\n' -replace $replaceRegex, ''

}

function Format-IndentText {
    <#
    .synopsis
        indent all text by X levels. Predent? Indent?
    .description
        compare/merge with:
            C:\Users\cppmo_000\SkyDrive\Documents\2021\powershell\My_Github\Ninmonkey.Console\public\Format-Predent.ps1
    .notes
        tags: TextProcessing📚, 'Style🎨'
    .example

    .LINK
        Ninmonkey.Console\Format-Predent
    .LINK
        Dev.Nin\Format-UnindentText
    #>
    # [Alias('Format-PredentText')]
    [outputType('[System.String[]]', 'System.String')]
    [cmdletbinding(PositionalBinding = $false)]
    param(
        # Level
        [Alias('IndentLevel', 'Level')]
        [Parameter(Position = 0 )]
        [int]$Depth = 1,

        [Alias('Line')]
        [AllowEmptyString()]
        [AllowNull()]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Text,

        # For non-default indentation
        # todo: requires completions attribute (even if it's still static)
        # using
        #       label = 'LiteralTab' ; value = "`n"
        #       label = '4Space' ; value = "    "
        [Parameter()]
        # [ArgumentCompletions('  ', '    ', "`t")]
        [string]$IndentString = '    '
    )
    begin {
        $predentStr = $IndentString * $Depth
    }

    process {
        if ($Depth -lt 0) {
            Format-UnindentText -InputText $Text -Depth
            return
        }
        if ($Depth -eq 0) {
            $Text
            return
        }
        $predentSplat = @{
            OutputPrefix = $predentStr
            Separator    = "`n$predentStr"
            Property     = { $_ }
        }

        $Text
        | ForEach-Object { $_ -split '\r?\n' } # not needed? maybe it will be on newline embedded strings?
        | Join-String @predentSplat
    }

}


if (! $experimentToExport) {
    # ...
}
