# $StringModule_DontInjectJoinString = $true # https://github.com/FriedrichWeinmann/string/#join-string-and-powershell-core

$experimentToExport.function += @(
    'Match-String'
)
$experimentToExport.alias += @(

    '?Str', 'MatchStr', 'Where-String'
)
function Match-String {
    <#
    .synopsis
        simplify matching regex in the pipeline
    .description
       This is for cases where you had to use

       ... | ?{ $_ -match $regex } | ...

       or

       ... | ?{ $_.Property -match $regex } | ...

    .notes
        should have the option to silently pipe nulls. ( Get-Content split enumerates some null values on extra newlines)

        todo:
            - [ ] Should it write-error when input is not a string?
    .example
          .
    .outputs
          [string]

    #>
    [alias( '?Str', 'MatchStr', 'Where-String')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Parametertype: Use a [object] so it can write warnings when a non-string type maybe accidentally was used?
        #   array or not? that can change how patterns will match
        #   when there's only access to one line
        <# (copied 'Format-ControlChar')
        format unicode strings, making them safe.
            Null is allowed for the user's conveinence.
            allowing null makes it easier for the user to pipe, like:
            'gc' without -raw or '-split' on newlines
        #>
        [alias('Text', 'Lines')]
        [Parameter(
            # ParameterSetName = 'MatchRawString',
            Mandatory, ValueFromPipeline)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [string[]]$InputText,

        # Match regex
        [Alias('Regex', 'Pattern')]
        [AllowEmptyString()]
        [Parameter(
            # ParameterSetName = 'MatchRawString',
            Mandatory, Position = 0)]
        [string]$MatchPattern,

        # Filter on properties instead of raw string
        [Parameter(Mandatory, ParameterSetName = 'MatchOnProperty')]
        [string]$Property
    )
    begin {
        $textList = [list[string]]::new()
    }
    process {
        $InputText | ForEach-Object {
            $textList.Add( $_ )
        }
    }
    end {
        # I think null values enumerated will work?
        $textList | Where-Object {
            $curLine = $_
            Write-Debug "match regex '$MatchPattern' on line '$curLine'"
            if($curLine -match $MatchPattern) {
                $curLine
            }
        }
    }
}
