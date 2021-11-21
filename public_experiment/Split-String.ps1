$experimentToExport.function += @(
    'Split-String'
)
$experimentToExport.alias += @(
    'SplitStr'
    'SplitNewline' # smart aliases
)

function Split-String {
    <#
    .synopsis
        simplify '-Split'ing Regex in the pipeline
    .description
       This is for cases where you had to use

       ... | ?{ $_ -Split $regex } | ...
    .notes

        SplitStyle 'ControlChar' does not include: cr, newline, space, tab    '[\x00-\x1f-[\x0a\x20\x0d\x09]]+' but 'ControlCharAll' does
                    # 0xa  # newline
                    # 0x20 # space
                    # 0xd  # cr
                    # 0x9  # tab


        - [ ] maybe list of split, to allow

                Split-Str $x '\r?\n', '\d+'

            to mean

                $x -split '\r?\n' -split '\d+'

        - [ ] see other -split call signatures
            <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_split?view=powershell-7.1#syntax>

        -Split <String>
        -Split (<String[]>)
        <String> -Split <Delimiter>[,<Max-substrings>[,"<Options>"]]
        <String> -Split {<ScriptBlock>} [,<Max-substrings>]

    .example
       .
    .link
        Dev.Nin\Join-StringStyle
    .outputs
          [object] as passed in

    #>
    [alias('SplitStr', 'SplitNewline')]
    [CmdletBinding( PositionalBinding = $false,
        DefaultParameterSetName = 'UsingTemplate' #'UsingRegex'
    )]
    param(
        <# (copied 'Format-ControlChar')
        format unicode strings, making them safe.
            Null is allowed for the user's conveinence.
            allowing null makes it easier for the user to pipe, like:
            'gc' without -raw or '-split' on newlines
        #>
        [alias('Text')]
        [Parameter(
            Mandatory, ValueFromPipeline)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        # [string[]]$InputObject,
        [string]$InputObject,

        # split styles built-in
        [Alias('Type', 'Template', 'As')]
        [Parameter(
            Mandatory, ParameterSetName = 'UsingTemplate', Position = 0
        )]
        [ValidateSet('Newline', 'Csv', 'WhiteSpace', 'Tab', 'Word', 'NonWord', 'ControlChar', 'ControlCharAll')]
        [string]$SplitStyle,

        # Split regex
        [Alias('Pattern')]
        [AllowEmptyString()]
        [ValidateNotNull()]
        [Parameter(
            Mandatory, ParameterSetName = 'UsingRegex',
            Position = 0
        )]
        [string]$Regex
    )
    begin {
        # try {
        # $UsingTemplateMode = ($PSCmdlet.MyInvocation.InvocationName -eq 'UsingTemplate')

        # switch ($PSCmdlet.MyInvocation.InvocationName) {
        #     'SplitNewline' {
        #         # $PSCmdlet.ParameterSetName = 'UsingTemplate'
        #         # $SplitStyle = 'Newline'
        #     }
        #     default {}
        # }


        if ($PSCmdlet.ParameterSetName -eq 'UsingTemplate') {
            $SplitPattern = switch ($SplitStyle) {
                'Newline' {
                    '\r?\n'
                }
                'Csv' {
                    ',\s*'
                }
                'WhiteSpace' {
                    # /s+ is equiv to:'[\r\n\t\f\v ]+'
                    # /w+ is equiv to:'[a-zA-Z0-9_]+'
                    '\s+'
                }
                'Tab' {

                    '[\x09\x0b]+' # vert + horizontal tabs
                }
                'Word' {
                    '\w+'
                }
                'NonWord' {
                    '\W+'
                }
                'ControlChar' {
                    '[\x00-\x1f-[\x0a\x20\x0d\x09]]+'
                    # 0xa  # newline
                    # 0x20 # space
                    # 0xd  # cr
                    # 0x9  # tab
                    # 0xb  # vert tab
                }
                'ControlCharAll' {
                    '[\x00-\x1f]+'
                }
                default {
                    throw "unhandled: `$SplitStyle '$SplitStyle'"
                }
            }
        } elseif ($PSCmdlet.ParameterSetName -eq 'UsingRegex') {
            #..
            $SplitPattern = $Regex
        }

        $SplitPattern | Join-String -SingleQuote -op 'Regex: ' | Write-Verbose
        # }
        # catch {
        #     $PSCmdlet.WriteError( $_ )
        # }
    }
    process {

        $InputObject -split $SplitPattern
        # $InputObject | Join-String -DoubleQuote
        # try {

        # $InputObject
        # | ForEach-Object {
        # $curObject = $_
        # "Splitting: '$SplitPattern' with '$curObject'" | Write-Debug
        # $curObject -split $SplitPattern
        # }
        #
        # }
        # catch {
        #     $PSCmdlet.WriteError( $_ )
        # }
    }
    end {
    }
}
