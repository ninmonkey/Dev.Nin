
function Capture-DebugStream {
    <#
    from the shell even if you redirect debug or even *>&1
        it will never see the debug stream
        running it like this lets you read it
    #>
    $TraceScript = {
        Trace-Command -Name ParameterBinding -PSHost -Verbose -Expression {
            if ($true) {
                # test that the debug stream is the only one captured
                Label 'lb: hi world' | Write-Debug
                Label 'lb: not debug'
            }
            $null | Join-String -sep ', '
        }
    }
    $regex = @{ 'trace' = '^.*tion: 0 :' }

    $runspace = [PowerShell]::Create([InitialSessionState]::CreateDefault2())
    $stdOut = $runspace.AddScript( $TraceScript ).Invoke()
    $runspace.Streams.Debug | ForEach-Object {
        $_ -replace $regex.trace, ''
    }

}

if ($true -or $RunDebugTest) {
    function RegularTrace {
        [CmdletBinding()]
        param()
        # same command, using a regular Trace-Command that spams
        Trace-Command -Name ParameterBinding -PSHost -Verbose -Expression {
            if ($true) {
                # test that the debug stream is the only one captured
                Label 'lb: hi world' | Write-Debug
                Label 'lb: not debug'
            }

            $null | Join-String -sep ', '
        }
    }

    RegularTrace
    hr

    Capture-DebugStream
    | pygmentize.exe -l ps1

    HR

    Write-Warning 'This is an example, to be converted to arbitrary pipe? or just an example function?'
}