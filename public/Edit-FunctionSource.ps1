# future: todo: "Edit-FunctionSource() : cleanup me -> nin.console"
function Edit-FunctionSource {
    <#
    .synopsis
        open script that declares funnction
    .description
        currently only opens .ps1 scripts.
        see [Indented] for automatically viewing assemblies
    .notes
        .
    .example
        PS> Get-Command 'Get-Enum*' | Edit-FunctionSource
        PS> Alias 'Br' | Edit-FunctionSource
        PS> 'Br', 'ls' | Edit-FunctionSource
    #>

    # Function Name
    param(

        # Function or Alias name
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$FunctionName,

        # Return paths only
        [Parameter()][switch]$PassThru
    )

    Process {
        $maybeFunc = $FunctionName
        $functionQuery = $FunctionName | ForEach-Object {
            $isAlias = (Get-Command $maybeFunc -ea SilentlyContinue).CommandType -eq 'alias'
            if ($isAlias) {
                $resolvedAlias = Get-Alias -ea SilentlyContinue $maybeFunc | ForEach-Object ResolvedCommand
                $resolvedAlias
            }
            else {
                Get-Command $FunctionName -ea SilentlyContinue
            }
        }

        # $PSDefaultParameterValues['Write-ConsoleLabel:fg'] = '7FB2C1'
        Write-ConsoleLabel 'Matches: ' $functionQuery.count | Write-Information

        if (! $functionQuery ) {
            Write-Error "FunctionNotFound: No matches for query: '$FunctionName'"
            return
        }

        $numResults = $functionQuery.count
        if ($numResults -le 3) {
            $autoOpen = $true
        }
        if ($PassThru) {
            $autoOpen = $false
        }

        $functionQuery | ForEach-Object {
            $curCommand = $_
            $Path = $curCommand.ScriptBlock.Ast.Extent.File | Get-Item -ea Continue
            if ($Path) {
                if ($PassThru) {
                    $Path
                    return
                }

                if ($autoOpen) {
                    Write-Debug "code '$Path'"
                    code $Path
                }
                else {
                    '<', $Path, '>' -join ''
                }
            }
            else {
                H1 "shouldNeverException: curCommand = '$($curCommand.ScriptBlock.Ast.Extent.File)'`n`Unless it's non-text / assembly" | Write-Host

            }
        }
    }
    end {
        Write-Verbose 'See also: <G:\2020-github-downloads\powershell\github-users\chrisdent-Indented-Automation\Indented.GistProvider\Indented.GistProvider\private\GetFunctionInfo.ps1>'
    }
}

# Edit-FunctionSource 'Write-Conso'
if ($false -and $TempDebugTest) {
    # Edit-FunctionSource 'Write-ConsoleLabel' -ov 'FuncSourceRes'

    H1 'test1: as param'
    Edit-FunctionSource 'Write-ConsoleLabel' -ov 'FuncSourceRes1' -PassThru

    H1 'test2: as pipe'$FuncSourceRes | Join-String -SingleQuote -sep ', ' Name
    'ls', 'hr', 'Write-ConsoleHeader', 'Find-Type'
    | Edit-FunctionSource 'Write-ConsoleLabel' -ov 'FuncSourceRes2' -PassThru

    H1 'Test Results:'
    $FuncSourceRes1 | Join-String -SingleQuote -sep ', ' Name -OutputPrefix 'As Param = '
    $FuncSourceRes2 | Join-String -SingleQuote -sep ', ' Name -OutputPrefix 'As Pipe = '
    # $res[0]
    # Edit-FunctionSource 'Write-ConsoleLabefl'
    # Edit-FunctionSource 'hr'
    'Write-ConsoleLabel' | Edit-FunctionSource -PassThru
    'Label' | Edit-FunctionSource -PassThru
    'label', 'fm', 'goto' | Edit-FunctionSource -PassThru
}
