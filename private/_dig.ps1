#Requires -Version 7.0.0
#Requires -Module Ninmonkey.Console

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
        [string]$Path = '.'
    )
    begin {
        # $here = Find-GitRepo -Path $Path # this is an example source
        $BaseDirectory = Get-Item -ea stop $Path
        $str = @{
            'PathPrefix' = '=> ' # bread crumb, kinda
        }
        $Regex = @{
            'PrefixString' = '^' + [regex]::Escape('.\') # for removal
        }
        Label 'BasePath' $BaseDirectory
    }
    process {
        $PotentialItems = Find-GitRepo 'C:\Users\cppmo_000\Documents\2020\powershell\MyModules_Github\'
        $PotentialItems | Label 'items'
        Label 'BasePath' $BaseDirectory

        return
        $Regex.PrefixString

        return
        # return
        'fs'
        | Format-RelativePath -BasePath .
        | ForEach-Object { $_ -replace '^\.\\',
            $prefix }
        | Sort-Object -Unique
        | Out-Fzf
        | ForEach-Object {
            Join-Path $here.FullName ($_ -replace "^$prefix", '')
        }


    }
    end {}
}
'sdf'
Find-DevItem