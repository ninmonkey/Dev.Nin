#Requires -Version 7
using namespace Management.Automation

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Find-Color'
        'Test-WriteColorSampleMessage'
    )
    $experimentToExport.alias += @(
        'Color->Find' # 'Dev.Nin\Find-Color'
        'Find->Color' # 'Dev.Nin\Find-Color'
        'Color->TestMessage' # 'Test-WriteColorSampleMessage'

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
    [Alias(
        'Color->Find',

        'Find->Color'
    )]
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

function Test-WriteColorSampleMessage {
    <#
    .example
        find-color red
        | ForEach-Object {
            '{0}: status message: {1}.' -f @(
                $_.ToString()
                Get-Date
            )
            | Write-Color -fg $_ -bg gray20
        }
    .notes
        related types:
            [PoshCode.Pansies.ColorSpaces.ColorSpace]
            [PoshCode.Pansies.ColorSpaces.Rgb]
            [PoshCode.Pansies.RgbColor]

        see also:
            pastel: cli command
    #>
    [Alias('Color->TestMessage')]
    param(
        # color instance
        [Alias('Color', 'RGBColor')]
        [parameter(Mandatory, valuefromPipeline)]
        #[rgbcolor]$InputObject, # which type?
        [object]$InputObject,

        [Alias('Bg')]
        [parameter(position = 0)]
        #[rgbcolor]$InputObject, # which type?
        [object]$BackgroundColor,

        [parameter(position = 1)]
        [ArgumentCompletions(
            '"{0}: status message: {1}"'
        )]
        [String]$Template

        # [hashtable]$Options
    )
    begin {
        if ($Template) {
            Write-Warning '-template NYI'
        }
        # $Options | Out-Default | Write-Debug
        # if( $Pscmdlet.psboundparameter
        $Config = @{
            # Template = $Text ?? '{0}: status message: {1}.'
            Template = '{0}: status message: {1}.'
            Param1   = 'Status'
            Param2   = Get-Date
        }
        # $Config | Out-Default | Write-Debug
        #
        $Gradient = @{
            Gray10Step  = Get-Gradient -StartColor 'gray0' -EndColor 'gray100' -Steps 10
            Gray100Step = Get-Gradient -StartColor 'gray0' -EndColor 'gray100' -Steps 100
            Red         = find-color 'red'
        }
        # $Gradient | Out-Default | Write-Debug

        # $Gradient = Join-Hashtable $Gradient -Other (($Options)?.Gradient ?? {})
        # $Gradient | Out-Default | Write-Debug

    }

    process {
        $InputObject
        | ForEach-Object {
            $Message = $Config.Template -f @(
                $Config.Param1
                $Config.Param2
            )
            $colorSplat = @{
                ForegroundColor = $_
                BackgroundColor = $BackgroundColor ?? 'gray20'
            }

            $Message | Write-Color @colorSplat
        }
    }
}

if (! $experimentToExport) {
    # ...
}
