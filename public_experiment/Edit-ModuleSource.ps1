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

        # Return path[s] only
        [Parameter()][switch]$PassThru
    )
    begin {


    }

    Process {
        if ($PSCmdlet.ParameterSetName -eq 'FromFunction') {
            $ModuleName = Resolve-CommandName -Name $FunctionName
        }

        $selected = Get-Module -Name $ModuleName
        $selected | Join-String -p Name -sep ', ' -op 'Found: ' -os '.' | Write-Information

        if (! $selected ) {
            Write-Error 'Module: No match'
            return
        }

        if ($PassThru) {
            $selected.Path
        }
        $selected.Path | Ninmonkey.Console\Set-NinLocation
    }
    end {

    }
}
