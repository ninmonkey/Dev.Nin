#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Find-CustomArgumentCompleter'
    )
    $experimentToExport.alias += @(
        'DevTool💻-GetArgumentCompleter'
    )
}

function Find-CustomArgumentCompleter {
    <#
    .SYNOPSIS
        Get custom argument completers registered in the current session.
    .DESCRIPTION
        Get custom argument completers registered in the current session.
        By default Find-CustomArgumentCompleter lists all of the completers registered in the session.

        Originally from: [indented-automation/Find-CustomArgumentCompleter.ps1](https://gist.github.com/indented-automation/26c637fb530c4b168e62c72582534f5b)
    .EXAMPLE
        Find-CustomArgumentCompleter

        Get all of the argument completers for PowerShell commands in the current session.
    .EXAMPLE
        Find-CustomArgumentCompleter -CommandName Invoke-ScriptAnalyzer

        Get all of the argument completers used by the Invoke-ScriptAnalyzer command.
    .EXAMPLE
        Find-CustomArgumentCompleter -Native

        Get all of the argument completers for native commands in the current session.
    #>

    [alias('DevTool💻-GetArgumentCompleter')]
    [CmdletBinding(DefaultParameterSetName = 'PSCommand')]
    param (
        # Filter results by command name.
        [String]$CommandName = '*',

        # Filter results by parameter name.
        [Parameter(ParameterSetName = 'PSCommand')]
        [String]$ParameterName = '*',

        # Get argument completers for native commands.
        [Parameter(ParameterSetName = 'Native')]
        [Switch]$Native
    )

    $getExecutionContextFromTLS = [PowerShell].Assembly.GetType('System.Management.Automation.Runspaces.LocalPipeline').GetMethod(
        'GetExecutionContextFromTLS',
        [System.Reflection.BindingFlags]'Static,NonPublic'
    )
    $internalExecutionContext = $getExecutionContextFromTLS.Invoke(
        $null,
        [System.Reflection.BindingFlags]'Static, NonPublic',
        $null,
        $null,
        $psculture
    )

    if ($Native) {
        $argumentCompletersProperty = $internalExecutionContext.GetType().GetProperty(
            'NativeArgumentCompleters',
            [System.Reflection.BindingFlags]'NonPublic, Instance'
        )
    } else {
        $argumentCompletersProperty = $internalExecutionContext.GetType().GetProperty(
            'CustomArgumentCompleters',
            [System.Reflection.BindingFlags]'NonPublic, Instance'
        )
    }

    $argumentCompleters = $argumentCompletersProperty.GetGetMethod($true).Invoke(
        $internalExecutionContext,
        [System.Reflection.BindingFlags]'Instance, NonPublic, GetProperty',
        $null,
        @(),
        $psculture
    )
    foreach ($completer in $argumentCompleters.Keys) {
        $name, $parameter = $completer -split ':'

        if ($name -like $CommandName -and $parameter -like $ParameterName) {
            [PSCustomObject]@{
                CommandName   = $name
                ParameterName = $parameter
                Definition    = $argumentCompleters[$completer]
            }
        }
    }
}


if (! $experimentToExport) {
    # ...
}
