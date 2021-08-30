using namespace Management.Automation

$experimentToExport.function += @(
    'ShortenString'
)
$experimentToExport.alias += @(
    'AbbrStr', 'TruncateString'
)
function ShortenString {
    <#
    .synopsis
        shorten strings, if needed.
    #>
    [cmdletbinding(
        DefaultParameterSetName = 'StringFromPipe', PositionalBinding = $false)]
    [Alias('AbbrStr, TruncateString')]
    param(
        # Input text
        [Alias('Text', 'String')]
        [Parameter(
            Mandatory, ParameterSetName = 'StringFromPipe',
            ValueFromPipeline)]
        [Parameter(
            Mandatory, ParameterSetName = 'StringFromParam',
            Position = 0)]
        [string]$InputText,

        # Max number of chars
        [Parameter(
            ParameterSetName = 'StringFromPipe',
            Position = 0)]
        # [ValidateRange('NonNegative')]
        # [ValidateRange( ([Management.Automation.ValidateRangeKind]'nonnegative') ]
        [Parameter(
            ParameterSetName = 'StringFromParam',
            Position = 1)]
        [uint] # post, why exactly does the enum fail on parapset2 but not paramset 1?
        $MaxLength = 80
    )

    Process {
        $actualLen = $InputText.Length
        if ( [string]::IsNullOrWhiteSpace( $InputText ) ) {
            $InputText
            return
        }
        if ( $actualLen -le $MaxLength ) {
            $InputText
            return
        }
        else {
            $InputText.Substring(0, ( $MaxLength ) )
        }
    }
}
