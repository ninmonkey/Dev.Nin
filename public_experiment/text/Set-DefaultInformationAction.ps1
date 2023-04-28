#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Set-DefaultInformationAction'
    )
    $experimentToExport.alias += @(
        'Set->InfaAction' # 'Set-DefaultInformationAction'
        'SetInfa' # 'Set-DefaultInformationAction'
    )
}

function Set-DefaultInformationAction {
    <#
    .synopsis
        sugar to add infa quickcly in the CLI for the current session only
    .example
        setInfa 'Get-Item'
    #>
    [Alias(
        'Set->InfaAction',
        'SetInfa'
    )]
    param(
        # Command or function
        [NotNull()]
        [Alias('Name', 'Command')]
        # [NinTransformArgForResolveCommandName]
        [string]$FunctionName,

        # test config, but don't actually write to oit
        [switch]$WhatIf,

        # List then quit. Show existing Keys, filtered to only show InformationPreference related keys
        [switch]$List
    )
    # not done
    # Wait-Debugger
    if ($List) {
        # $global:PSDefaultParameterValues.Keys #-split '\r?\n'
        $PSDefaultParameterValues.Keys #-split '\r?\n'
        | rg 'InformationActioninfa|write-information|wi' | Sort-Object -Unique
        return
    }

    if (!(Test-CommandExists $FunctionName)) {
        Write-Warning 'Command '$FunctionName" does not exist"
    }

    $KeyName = "global:${FunctionName}:WriteInformation"

    if ($WhatIf) {
        'write "continue" to $PSDefaultParameterValues[{0}]' -f @($KeyName)
        return
    }
    $PSDefaultParameterValues[$keyName] = 'continue'
}



if (! $experimentToExport) {
    # ...
}
