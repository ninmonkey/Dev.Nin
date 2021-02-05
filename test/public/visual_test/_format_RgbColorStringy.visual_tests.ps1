Import-Module Dev.Nin -Force

Br 3; H1 'Test split' -fg red
$colors = Get-DevSavedColor -PassThru | ForEach-Object value
$colors | _format_HslColorString
$colors | _format_RgbColorString

Br 3; H1 'Test Combined' -fg red
$colors = Get-DevSavedColor -PassThru | ForEach-Object value | Select-Object -First 3
$colors | ForEach-Object { $_ | _format_HslColorString; $_ | _format_RgbColorString ; }

Br 3; H1 'Test Join-String Combined' -fg red
$colors = Get-DevSavedColor -PassThru | ForEach-Object value | Select-Object -First 3
$colors | ForEach-Object {
    @(
        $_ | _format_RgbColorString
        $_ | _format_HslColorString
        #      ) | Join-String -Separator '' -FormatString '{0,30:s}'
    ) | Join-String -
}

Br 3; H1 'Test manual Combined' -fg red
$colors = Get-DevSavedColor -PassThru | ForEach-Object value | Select-Object -First 3
$colors | ForEach-Object {
    @(
        $_ | _format_RgbColorString
        $_ | _format_HslColorString
        #      ) | Join-String -Separator '' -FormatString '{0,30:s}'
    ) | Join-String "`n`t"
}

H1 'compress'
$colors | _format_HslColorString -AlignMode Compress
H1 'perfect'
$colors | _format_HslColorString -AlignMode Perfect