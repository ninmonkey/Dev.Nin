using namespace Management.Automation

$experimentToExport.function += @(
    'Find-Color'
)
# $experimentToExport.alias += @(
#     'joinStr'
# )

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
        🐒> Find-Color 'alm', 'pink','moun' | _format_RgbColorString # to be a formatter
    .outputs
          [string | None]

    #>
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
    end {}
}
