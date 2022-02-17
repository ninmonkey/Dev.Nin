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
    .link
        https://adamtheautomator.com/powershell-data-types/
    .link
        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/add-member?view=powershell-7.3
    .link
        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/add-type?view=powershell-7.3
    #>
    [Alias('DevTool💻-GetTypeAccellerators')]
    [CmdletBinding(PositionalBinding = $false)]
    param()

    [PSObject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::Get

}
