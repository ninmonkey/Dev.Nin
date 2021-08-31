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
        🐒> ls ~ -Force
        | ?str 'vscode'

            Directory:C:\Users\cppmo_000

            Mode        LastWriteTime Length Name
            ----        ------------- ------ ----
            📁   11/21/2019   8:26 PM        .vscode
            📁   11/21/2020   9:46 AM        .vscode-insiders


    .outputs
          [string]

    #>
    [alias( '?Str', 'MatchStr', 'Where-String')]
    [CmdletBinding(PositionalBinding = $false, DefaultParameterSetName = '__AllParameterSets')]
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
        [Parameter(Mandatory, ParameterSetName = 'MatchOnProperty', Position = 1)]
        [string]$Property,

        # switch to requiring a full match
        [Parameter(Mandatory, Position = 0)]
        [string]$FullMatch
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
        try {
            if ($FullMatch) {
                $MatchPattern = @(
                    '^', $MatchPattern, '$'
                ) | Join-String
            }
            # "Regex: '$MatchPattern'" | Write-Debug
            $MatchPattern | Join-String -SingleQuote -op 'Regex: ' | Write-Debug

            $InputObject
            | Where-Object {
                switch ($PSCmdlet.ParameterSetName) {
                    'MatchOnProperty' {
                        Write-Debug "Match on Property '$Property'"
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
                        Write-Debug "Match on Text '$InputObject'"
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
        }
        catch {
            $PSCmdlet.WriteError( $_ )
        }
    }
    end {
        # I think null values enumerated will work?

    }
}
