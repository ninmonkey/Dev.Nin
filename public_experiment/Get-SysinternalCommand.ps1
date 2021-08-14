
$experimentToExport.function += @(
    'Get-SysinternalCommand'
)
# $experimentToExport.alias += @(
#     # 'Alarm'
# )


function Get-SysinternalCommand {
    <#
    .synopsis

    .description
        .
    .example
        PS>
    .notes
        .
    #>
    param ()
    begin {
    }
    process {
        $Metadata = _Get-ModuleMetada -key 'Sysinternal'
        $Metadata
    }
    end {}
}
