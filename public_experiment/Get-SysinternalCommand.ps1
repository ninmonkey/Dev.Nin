
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
        $Metadata = Get-ModuleMetadata -key 'Sysinternal'
        $Metadata
    }
    end {}
}
