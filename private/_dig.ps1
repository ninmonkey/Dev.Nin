#Requires -Version 7.0.0
#Requires -Module Ninmonkey.Console

Import-Module Ninmonkey.Console -Force
$PSDefaultParameterValues['Find-DevItem:InformationAction'] = $true
function Find-DevItem {
    <#
    .synopsis

    .description
        .
    .example
        PS>
    .notes
        I chose 'dig' rather than 'dive', because
        dig implies you're searching for something
    #>
    [alias('Dig', 'Find-Item')]
    param (
        # root path to search
        [parameter(Position = 0)]
        [string]$Path = ''
    )
    begin {
        # $here = Find-GitRepo -Path $Path # this is an example source
        [hashtable]$meta_debug = @{
            Path0 = $Path
        }
        if ([string]::IsNullOrWhiteSpace($Path)) {
            $Path = '.'
        }
        $meta_debug.Path1 = $Path

        $BaseDirectory = Get-Item -ea stop $Path
        $meta_debug.Base0 = $BaseDirectory

        $str = @{
            'PathPrefix' = '=> ' # bread crumb, kinda
        }
        $Regex = @{
            'PrefixString' = '^' + [regex]::Escape('.\') # for removal
        }
        Label 'BasePath: begin()' $BaseDirectory | Write-Information
        $meta_debug | Format-HashTable | Write-Information
    }
    process {
        # $PotentialItems = Find-GitRepo 'C:\Users\cppmo_000\Documents\2020\powershell\MyModules_Github\'


        $PotentialItems = Get-ChildItem -Path $Path -Recurse
        | Select-Object -First 4
        # | Label ('items'.PadLeft(14))
        $meta_debug.Path2 = $Path
        $meta_debug.Pipe0 = $PotentialItems | Select-Object -First 1


        Label 'BasePath: Iter' $BaseDirectory | Write-Information


        $results = $PotentialItems
        | Format-RelativePath -BasePath $Path

        $results

        $meta_debug.Pipe0 = $results | Select-Object -First 1

        # return
        # $Regex.PrefixString
        # hr

        # # return
        # # return
        # $PotentialItems
        # | Format-RelativePath -BasePath .
        # | ForEach-Object { $_ -replace '^\.\\',
        #     $prefix }
        # | Sort-Object -Unique





        # | Out-Fzf
        # | ForEach-Object {
        #     Join-Path $here.FullName ($_ -replace "^$prefix", '')
        # }


    }
    end {
        Label -fg orange 'start ==>' -bef 2
        $meta_debug | Format-HashTable
        | Write-Information # for now
        # | Write-debug

        Label -fg orange 'end <==' -af 2

    }
}
# 'sdf'
if ($testinline) {
    Find-DevItem -infa continue
    Hr 2
    Find-DevItem -infa continue -Path 'C:\Users\cppmo_000\Documents\2020\powershell\MyModules_Github\Ninmonkey.PowerBI'

}