using namespace Management.Automation

$experimentToExport.function += @(
    'ShortenString'
    'ShortenStringJoin'
)
$experimentToExport.alias += @(
    'AbbrStr'
    'TruncateString'
)

function ShortenStringJoin {
    <#
    .synopsis
        like ShortenString, except collapses newlines into one line
    .example
        $someExteption.ToString() | SHortenStringJoin -CollapseWhiteSpace
    .link
        Dev.Nin\ShortenString
    .link
        Dev.Nin\ShortenStringJoin
    #>
    [cmdletbinding(PositionalBinding = $false)]
    param(
        <# InputLine used to be:
        [alias('Text')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string[]]$InputLine,
        #>

        # allows extra empty values, to simplify logic when caller is piping
        # this was updated to match ShortenString's param type
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [alias('Text')]
        [string[]]$InputLine,

        # truncate at
        [parameter(Position = 1)]
        [int]$MaxLength, # = 120,

        # CollapseSpace
        [Alias('Minify')]
        [Parameter()][switch]$CollapseWhiteSpace
    )
    begin {
        $MaxLength = if ($MaxLength -eq 0) {
            [console]::WindowWidth - 1
        }
        else {
            $maxLength
        }
        $Str = @{
            JoinNewline = ' ◁ ' | New-Text -fg 'gray60' | ForEach-Object tostring            # '… …◁'
        }
        $JoinSep ??= $Str.JoinNewline
    }
    process {

        $accum = $InputLine -split '\r?\n'
        | Join-String -sep $JoinSep
        if ($CollapseWhiteSpace) {
            $accum = $accum -replace '(\s)+', '$1'
        }

        $accum = $accum | ShortenString -MaxLength $MaxLength
        $accum
    }
}

function ShortenString {
    <#
    .synopsis
        shorten strings, if needed.
    .link
        Dev.Nin\ShortString
    .link
        Dev.Nin\ShortStringJoin
    #>
    [cmdletbinding(
        DefaultParameterSetName = 'StringFromPipe', PositionalBinding = $false)]
    [Alias('AbbrStr, TruncateString')]
    param(

        <# (copied 'Format-ControlChar')
        Why did I use: these?
            [AllowEmptyString], [AllowEmptyCollection], [AllowNull]


        Null is allowed for the user's conveinence.
        allowing null makes it easier for the user to pipe, like:
            'gc' without -raw or '-split' on newlines
            will normally pipe empty or empty-whitespace
        #>
        # Input text
        [Alias('Text')]
        [Parameter(
            Mandatory, ParameterSetName = 'StringFromPipe',
            ValueFromPipeline)]
        [Parameter(
            Mandatory, ParameterSetName = 'StringFromParam',
            Position = 0)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
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
        $MaxLength, # = 120 80,

        # truncate the end or start of the string?
        [Parameter()][switch]$FromEnd
    )
    begin {
        $MaxLength = if ($MaxLength -eq 0) {
            [console]::WindowWidth - 1
        }
        else {
            $maxLength
        }
    }

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
            if ($FromEnd) {
                $InputText.Substring( $inputText.Length - $MaxLength)
            }
            else {
                $InputText.Substring(0, ( $MaxLength ) )
            }
        }
    }
}
