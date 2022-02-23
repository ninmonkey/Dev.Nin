#Requires -Version 7


if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_new-GrayColor'
    )
    $experimentToExport.alias += @(
        'Color->Gray' # _new-GrayColor

    )
}
<#
parent
    'C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin\public_experiment\current\module_GenerateDataColor.ps1'
    public_experiment/current/module_GenerateColor/generateTask_grays.ps1
#>

function _new-GrayColor {
    # // function c_gray {
    [Alias('Color->Gray')]
    param(
        # value [0, 100] , future: if not an int, assume  0..1.0
        [ValidateRange(0, 100)]
        [parameter(ValueFromPipeline)]
        [int]$Percent
        # [ValidateRange(0.0, 1.0)]
        # [parameter(ValueFromPipeline)]
        # [int]$Percent,
    )
    # process {

    process {
        $Ratio = $Percent / 100
        $Gray = 255 * $ratio
        [rgbcolor]::new($Gray, $Gray, $Gray)
    }

    # $x = .8 * 255
    # $c = [RgbColor]::new( $x, $x, $x)
    # $c | ForEach-Object tostring
}

if (! $experimentToExport) {
    # ...
}
