#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Invoke-EnablePrivateIntellisense'
    )
    $experimentToExport.alias += @(
        # 'Invoke-EnablePrivateIntellisense'
    )
}

function Invoke-EnablePrivateIntellisense {
    <#
    .synopsis
        enable module scope, allows intellisence of private members
    .description
        quote:
            justinGrote: I forgot this little gem to get a prompt inside a module
            without using the debugger

            & (impo exchangeOnlineManagement -passThru) { $host.EnterNestedPrompt() }
    .example
        Invoke-EnablePrivateIntellisense -Name exchangeOnlineManagement
    #>
    [CmdletBinding()]
    param(
        # target module
        [Alias('Name')]
        [string]$ModuleName
    )

    & (Import-Module $ModuleName -PassThru) { $host.EnterNestedPrompt() }

}

if (! $experimentToExport) {
    # ...
}
