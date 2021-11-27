$experimentToExport.function += @(
    'Get-OptionalPath'
)
$experimentToExport.alias += @(
    'MaybePath'
)


function Get-OptionalPath {
    <#
    .synopsis
        Try to get a real [FileInfo]/[DirectoryInfo], else fallback to a raw string
    .notes
       if it does not exist yet, we also need to know if it is a directory or file

       Convert-Path is quicker
    .example
          .
    .outputs
        Union(String | [FileInfo] | [DirectoryInfo] )
    #>
    [Alias('MaybePath')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [Alias('PSPath')]
        [string]$Path

        # If I'm going to auto-create it, then make sure it's a directory
        # [Parameter(AttributeValues)]
        # [switch]$IsDirectory
    )

    begin {}
    process {
        if (Test-Path $Path) {
            Get-Item $Path
            return
        }
        $Path

    }
    end {}
}
