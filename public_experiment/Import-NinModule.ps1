

$experimentToExport.function += 'Import-DevNinModule'
# $experimentToExport.alias += 'AllTrue'
function Import-DevNinModule {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, HelpMessage = 'Modules to import, else use defaults')]
        [string[]]$ModuleNames,

        # Ignore Verbose
        [Parameter()][switch]$Silent
    )
    <#
    .description
        personal wrapper, quickly re-imports dev modules
    #>
    process {
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
        $ModuleNames | Join-String -sep ', ' -SingleQuote -op 'ModuleNames: '
        # Import-Module $ModuleNames -Force -Verbose:( $null -eq $Verbose ? $false : $true )
        $sp_ImportForce = @{
            ModuleNames = $ModuleNames
        }
        if ($Silent) {
            $sp_ImportForce += @{
                'Verbose'       = $false
                'WarningAction' = SilentlyContinue
                'infa'          = SilentlyContinue
                'ErrorAction'   = SilentlyContinue
            }
        }
        $sp_ImportForce | Join-String -op 'Import args:' | Write-Debug

        Import-Module @sp_ImportForce
    }
}
