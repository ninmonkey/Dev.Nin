
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

        $Metadata = @(
            @{
                Name    = 'Handle'
                Uri     = 'https://docs.microsoft.com/en-us/sysinternals/downloads/handle'
                Help    = Invoke-NativeCommand 'handle' -ArgumentList @('--help')
                Example = @(
                    'handle -p code'
                    'handle windows\system'
                )
            }
            @{
                Name    = 'ListDlls'
                Uri     = 'https://docs.microsoft.com/en-us/sysinternals/downloads/listdlls'
                Help    = Invoke-NativeCommand 'listdlls64' -ArgumentList @('--help')
                Example = @(
                    'Listdlls64.exe 7172'
                    'Listdlls64.exe spotify'
                )
            }
            @{
                Name    = 'Autoruns'
                Uri     = 'https://docs.microsoft.com/en-us/sysinternals/downloads/autoruns'
                Help    = 'N/a'
                Example = @(
                    'Autoruns64'
                    'Autorunssc64'
                )
            }
        ) | ForEach-Object { [pscustomobject]$_ }
    }
    process {
        $Metadata
    }
    end {}
}
