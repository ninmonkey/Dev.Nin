#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Get-HelpOnline'
    )
    $experimentToExport.alias += @(
        'ho'
    )
}

function Get-HelpOnline {
    <#
    .synopsis
        find newest, preview them in bat
    .description
        .
    .notes
        .
    .example
        PS> Get-HelpOnline 4
    .example
        PS> $Error[0..3] | Get-HelpOnline

    .example
        🐒>
    #>

    # [Alias('ho')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # command or text to look up
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )
    begin {
        Write-Warning "wip: '$PSCommandPath'"
    }
    process {

        try {
            $InputObject
            | Resolve-CommandName -ea stop
            | help -Online -ea stop

            'full way [1]'
            # } catch [System.Management.Automation.InvalidOperationException ] {
        } catch {
            'failed way [2]'
            # 'todo: Try fallback'
            # $_.Exception.ToString()
            # Write-color -fg 'blue' -t $_
        }

        "maybe it's a type?"
        Hr
        $InputObject | Get-ObjectTypeInfo
        Hr
        $InputObject | get-objectTypeHelp

    }

}
if ( ! $experimentToExport ) {
}
