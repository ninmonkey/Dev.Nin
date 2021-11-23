$experimentToExport.function += @(
    'Format-IndentText'
)
$experimentToExport.alias += @(
    'Format-PredentIndent'
    # 'Format-Predent'
)
# $experimentFuncMetadata += @{
#     # metadataRecord
#     Command = 'Format-IndentText'
#     Tags    = 'TextProcessing📚', 'Style🎨' # todo: build, from function docstrings
# }

function Format-IndentText { 
    <#
    .synopsis
        indent all text by X levels. Predent? Indent?
    .description
        compare/merge with: 
            C:\Users\cppmo_000\SkyDrive\Documents\2021\powershell\My_Github\Ninmonkey.Console\public\Format-Predent.ps1
    .notes
        tags: TextProcessing📚, 'Style🎨'
    #>
    [Alias('Format-PredentText')]
    [cmdletbinding(PositionalBinding = $false)]
    param(
        # Level
        [Alias('IndentLevel', 'Level')]
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [int]$Depth,

        [Alias('Line')]
        [AllowEmptyString()]
        [AllowNull()]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Text,

        # For non-default indentation
        [Parameter()]
        [string]$IndentString = '  '
    )
    begin {
        $predentStr = $IndentString * $Depth
    }

    process {
        if ($Depth -le 0) {
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