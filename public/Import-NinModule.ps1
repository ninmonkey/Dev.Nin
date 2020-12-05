function Import-NinModule {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, HelpMessage = 'Modules to import, else use defaults')]
        [string[]]$ModuleNames
    )
    <#
    .description
        personal wrapper, quickly re-imports dev modules
    #>
    if ( [string]::IsNullOrWhiteSpace( $ModuleNames ) ) {
        $ModuleNames = @(
            'Ninmonkey.PowerShell'
            'Ninmonkey.Console'
            # 'Ninmonkey.Console-dotsource'
            # 'Ninmonkey.ConsolidateWip'
            # 'Ninmonkey.PowershellExamples'
            # 'Ninmonkey.VSCodeUtil'
            # 'Ninmonkey.Unicode'
            # 'Ninmonkey.PowerBI'
            'Dev.Nin'
            # 'Ninmonkey.Ansi'
        )
    }
    # Import-Module $ModuleNames -Force -Verbose:( $null -eq $Verbose ? $false : $true )
    Import-Module $ModuleNames -Force -Verbose
}
