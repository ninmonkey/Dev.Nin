# next
function Dev-ExportTypeData {
    param(

        # Docstring
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$TypeName,

        # 5.1, 7.0, etc... Defaults to current $PSVersionTable.PSVersion
        [Parameter(Position = 1)]
        [Alias('Version')]
        [Version]$PowerShellVersion
    )
    # New-Item -ItemType File Temp:\ninmonkey\export_format.ps1xml -Force
    begin {
        if (! $PowerShellVersion) {
            $PowerShellVersion = $PSVersionTable.PSVersion -as 'version'
        }

        $meta = @{
            Query   = $TypeName
            Version = $PowerShellVersion
        }
        $Root = 'C:/nin_temp'
        mkdir $Root -Force -ea ignore
        mkdir "$Root/formatData" -Force -ea ignore
    }
    process {
        $Dest = Join-Path $Root "/formatData/$typeName.Format.ps1xml"
        Get-FormatData -TypeName $TypeName -PowerShellVersion 7.1
        | Export-FormatData -Path $Dest
        "Wrote: '$Dest'"
    }
}
'todo merge this'

# Dev-ExportTypeData -TypeName 'System.Diagnostics.Process'
# 'System.Diagnostics.Process' | Dev-ExportTypeData

# Get-FormatData *bits* | Export-FormatData -FilePath './exports/bits.format.ps1xml'
# Get-Content './exports/bits.format.ps1xml'
# | pygmentize.exe -l xml # optional colorize
# code './exports/bits.format.ps1xml' # or edit

if ($False) {
    $typeList = @(
        'Microsoft.Management.Infrastructure.CimInstance'
        'System.RuntimeType'
        'System.IO.FileInfo'
        'System.IO.DirectoryInfo'
        'System.IO.FileSystemInfo'
        'Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_Disk'
        'Microsoft.Management.Infrastructure.CimInstance#ROOT/Microsoft/Windows/Storage/MSFT_StorageObject'
        'Microsoft.Management.Infrastructure.CimInstance#MSFT_Disk'
        'Microsoft.Management.Infrastructure.CimInstance#MSFT_StorageObject'
        'Microsoft.Management.Infrastructure.CimInstance'
        'System.Object'
    ) | Sort-Object -Unique | Select-Object -First 2



    $AppRoot = Get-Item -ea stop 'C:/nin_temp/formatdatas/'


    foreach ($name in $typeList) {
        $dest = Join-Path $AppRoot "${name}.xml"
        $exportFormatDataSplat = @{
            InputObject        = $Fd
            Path               = $Dest
            IncludeScriptBlock = $true
        }

        # Export-FormatData @exportFormatDataSplat
    }

}
