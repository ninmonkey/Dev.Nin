#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_fmt_RipgrepResultVSCodeFilepath'
    )
    $experimentToExport.alias += @(
        # 'a' # '_fmt_RipgrepResultVSCodeFilepath'

    )
}

function _fmt_RipgrepResultVSCodeFilepath {
    <#
    .synopsis
        Takes ripgrep output like 'rg stuff' --json converts to objects
    .notes

    .example
    PS> rg 'debuginline' -tps --json
        | _fmt_RipgrepResultVSCodeFilepath

            public_experiment\test-assert\Not-Expression.ps1:2
            public_experiment\cmd-gh\Get-GistList.ps1:170

    PS> rg 'debuginline' -tps --json
        | _fmt_RipgrepResultVSCodeFilepath -NameOnly

            public_experiment\test-assert\Not-Expression.ps1
            public_experiment\cmd-gh\Get-GistList.ps1

    #>
    param(
        # Object or path to map
        [Parameter(
            Mandatory, ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [object]$InputObject,

        # Return filepath, alone, no line numbers
        [Parameter()]
        [switch]$NameOnly
    )
    begin {
        $Items = [list[object]]::new()
    }
    process {
        $obj = $_ | ConvertFrom-Json
        $Items.Add( $obj )

    }
    end {
        <#
        expected top level keys:
            'path', 'lines', 'line_number', 'absolute_offset', 'submatches'
        #>
        $queryMatch = $Items | Where-Object Type -EQ 'match'
        if ($NameOnly) {
            return $queryMatch.data.path.text | Sort-Object -Unique
        }

        $queryMatch.data | ForEach-Object {
            $Path = $_.Path.Text
            $LineNumber = $_.line_number

            '{0}:{1}' -f @($Path, $LineNumber)
        }

        # } | Where-Object Type -EQ 'match'
        # | ForEach-Object { $_.data.path.text }

    }
}

<#
Set-Location 'C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin'
rg 'debuginline' -tps --json
| _fmt_RipgrepResultVSCodeFilepath
hr
rg 'debuginline' -tps --json
| _fmt_RipgrepResultVSCodeFilepath -NameOnly

$saved = rg 'debuginline' -tps --json
| _fmt_RipgrepResultVSCodeFilepath

#>
