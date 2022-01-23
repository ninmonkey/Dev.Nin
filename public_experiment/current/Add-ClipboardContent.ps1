#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Add-ClipboardContent'
    )
    $experimentToExport.alias += @(
        'clAdd'
    )
}

function Add-ClipboardContent {
    <#
    .synopsis
        append clipboard instead of replace
    .description
        appends /w newline. full replacement not finished
    #>
    [Alias('clAdd')]
    [CmdletBinding()]
    param(
        # InputObject/pipe
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject,

        # Separator
        [Parameter(Position = 0)]
        [ArgumentCompletions('Newline', 'Csv')]
        [string]$Separator

    )
    begin {
        $namedDelim = @{
            Newline = "`n"
            Csv     = ','
        }
        $selectedName = $Separator ?? 'Newline'
        $finalDelim = ($namedDelim)?[ $NamedDelim ] ?? "`n"
    }
    process {

        Get-Clipboard | Write-Debug
        @(
            (Get-Clipboard)
            $InputObject
        ) | Join-String -Separator $FinalDelim | Set-Clipboard

        Get-Clipboard | Write-Debug

    }
}

if (! $experimentToExport) {
    # ...
}
