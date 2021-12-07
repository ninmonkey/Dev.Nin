#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Completions-CommandParameterName'
        'Completions-CommandParameterSets'

    )
    $experimentToExport.alias += @(

        'Completions->CmdParamName'
        'Completions->CmdParamSets'
    )
}

# Can I namespace pure pwsh ? Then I wouldn't need custom verbs
function Completions-CommandParameterName {
    <#
    .synopsis
        Commandlet / Function parameter names
    .description
        _enumerate-CmdParamName    .
        tags: devtool, completer, inspect
    .example
          # see <Completions.tests.ps1>
    .outputs
          [string[] | None]
    .link
        system.Management.Automation.ParameterMetadata
    #>
    [Alias('Completions->CmdParamName')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Alias('Name')]
        [Parameter( Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$InputObject
    )

    begin {

    }
    process {
        $cmd = $InputObject | Resolve-CommandName
        $cmd | ForEach-Object Parameters | ForEach-Object Keys | Sort-Object -Unique
    }
    end {
    }
}

function Completions-CommandParameterSets {
    <#
    .synopsis
        Commandlet / Function parameter names
    .description
        _enumerate-CmdParamName    .
        tags: devtool, completer, inspect
    .example
          # see <Completions.tests.ps1>
    .outputs
          [string[] | None]
    .link
        System.Management.Automation.CommandParameterSetInfo
    .link
        system.Management.Automation.ParameterMetadata
    #>
    [Alias('Completions->CmdParamSets')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Alias('Name')]
        [Parameter( Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$InputObject
    )

    begin {
    }
    process {
        # is a [ReadOnlyCollection`1[Management.Automation.CommandParameterSetInfo]
        # throw 'always break'
        $cmd = $InputObject | Resolve-CommandName
        # Wait-Debugger
        Write-Host 'it was not distinct' -fo red
        if (!(Test-OneOrNone $cmd)) {
            Write-Host -ea continue 'it was not distinct' -fo red
            Write-Error -ea continue 'not: one_or_none()' # this isn't working
        }
        if (@($cmd).count -gt 1) {
            Write-Error -ea continue 'multiple commands found' # this isn't working
        }

        $cmd.ParameterSets | ForEach-Object Name | Sort-Object -Unique
    }
    end {
    }
}

# Write-Error 'nyi paste'


if (! $experimentToExport) {
    # ...
}
