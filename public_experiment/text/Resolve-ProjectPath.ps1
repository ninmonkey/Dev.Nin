#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(

        'ResolveProjFileInfo'
        'Resolve-ProjectRelativePath'
        'Set-ProjectRelativePath'

    )
    $experimentToExport.alias += @(
        # 'Set-ProjectRelativePath'
        'setProjRelPath'  # 'Set-ProjectRelativePath'

        # ''
        # 'getItem?' #  '_ResolvePath'
        'relProjPath' # 'Resolve-ProjectRelativePath'
        # '_MaxLimits'

        #  ResolveProjFileInfo
        # 'getItem?', #  ResolveProjFileInfo
        # 'Resolve->FilePath', #  ResolveProjFileInfo
        # 'resolvePath' #  ResolveProjFileInfo

        'Resolve-ProjectRelativePath'

    )
}


# do me -> nin.console
function ResolveProjFileInfo {
    <#
    .synopsis
        return resolved item, else keeps the path

    .example
        _ResolvePath '.output'
        _ResolvePath '.output' -BasePath $AppRoot

    .link
        https://docs.microsoft.com/en-us/dotnet/standard/io/file-path-formats#unc-paths
    .link
        Dev.Nin\Set-ProjectRelativePath
    .link
        Dev.Nin\Resolve-ProjectRelativePath
    .link
        Dev.Nin\Resolve-Path
    #>
    [Alias(
        '_ResolvePath'
        # 'getItem?',
        # 'resolvePath',
        # 'Resolve->Path',
        # 'Resolve->FilePath',
        # 'to->FilePath' #  ?
    )]
    [OutputType(
        'string', [System.IO.FileSystemInfo]
    )]
    param(
        [Alias('PSPath')]
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Path,

        [parameter()]
        [string]$BasePath,

        # kwargs
        [Parameter()]
        [hashtable]$Options
    )
    begin {
        [hashtable]$Config = @{
            BasePath = $BasePath ?? $App.Root ?? (Get-Item . -ea ignore) ?? '.'
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})
    }
    process {

        $rawStr = Join-Path $Config.BasePath $Path
        try {
            $item = Get-Item -ea stop -Path $rawStr
        } catch {
            $item = $rawStr
        }
        return $item
    }

}

function Set-ProjectRelativePath {
    <#
    .synopsis
        return resolved item, else keeps the path
    .link
        Dev.Nin\Set-ProjectRelativePath
    .link
        Dev.Nin\Resolve-ProjectRelativePath
    .link
        Dev.Nin\Resolve-Path
    #>
    [Alias('setProjRelPath')]
    [OutputType(
        'string', [System.IO.FileSystemInfo]
    )]
    param(
        [Alias('PSPath')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Path,

        [Alias('Type')]
        [ValidateSet('Output', 'Root')]
        [string]$OutputType

        # as item, if exists
        # [switch]$AsItem
    )


}
function Resolve-ProjectRelativePath {
    <#
    .synopsis
        return resolved item, else keeps the path
    .link
        Dev.Nin\Set-ProjectRelativePath
    .link
        Dev.Nin\Resolve-ProjectRelativePath
    .link
        Dev.Nin\Resolve-Path
    #>
    [Alias('relProjPath')]
    [OutputType(
        'string', [System.IO.FileSystemInfo]
    )]
    param(
        [Alias('PSPath')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Path,

        [Alias('Type')]
        [ValidateSet('Output', 'Root')]
        [string]$OutputType

        # as item, if exists
        # [switch]$AsItem
    )
    process {
        $prefix = switch ($OutputType) {
            'Root' {
                $App.Root
            }
            'Output' {
                $App.ExportRoot
            }
            'Export' {
                $App.ExportRoot
            }
            'Import' {
                $App.ImportRoot
            }
            default {
                $App.ExportRoot

                '.output2'
            }
        }

        $rawStr = Join-Path $App.Root $Path
        try {
            $item = Get-Item -ea stop -Path $rawStr
        } catch {
            $item = $rawStr
        }
        return $item
    }
}


function _parseLog {
    param(
        [string]$Path,
        [switch]$Simple
    )
    $parsed = Get-Content $Path | ForEach-Object {
        $line = $_
        $meta = [ordered]@{
            Raw_Full = $line
            Header   = $line -split '\{' | Select-Object -First 1
            Raw_Json = $line -split '\{' | Select-Object -Skip 1 | Join-String -op '{'
        }
        try {
            $json = $line -split '\{' | Select-Object -Skip 1
            | Join-String -op '{' | ConvertFrom-Json
        } catch {
            $json = $line -split '\{' | Select-Object -Skip 1
            | Join-String -op '{'
            Write-Error "failed parsing: $json"
        }
        $meta['Json'] = $json

        if ($Simple) {
            [pscustomobject]$meta.Json
        } else {
            [pscustomobject]$meta

        }


    }
    $parsed
}




if ($false) {
    $simp = _parseLog -Path $App.Sample1 -Simple
    $parsed = _parseLog -Path $App.Sample1
    $parsed
    $parsed | Format-List



    'wrote: .\.output\temp.log'
    & {
        $simp | Format-List | Out-String -Width 999999 | StripAnsi
        | Sc -Path '.output/first.md'
        'wrote: {0}' -f '.output/firstmd'
    }

    & {
        # render chunk

        $chunks = $simp | Format-List | Out-String -Width 999999 | StripAnsi
        $chunks | ForEach-Object {
            $cur = $_
            $cur | Join-String @jstr_codeFence
        }
        | Select-Object -First 3
        # | sc -Path '.output/second.md'
    }
    & {
        $chunks = $simp | Format-List | Out-String -Width 999999 | StripAnsi
        $chunks | ForEach-Object {
            $cur = $_
            $cur | Join-String @jstr_codeFence
        }
        | Select-Object -First 3
        # | sc -Path (RelProjPath '.output/third.md')
    }
}
