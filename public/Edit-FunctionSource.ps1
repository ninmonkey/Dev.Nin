function Edit-FunctionSource {
    <#
    .synopsis
        open script that declares funnction
    .description
        currently only opens .ps1 scripts.
        see [Indented] for automatically viewing assemblies
    .outputs
        [InternalScriptExtent] or none
    .example
        PS> Get-Command 'Get-Enum*' | Edit-FunctionSource
        PS> Alias 'Br' | Edit-FunctionSource
        PS> 'Br', 'ls' | Edit-FunctionSource
    .notes
        . # 'See also: <G:\2020-github-downloads\powershell\github-users\chrisdent-Indented-Automation\Indented.GistProvider\Indented.GistProvider\private\GetFunctionInfo.ps1>'
    .link
        Edit-ModuleSource
    #>

    # Function Name
    [Alias('EditFunc')]
    [cmdletbinding(PositionalBinding = $false)]
    param(
        # Function or Alias name1
        # future: autocomplete FUnc
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$FunctionName,

        # Return paths only
        [Parameter()][switch]$PassThru,
        # Return paths only
        [Parameter()][switch]$SkipPositionArgs = $false # until I can get the native args passing
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
            $Meta = $curCommand.ScriptBlock.Ast.Extent | Select-Object * -ExcludeProperty Text
            $Path = $meta.File | Get-Item -ea continue
            if ($Path) {
                $meta | ConvertTo-Json | Write-Debug
                if ($PassThru) {
                    "From: '$Path'" | Write-Debug
                    $Meta
                    return
                }

                if ($autoOpen -and (Test-Path $Path)) {
                    Write-Debug "found: '$Path'"

                    if ($SkipPositionArgs) {
                        code-insiders (Get-Item $Path -ea stop)
                        return
                    }

                    $codeArgs = @(
                        '-r'
                        '-g'
                        '""{0}:{1}:{2}""' -f @(
                            $Path
                            $Meta.StartLineNumber
                            $Meta.StartColumnNumber
                        )
                    )
                    $codeArgs | Join-String -sep ' ' -op 'ArgList: ' | Write-Debug
                    <#
                    worked:
                    code -r -g 'C:\Users\cppmo_000\Documents\2021\Powershell\My_Github\Dev.Nin\public_experiment\Measure-ChildItem.ps1:5:5'

                    from: "$codeArgs | Join-String -se ' '
                    #>

                    & code-insiders @codeArgs
                }
                else {
                    '<', $Path, '>' -join ''
                }
            }
            else {
                Write-Error "shouldNeverReachException: curCommand = '$($curCommand.ScriptBlock.Ast.Extent.File)'`n`Unless it's non-text / assembly"
                return # continues

            }
        }
    }
    end {

    }
}

if ($TempDebugTest) {
    # Edit-FunctionSource goto
}
# Edit-FunctionSource goto -Verbose -Debug -InformationAction continue

if ($false) {
    $q = Edit-FunctionSource lsFd -InformationAction continue -ea break

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
