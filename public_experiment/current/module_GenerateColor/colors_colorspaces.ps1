#Requires -Version 7


if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_dumpColorspace'
        '_dumpColorComplement'
    )
    $experimentToExport.alias += @(
        'Color->Colorspace' # _dumpColorspace

    )
}
<#
parent
    'C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin\public_experiment\current\module_GenerateDataColor.ps1'
    public_experiment/current/module_GenerateColor/generateTask_grays.ps1
#>

function _dumpColorComplement {
    param(
        [parameter(Position = 0, Mandatory, ValueFromPipeline)]
        $InputObject

    )
    process {
        foreach ($contrast in $true, $false) {
            foreach ($BW in $true, $false) {

                [pscustomobject]@{
                    HighContrast  = $Contrast
                    BlackAndWhite = $BW
                    Original      = $InputObject
                    Complement    = $InputColor.GetComplement($contrast, $black)
                }
            }
        }
    }
}

function _dumpColorspace {
    # // function c_gray {
    <#
    .synopsis
        dump color space conversions
    .notes
        see also:
            🐒> fg:\ | % tostring
                [PoshCode.Pansies.Provider.RgbColorProviderRoot]


    .example
            gi bg:\ | Color->Colorspace -ea break
            ls bg: | Get-Random -Count 1 | Color->Colorspace -ea break
    .example
            $r | Iter->Prop | sort TypeNameOfValue, Name
            | Ft TypeNameOfValue, Name, Value, *  -AutoSize
    .example
        $InputObject | Iter->Prop
        | ft name, Value, typenameofvalue, @{n='real'; e={$_.value.GetType().Name} }

    .link
        PoshCode.Pansies.RgbColor
    .link
        PoshCode.Pansies.ColorSpaces.Rgb
    .link
        PoshCode.Pansies.ColorSpaces.ColorSpace
    #>
    [Alias('Color->Colorspace')]
    param(

        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $InputObject
    )
    begin {
        if ($Help) {
            $__helpString = @'
[RgbColor].PsTypeNames
    - [PoshCode.Pansies.RgbColor]
    - [PoshCode.Pansies.ColorSpaces.Rgb]
    - [PoshCode.Pansies.ColorSpaces.ColorSpace]
'@
        }

        function __processColor {
            <#
            .synopsis
                inspect color instance

            #>
            param(
                # input object
                [Alias('InputObject', 'Color')]
                [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
                [PoshCode.Pansies.RgbColor]$ColorObject
            )
            process {
                $meta = @{
                    # can any of these throw?
                    PSTypeName           = 'DevNin.ColorSpaceResult'
                    # templated: to<IColorSpace>
                    #    $red.to<T>()
                    Original             = $InputObject
                    Hex                  = $InputObject.ToString()
                    'ToString'           = $InputObject.ToString()
                    'ToStringOrdinal'    = $InputObject.ToString($True)
                    Cmyk                 = $red.ToCmyk()
                    # 'To' = $InputObject.To()
                    'ToCmy'              = $InputObject.ToCmy()
                    'ToCmyk'             = $InputObject.ToCmyk()
                    'ToHsb'              = $InputObject.ToHsb()
                    'ToHsl'              = $InputObject.ToHsl()
                    'ToHsv'              = $InputObject.ToHsv()
                    'ToHunterLab'        = $InputObject.ToHunterLab()
                    'ToLab'              = $InputObject.ToLab()
                    'ToLch'              = $InputObject.ToLch()
                    'ToLuv'              = $InputObject.ToLuv()
                    'ToRgb'              = $InputObject.ToRgb()

                    'ToVtEscapeSequence' = $InputObject.ToVtEscapeSequence()
                    'ToXyz'              = $InputObject.ToXyz()
                    'ToYxy'              = $InputObject.ToYxy()
                }
                [pscustomobject]$meta
            }
        }
    }
    process {

        <#
        other types
            Management.Automation.ProviderInfo
        #>

        Write-Debug "=> type: '$($InputObject.GetType().FullName)'"
        switch ($InputObject.GetType().Name ) {
            'PoshCode.Pansies.Provider.RgbColorProviderRoot' {
                break
            }
            'PoshCode.Pansies.Provider.RgbColorDrive' {
                # 'Input is not a color, is a [PoshCode.Pansies.Provider.RgbColorDrive]'
                break
            }
            'PoshCode.Pansies.RgbColor' {
                __processColor $InputObject
                break
            }
            default {
                Write-Error "Unhandled type: '$($InputObject.GetType().FullName)'"
            }
        }

    }

}

if (! $experimentToExport) {
    # ...
}
