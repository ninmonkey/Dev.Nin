$experimentToExport.function += @(
    'Edit-ModuleSource'
)
$experimentToExport.alias += @(
    'EditModule'
)


function Edit-ModuleSource {
    <#
    .synopsis
        jumps to module's source, or its directory
    .description
        jumps to module's source, or its directory
    .outputs
        [string] or none
    .example
        PS> Get-Command 'Get-Enum*' | Edit-FunctionSource
        PS> Alias 'Br' | Edit-FunctionSource
        PS> 'Br', 'ls' | Edit-FunctionSource
    .notes
        . # 'See also: <G:\2020-github-downloads\powershell\github-users\chrisdent-Indented-Automation\Indented.GistProvider\Indented.GistProvider\private\GetFunctionInfo.ps1>'
    .link
        Edit-FunctionSource
    #>

    # Function Name
    [Alias('EditModule')]
    [cmdletbinding(PositionalBinding = $false)]
    param(
        # Module name
        [Parameter(
            mandatory, Position = 0, ParameterSetName = 'Module',
            ValueFromPipeline
        )]
        [string]$ModuleName,

        # Command Name
        [Parameter(
            ParameterSetName = 'FromFunction'
        )]
        [string]$FunctionName,

        # Open the psd1., otherwise the default opens the directory
        [Alias('SingleFile')]
        [Parameter()]
        [switch]$AsPsd1,

        # Return path[s] only
        [Parameter()][switch]$PassThru
    )
    begin {


    }

    Process {
        if ($PSCmdlet.ParameterSetName -eq 'FromFunction') {
            $ModuleName = Resolve-CommandName -Name $FunctionName
        }

        $selected = Get-Module -Name $ModuleName -ListAvailable
        | Sort-Object Version -Descending
        | Select-Object -First 1
        $selected | Join-String -p Name -sep ', ' -op 'Found: ' -os '.' | Write-Information

        if (! $selected ) {
            Write-Error 'Module: No match'
            return
        }

        $TargetPath = if ($AsPsd1) {
            $selected.Path
        }
        else {
            $Selected.ModuleBase
        }
        # note: Indented uses ModuleBase
        if ($PassThru) {
            $TargetPath
            return
        }

        $codeArgs = @(
            '-r'
            '-g'
            '""{0}""' -f @(
                $TargetPath
            )
            # '""{0}:{1}:{2}""' -f @(
            #     $Path
            #     $Meta.StartLineNumber
            #     $Meta.StartColumnNumber
            # )
        )
        $codeArgs | Join-String -sep ' ' -op 'ArgList: ' | Write-Debug
        <#
                    worked:
                    code -r -g 'C:\Users\cppmo_000\Documents\2021\Powershell\My_Github\Dev.Nin\public_experiment\Measure-ChildItem.ps1:5:5'

                    from: "$codeArgs | Join-String -se ' '
                    #>

        & code @codeArgs
        # & code-insiders @codeArgs
        # Edit-FunctionSource $TargetPath
        # $TargetPath | Ninmonkey.Console\Set-NinLocation
    }
    end {

    }
}
