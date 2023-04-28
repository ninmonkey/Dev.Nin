#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Copy-SelectHistoryCommand'
    )
    $experimentToExport.alias += @(
        'Copy->HistoryCmd'
    )
}

@(
    '- Copy->HistoryCmd' | write-color -fg yellow -bg 'darkred'
    | Join-String -op 'Todo: '
) | Write-Warning

function Copy-SelectHistoryCommand {
    <#
    .synopsis
        find and preview history, then copy command
    .description
        previews commands before you actually copy it
    .notes
        original based on <PSScriptTools\Copy-HistoryCommand>n

        future:
            is it possible using newlines, to insert newlines, for mult-line suggestions?
            It could be interesting to see commands before highlighting

            cmd foo
                ls . | sort LastDateTime
    .link
        PSScriptTools\Copy-HistoryCommand
    #>
    [ALias('Copy->HistoryCmd')]
    [CmdletBinding()]
    param (

    )

    begin {

    }

    process {

    }

    end {

    }
}

if (! $experimentToExport) {
    # ...

}
