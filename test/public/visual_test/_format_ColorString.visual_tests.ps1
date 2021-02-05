Import-Module dev.nin -Force -WarningAction Ignore; br 4;

Label -fg red 'Dev.Nin\test\public\visual_test\_format_HslColorStringy.visual_tests.ps1'
h1 '_format_HslColorString ''-Align Perfect'''
$colors | _format_HslColorString Perfect
h1 '_format_HslColorString ''-Align Compress'''
$colors | _format_HslColorString Compress

h1 '_format_HslColorString ''-NoColor'''
$colors | _format_HslColorString -NoColor
h1 '_format_HslColorString ''-NoColor -Align Compress'''
$colors | _format_HslColorString -NoColor -Align Compress