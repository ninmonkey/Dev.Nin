$experimentToExport.function += 'Format-UniqueStringList'
$experimentToExport.alias += 'strDistinct'

function Format-UniqueStringList {
    <#
    .synopsis
        reads clipboard, distinct sort, writes to clipboard
    .description
        When you have a list of text, you need to make sure it's sorted and distinct
    .example
        PS>

        copyh:
        Format-UniqueStringList
    .notes
        .
    #>
    [Alias('StrDistinct')]
    [CmdletBinding(PositionalBinding = $false)]
    # DefaultParameterSetName='Source_Clipboard')]
    param (
        # PassThru: Writes to console instead
        [Parameter()][switch]$PassThru
    )
    process {
        $InputLines = (Get-Clipboard) -split '\r?\n'
        $distinctList = $InputLines | Sort-Object -Unique
        Write-Debug "Input: $($InputLines.count) lines"
        Write-Debug "Output: $($distinctList.count) lines"

        if ($PassThru) {
            $distinctList | Join-String "`n"
            return
        }
        Write-Information 'Wrote to Clipboard'
        Write-Information '🐱'
        $distinctList | Join-String -sep "`n" | Set-Clipboard
    }
}
