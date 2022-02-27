function Edit-FunctionSource {
    <#
    .synopsis
        open script that declares function
    .description
        find and open filepath for a function, jump to the exact line number

        currently only opens .ps1 scripts.
        see [Indented] for automatically viewing assemblies
        move -> console
    .notes
        - could simply and refactor this function using
            Dev.Nin\CmdtoFilepath
            Dev.Nin\Resolve-CommandName


        . # 'See also: <G:\2020-github-downloads\powershell\github-users\chrisdent-Indented-Automation\Indented.GistProvider\Indented.GistProvider\private\GetFunctionInfo.ps1>'
    .outputs
        [InternalScriptExtent] or none
    .example
        🐒> gcm *vscode* | editfunc -PassThru | % File | Sort -Unique
    .example
        🐒> gcm -Module Dev.Nin | % Name | Out-Fzf -m
        | EditFunc -PassThru
        | % file | gi | ft Name, Directory

            Name                     Directory
            ----                     ---------
            Edit-DevTodoList.ps1     C:\Users\cppmo_000\Documents\2021\Powershell\My_Github\Dev.Nin\public
            Format-RipGrepUrl.ps1    C:\Users\cppmo_000\Documents\2021\Powershell\My_Github\Dev.Nin\public_experiment
            ConvertFrom-GistList.ps1 C:\Users\cppmo_000\Documents\2021\Powershell\My_Github\Dev.Nin\public
            Dev-ExportFormatData.ps1 C:\Users\cppmo_000\Documents\2021\Powershell\My_Github\Dev.Nin\public
    .example
        # Find and open paths from a query
        PS> Get-CommandNameCompleter *sys* -PassThru | EditFunc -PassThru
    .example
        PS> Get-Command 'Get-Enum*' | Edit-FunctionSource
        PS> Alias 'Br' | Edit-FunctionSource
        PS> 'Br', 'ls' | Edit-FunctionSource
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
        [string[]]$FunctionName,

        # don't open VSCode, return the filepath
        [Parameter()][switch]$PassThru,

        # Return paths only
        [Parameter()][switch]$SkipPositionArgs = $false # until I can get the native args passing
    )

    Process {
        $FunctionName | ForEach-Object {
            $curFuncName = $_
            $maybeFunc = $curFuncName
            $functionQuery = $curFuncName | ForEach-Object {
                $isAlias = (Get-Command $maybeFunc -ea SilentlyContinue).CommandType -eq 'alias'
                if ($isAlias) {
                    $resolvedAlias = Get-Alias -ea SilentlyContinue $maybeFunc | ForEach-Object ResolvedCommand
                    $resolvedAlias
                }
                else {
                    Get-Command $curFuncName -ea SilentlyContinue
                }
            }
            Write-ConsoleLabel 'Matches: ' $functionQuery.count | Write-Information

            if (! $functionQuery ) {
                Write-Error "FunctionNotFound: No matches for query: '$curFuncName'"
                return
            }

            $numResults = $functionQuery.count
            if ($numResults -le 3) {
                $autoOpen = $true
            }
            if ($PassThru) {
                $autoOpen = $false
            }

            $functionQuery | Where-Object {
                Write-Debug 'test: Is [FunctionInfo]?'
                $_ -is [System.Management.Automation.FunctionInfo]
            }
            | ForEach-Object {
                $curCommand = $_
                # todo: fix: when piping funcinfo from [Get-IndendtedFunctioninfo] $Path is $null

                $Meta = $curCommand.ScriptBlock.Ast.Extent #| Select-Object * -ExcludeProperty Text
                # $Meta = $curCommand.ScriptBlock.Ast.Extent | Select-Object * -ExcludeProperty Text
                $Path = $meta.File | Get-Item -ea ignore
                if (! $Path) {
                    Write-Error 'Appears to not be a script'
                }
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
                            # code-insiders (Get-Item $Path -ea stop)
                            code-venv -path (Get-Item $Path -ea stop)
                            return
                        }

                        $codeArgs = @(
                            '-r'
                            '-g'
                            '"{0}:{1}:{2}"' -f @(
                                $Path
                                $Meta.StartLineNumber
                                $Meta.StartColumnNumber
                            )
                        )
                        $codeArgs | Join-String -sep ' ' -op 'ArgList: ' | Write-Debug
                        # $CodeArgs | Join-String -sep ' '
                        # Code-Venv -ea break  -path $Path -Line $Meta.StartLineNumber -Column $Meta.StartColumnNumber
                        Code-Venv -ea Stop  -path $Path -Line $Meta.StartLineNumber -Column $Meta.StartColumnNumber

                        # $codeArgs | prefix 'ArgList: ' -sep ' ' | Write-Debug

                        # code-venv -path (Get-Item $Path -ea stop)
                        <#
                    worked:
                    code -r -g 'C:\Users\cppmo_000\Documents\2021\Powershell\My_Github\Dev.Nin\public_experiment\Measure-ChildItem.ps1:5:5'

                    from: "$codeArgs | Join-String -se ' '
                    #>

                        # & code-insiders @codeArgs
                        # $__v
                        # & code-insiders @codeArgs
                    }
                    else {
                        '<', $Path, '>' -join '' | Write-Information
                    }
                }
                else {
                    Write-Error "NonText/Binary: curCommand = '$($curCommand.ScriptBlock.Ast.Extent.File)'"
                    return # continues

                }
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
