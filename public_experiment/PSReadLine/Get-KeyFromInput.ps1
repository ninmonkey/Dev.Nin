#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Get-KeyFromInput'
    )
    $experimentToExport.alias += @(
        'Console->WhatKeyAmI'
    )
}

function Get-KeyFromInput {
    <#
    .synopsis
        get [ConsoleKeyInfo] by typing a key
    .description
       .
    .notes
        See: <https://docs.microsoft.com/en-us/dotnet/api/system.console.readkey?view=net-6.0#System_Console_ReadKey_System_Boolean_>
    .example
        PS> Get-KeyFromInput
    .link
        Microsoft.PowerShell.PSConsoleReadLineOptions
    .link
        Microsoft.PowerShell.PSConsoleReadLine
    .link
        System.Console
    .link
        System.ConsoleKeyInfo
    .outputs
        [ConsoleKeyInfo]    
    #>
    [Alias('Console->WhatKeyAmI')]
    [CmdletBinding(PositionalBinding = $false)]
    param()    

    [console]::ReadKey($true)           
}

if (! $experimentToExport) {
    # ...
}