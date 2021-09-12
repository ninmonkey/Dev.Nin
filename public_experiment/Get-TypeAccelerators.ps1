$experimentToExport.function += @(
    'Get-TypeAccelerators'
)
$experimentToExport.alias += @(
    'DevTool💻-GetTypeAccellerators'
)

function Get-TypeAccelerators {
    <#
    .synopsis
        Enumerate Type Accelerators
    .description
        Enumerate Type Accelerators
    .example
        Get-TypeAccelerators
    #>
    [Alias('DevTool💻-GetTypeAccellerators')]
    [CmdletBinding(PositionalBinding = $false)]
    param()

    [PSObject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::Get

}
