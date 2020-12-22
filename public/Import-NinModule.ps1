function Import-NinModule {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, HelpMessage = 'Modules to import, else use defaults')]
        [string[]]$ModuleNames,

        # Ignore Verbose
        [Parameter()][switch]$IgnoreVerbose
    )
    <#
    .description
        personal wrapper, quickly re-imports dev modules
    #>
    if ( [string]::IsNullOrWhiteSpace( $ModuleNames ) ) {
        $ModuleNames = @(
            'Ninmonkey.PowerShell'
            'Ninmonkey.Console'
            'Dev.Nin'
            # 'Ninmonkey.Console-dotsource'
            # 'Ninmonkey.ConsolidateWip'
            # 'Ninmonkey.PowershellExamples'
            # 'Ninmonkey.VSCodeUtil'
            # 'Ninmonkey.Unicode'
            # 'Ninmonkey.PowerBI'
            # 'Ninmonkey.Ansi'
        )
    }
    # Import-Module $ModuleNames -Force -Verbose:( $null -eq $Verbose ? $false : $true )
    [bool]$isVerbose = ! $IgnoreVerbose
    Import-Module $ModuleNames -Force -Verbose:$isVerbose
}
