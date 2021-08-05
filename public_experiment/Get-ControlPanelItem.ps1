$experimentToExport.function += @(
    'Get-ControlPanelSetting'
)
# $experimentToExport.alias += @(
#     'EditModule'
# )
function Get-ControlPanelSetting {
    <#
    .synopsis
        Opens control panel from names
    .description
        Descd
    .outputs

    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
    )

    begin {}
    process {
        Start-Process 'ms-settings:apps-volume'
        Write-Error 'left off: use dynamic generated key value pairs for auto complete'

    }
    end {}
}
