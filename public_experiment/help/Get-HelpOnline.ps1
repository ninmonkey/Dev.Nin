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

    [Alias('ho')]
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
            | Resolve-CommandName
            | help -Online
            return 
        } catch [System.Management.Automation.PSInvalidOperationException] {
            'todo: Try fallback'
            $_.Exception.ToString()
            Write-Error $_             
        }

        "maybe it's a type?"
        hr
        $InputObject | Get-ObjectTypeInfo
        hr
        $InputObject | get-objectTypeHelp

    }

}
if ( ! $experimentToExport ) {
}