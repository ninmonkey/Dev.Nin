if ($false) {

    function TraceFilter {
        param(
            # ScriptBlock
            [Parameter(Mandatory, Position = 0)]
            [ScriptBlock]$SB
        )

        $tc = { Trace-Command -Name ParameterBinding -PSHost -Verbose -Expression $SB }
        $regex = @{ 'trace' = '^.*tion: 0 :' }

        $runspace = [PowerShell]::Create([InitialSessionState]::CreateDefault2())
        $stdOut = $runspace.AddScript( $tc ).Invoke()
        $raw = $runspace.Streams.Debug | ForEach-Object {
            $_ -replace $regex.trace, ''
        }
        $raw
    }

    $TraceScript = {
        # Trace-Command -Name ParameterBinding -PSHost -Verbose -Expression { $null | Join-String -sep ', ' }
        { $null | Join-String -sep ', ' }
    }
    hr '1'
    TraceFilter { $null | Join-String -sep ', ' }
    hr '2'



    if ($false) {

        function Format-DevTraceCommand {
            <#
    .synopsis
        make Trace-Command readable
    .example
        Format-TraceCommand { Get-ChildItem . | Select-Object -First 1 }
    #>
            param(
                # ScriptBlock to test
                [Parameter(Mandatory, Position = 0)]
                [ScriptBlock]$ScriptBlock,

                # Skip colorizing
                [Parameter()][switch]$NoColor
            )
            begin {
                $Regex = @{ 'trace' = '^.*tion: 0 :' }
            }

            process {
                # Trace-Command -Name ParameterBinding -PSHost -Verbose -Expression { & $ScriptBlock | Out-Null }
                Trace-Command -Name ParameterBinding -PSHost -Verbose -Expression $ScriptBlock

                # Trace-Command -Name ParameterBinding -PSHost -Verbose -Expression { Get-ChildItem . | Select-Object -First 1 }

                $runspace = [PowerShell]::Create([InitialSessionState]::CreateDefault2())
                $stdOut = $runspace.AddScript( $ScriptBlock ).Invoke()
                # $runspace.Streams.Debug | Join-String -sep "`n" | ForEach-Object {
                $runspace.Streams.Debug | ForEach-Object {
                    $_ -replace $Regex.trace, ''
                }
            }
        }

        Format-DevTraceCommand { Get-ChildItem . | Select-Object -First 1 }

        hr
        Trace-Command -Name ParameterBinding -PSHost -Verbose -Expression { Get-ChildItem . | Select-Object -First 1 | Out-Null }
    }
}