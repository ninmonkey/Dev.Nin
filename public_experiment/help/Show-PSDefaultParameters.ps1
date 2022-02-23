
function Show-PSDefaultParameterValues {
    <#
    .synopsis
        make it eaiser to read and filter $PSDefaultParameterValues
    .description
        example command to compare the UX of:

            Verbose
            vs Write-Information
            vs Write-Progress
    #>
    [CmdletBinding()]
    param(
        # Search to find which commands are affected
        [switch]$ResolveCommand
    )
    begin {
        $Template = @{
            CommandWithWildcards = '*{0}*'
        }
    }

    end {
        $target = $PSDefaultParameterValues
        $paramValues = $target.GetEnumerator() | ForEach-Object {
            $cmd, $param = $_.Name -split ':'
            $meta = [ordered]@{
                Command = $cmd
                Param   = $param
                Value   = $_.Value
            }
            $meta | Format-HashTable -FormatMode SingleLine | Write-Verbose

            if (! $ResolveCommand) {
                return [pscustomobject]$meta
            }

            if ($Meta.Command -eq '*') {
                $Meta.ResolvedCommand = '@(...all...)'
                return [pscustomobject]$meta
            }

            $QueryString = $Template.CommandWithWildcards -f @($cur.Command)

            "searchingCommands for query: '$QueryString'" | Write-Verbose
            $getCommandSplat = @{
                Name = $QueryString
            }

            $found = Get-Command @getCommandSplat
            $meta.ResolvedCommand = @($found)
            return [pscustomobject]$meta

        }
        | Sort-Object Command, Param, Value

        # if (! $ResolveCommand) {
        #     return $paramValues
        # }


        # $paramValues | ForEach-Object {
        #     $cur = $_
        #     if ($_.Command -eq '*') {
        #         return
        #     }
        # }


    }
}

Show-PSDefaultParameterValues
hr
# Show-PSDefaultParameterValues -Verbose -ResolveCommand
Show-PSDefaultParameterValues -Verbose # -ResolveCommand
Write-Warning @'
NYI:
    - [ ] progress using Write-information
    - [ ] progress using Write-Progress
    - [ ] progress using Write-Verbose
    - [ ] progress using ansi animations /w Write-Progress
'@
