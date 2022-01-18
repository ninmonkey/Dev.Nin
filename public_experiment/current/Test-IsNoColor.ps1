#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Test-IsNoColor'
    )
    $experimentToExport.alias += @(

    )
}

function Test-IsNoColor {
    <#
    .synopsis
        sugar to check whether color should be disabled: $ENV:NO_COLOR or $PSStyle is set to plain text
    .description
    Quote:
        > Command-line software which adds ANSI color to its output by default should check for the presence of a NO_COLOR environment variable that, when present (regardless of its value), prevents the addition of ANSI color.
    .link
        https://no-color.org/
    #>
    [OutputType('System.Boolean')]
    param()

    if ( $Env:NO_COLOR) {
        return $true
    }
    # do you want to test for [1] non-ansi, or, [2] equal to ansi, for host,text, ansi
    # if ([System.Management.Automation.OutputRendering]::Ansi -ne $PSStyle.OutputRendering) {
    if ([System.Management.Automation.OutputRendering]::PlainText -eq $PSStyle.OutputRendering) {
        return $true
    }
    return $false
}


if (! $experimentToExport) {
    # ...
}
