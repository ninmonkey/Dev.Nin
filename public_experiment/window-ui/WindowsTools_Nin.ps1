#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Window_BringToFront'
        'Window_ExportOpenFolders'
    )
    $experimentToExport.alias += @(
        'Window->ToFront'
        'Window->ExportFolders'
        # 'A'
    )
}

function Window_ExportOpenFolders {
    <#
    .SYNOPSIS
        print all open filepaths
    #>
    [Alias('Window->ExportFolders')]
    [cmdletbinding()]
    param(

    )

    Window->Get | ForEach-Object Title | Where-Object { Test-Path $_ } | Sort -Unique
}

function Window_BringToFront {
    <#
    .synopsis
        bring window to the front of the stack
    .notes
        there is a better method, but this worked good enough for now
    .link
        Dev.Nin\Close-OpenWindow
    .link
        Dev.Nin\Get-OpenWindow
    .link
        Dev.Nin\Get-WindowPosition
    .link
        Dev.Nin\Maximize-OpenWindow
    .link
        Dev.Nin\Minimize-OpenWindow
    .link
        Dev.Nin\Restore-OpenWindow
    .link
        Dev.Nin\Set-WindowPosition
    #>
    [Alias('Window->ToFront')]
    [CmdletBinding()]
    param(
        # window tite name, always tries partial wildcards
        [Alias('Name')]
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [string[]]$TitleName,

        # strict: only when a single window is matching
        [Parameter()]
        [switch]$OneOrNone
    )
    end {
        # $TitleName ??= '*'
        # $TitleName = '*', $TitleName, '*' -join ''
        $TitleName = $TitleName | ForEach-Object {
            $_ | Join-String -op '*' -os '*'
        }

        $query = $TitleName | Get-OpenWindow #-Name $TitleName

        $query | str csv -DoubleQuote | str prefix 'query: ' | Write-Information

        #strict?
        if ($query.count -ne 1 -and ($OneOrNone)) {
            Write-Error '-OneOrNone: Failed'
            return
        }

        if ($false) {

            if ($query.count -eq 1 -and ($OneOrNone)) {
                $FinalTarget = $query
            }
            else {
                Write-Verbose 'query: OneOrNone: false'
                $FinalTarget = $query.Title | Sort-Object -Unique | fzf -m
            }
        }

        $FinalTarget | ForEach-Object {
            $cur = $_
            # try parallel
            $cur | Minimize-Window #-ea break
            Start-Sleep 0.2
            $cur | Restore-Window #-ea break
        }
    }
}


if (! $experimentToExport) {
    # ...
}
