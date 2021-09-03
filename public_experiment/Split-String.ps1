$experimentToExport.function += @(
    'Split-String'
)
$experimentToExport.alias += @(
    'SplitStr'
)

function Split-String {
    <#
    .synopsis
        simplify '-Split'ing Regex in the pipeline
    .description
       This is for cases where you had to use

       ... | ?{ $_ -Split $regex } | ...
    .notes
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
    .outputsj
          [object] as passed in

    #>
    [alias('SplitStr')]
    [CmdletBinding( PositionalBinding = $false, DefaultParameterSetName = '__AllParameterSets')]
    param(
        <# (copied 'Format-ControlChar')
        format unicode strings, making them safe.
            Null is allowed for the user's conveinence.
            allowing null makes it easier for the user to pipe, like:
            'gc' without -raw or '-split' on newlines
        #>
        [alias('Text', 'Lines')]
        [Parameter(
            Mandatory, ValueFromPipeline)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [string[]]$InputObject,

        [Parameter(
            Mandatory,
            ParameterSetName = 'UsingTemplate'
        )]
        [ValidateSet('Newline')]
        [string]$Type,

        # Split regex
        [Alias('Regex', 'Pattern')]
        [AllowEmptyString()]
        [Parameter(
            Mandatory,
            ParameterSetName = '__AllParameterSets',
            Position = 0
        )]
        [string]$SplitPattern
    )
    begin {
        try {
            if ($PSCmdlet.ParameterSetName -eq 'UsingTemplate') {
                $SplitPattern = switch ($Type) {
                    'Newline' {
                        '\r?\n'
                    }
                    default {
                        throw "unhandled: `$Type '$Type'"
                    }
                }
            }

            $SplitPattern | Join-String -SingleQuote -op 'Regex: ' | Write-Verbose
        }
        catch {
            $PSCmdlet.WriteError( $_ )
        }
    }
    process {
        try {

            $InputObject
            | ForEach-Object {
                $curObject = $_
                "Splitting: '$SplitPattern' with '$curObject'" | Write-Debug
                $curObject -split $SplitPattern
            }
        }
        catch {
            $PSCmdlet.WriteError( $_ )
        }
    }
    end {
    }
}
