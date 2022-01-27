#Requires -Version 7
using namespace Management.Automation

if ( $experimentToExport ) {
    $experimentToExport.function += @(

        'Find-Color'
        'ColorTool🎨-FindColor'
    )
    $experimentToExport.alias += @(

    )
}

function Find-Color {
    <#
    .synopsis
        Stuff
    .description
       Searches X11ColorName of the Fg:\ provider
    .notes
        todo:
        - [ ] find-color 'alm', 'pink','moun' | _format_RgbColorString
    .example
        🐒> Find-Color 'alm', 'moun'
        🐒> Gi RgbColor::Foreground:\yellow
    .example
        🐒> Find-Color orange | _write-AnsiBlock -NoName | str csv
    .example
        🐒> Find-Color 'alm', 'pink','moun' | _format_RgbColorString # to be a formatter
    .outputs
          [string | None]

    #>
    [Alias('ColorTool🎨-FindColor')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Regex patterns
        [Parameter(
            Mandatory,
            Position = 0)]
        [string[]]$Name,

        [Parameter(
            Position = 1)]
        [string[]]$SortByProp = 'Rgb'
    )

    begin {
        Write-Verbose @'
find-color 'pink' | %{ new-text -fg $_ $x }
find-color 'alm', 'pink','moun' | _format_RgbColorString
'@
        $ColorCache = Get-ChildItem fg:
        $Regex = Join-Regex -Regex $Name
    }
    process {
        $ColorCache | ?Str $Regex -Property 'X11ColorName'
    }
    end {
    }
}


if (! $experimentToExport) {
    # ...
}
