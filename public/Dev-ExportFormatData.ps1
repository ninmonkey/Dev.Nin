function Dev-ExportFormatData {
    param(

        # Docstring
        [Parameter(Mandatory, Position = 0)]
        [string]$TypeName,

        # 5.1, 7.0, etc... Defaults to current $PSVersionTable.PSVersion
        [Parameter(Position = 1)]
        [Alias('Version')]
        [Version]$PowerShellVersion
    )
    # New-Item -ItemType File Temp:\ninmonkey\export_format.ps1xml -Force
    if (! $PowerShellVersion) {
        $PowerShellVersion = $PSVersionTable.PSVersion -as 'version'
    }

    $meta = @{
        Query   = $TypeName
        Version = $PowerShellVersion
    }

    Get-FormatData -TypeName $TypeName -PowerShellVersion 7.1
    | Export-FormatData -Path Temp:"\ninmonkey\FormatData\$typeName.Format.ps1xml"
}

# Get-FormatData *bits* | Export-FormatData -FilePath './exports/bits.format.ps1xml'
# Get-Content './exports/bits.format.ps1xml'
# | pygmentize.exe -l xml # optional colorize
# code './exports/bits.format.ps1xml' # or edit