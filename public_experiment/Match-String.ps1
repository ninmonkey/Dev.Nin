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

       ... | ?{ $_.Name -match $regex } | ...

    .notes
        should have the option to silently pipe nulls. ( Get-Content split enumerates some null values on extra newlines)

        todo:
            - [ ] future toggle may collect all strings at first, for multiline matching
                it makes less sense because this only filters objects, not mutate or multi-line regex
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
        [object]$InputObject,

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
        # $ParseMode = 'SingleLine'
        # if($ParseMode -eq 'FirstCollectAll') {
        #     $textList = [list[string]]::new()
        # }
    }
    process {
        # if($ParseMode -eq 'FirstCollectAll') {
        #     $InputText | ForEach-Object {
        #         $textList.Add( $_ )
        #     }
        #     return
        # }
        # else-per-line
        switch ($PSCmdlet.ParameterSetName) {
            'MatchOnProperty' {
                # if( [string]::IsNullOrWhiteSpace( $Property )) {
                if ($InputObject.$Property -match $MatchPattern) {
                    $true
                    return
                }
                else {
                    $false
                    return
                }
            }


            default {
                if ($InputObject -match $MatchPattern) {
                    $true
                    return
                }
                else {
                    $false
                    return
                }
            }
        }


    }
    end {
        # I think null values enumerated will work?

    }
}
