$experimentToExport.function += 'Find-BadlyNamedCommand'
# $experimentToExport.alias += 'RegexEitherOrder'

function Find-BadlyNamedCommand {
    <#
    .synopsis
        find non-official commands
    .description
        .
    .example
        #Find conflicts

        (Get-Command * -All -ListImported) | Group Name | ?  count -gt 1

    .notes
        .
    #>
    param (
        # Docstring
        [Parameter()][switch]$OnlyImported,

        # Hide conflicts?

        [Parameter()][switch]$IgnoreConflict
    )
    begin {
        $getCommandSplat = @{
            ListImported = ! $OnlyImported
            All          = ! $IgnoreConflict
        }

        $GcmQuery = Get-Command @getCommandSplat
        $BadList = [list[object]]::new()
    }
    process {
        $GcmQuery | Where-Object {
            $cur = $_
            # any test is true
            $test_PrefixUnder = $Cur.Name -match '^_'

            @(
                $true -eq @(
                    $PrefixUnder
                )
            ).count -gt 0

        } | ForEach-Object {
            $BadList.Add( )
        }

    }
    end {

        $BadList
    }
}


function Get-DownloadFromGit {

}
