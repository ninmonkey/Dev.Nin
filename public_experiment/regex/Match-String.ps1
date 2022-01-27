$experimentToExport.function += @(
    'Match-String'
)
$experimentToExport.alias += @(

    '?Str', 'MatchStr', 'Where-String'
)
function __test-Match {
    # regex match, or -notmatch wrapper
    param(
        # Input object (to auto coerce as string, or not)
        [Parameter(Mandatory, Position = 0)]
        [object]$InputObject,

        # Regex
        [Parameter(Mandatory, Position = 1)]
        [AllowEmptyString()]
        [string]$Regex,

        # use -match (or -notmatch)
        [Parameter()]
        [switch]$NotMatching
    )
    throw "NYI: '$PSCommandPath'"

}
function Match-String {
    <#
    .synopsis
        simplify matching regex in the pipeline
    .description

       todo: debug, is not working

       This is for cases where you had to use

       ... | ?{ $_ -match $regex } | ...

       or

       ... | ?{ $_.Name -match $regex } | ...

       Function allows you to use raw-text matching on properties, without converting
        the pipeline to raw text. It leaves the object intact.

    .notes
        - Should It allow null without opt-ing in?
            for dealing with piped in raw text, yes, allow should not throw
        - if compared to an object, then, null should require an opt-in

        - $null inputs are ignored ( Get-Content split enumerates some null values on extra newlines)

        todo:
        future:
            - [ ] multi-line regex?
            - [ ] future toggle may collect all strings at first, for multiline matching
                it makes less sense because this only filters objects, not mutate or multi-line regex
    .example
        # This example regex is just 'json'
        # the regex's are able to be simplified because
        #   1] Easily opt-in to anchors with -Start/-Ends
        #   2] You can match properties, like 'extension' or 'name'
        # using -starts which is more natural
        # using property 'Name' instead of 'FullName'
        🐒> ls ~ -Directory -Depth 2 # normally returns 2,033 files
        | ?str .vscode -Starts Name

    .example
        🐒> ls ~ | ?str json -Ends
    .example
        🐒> gi fg:\red | iprop $c | % Name | ?str -not 'ps' -begin
    .example
        🐒> ls ~ -Force
        | ?str 'vscode'

            Directory:C:\Users\<user>

            Mode        LastWriteTime Length Name
            ----        ------------- ------ ----
            📁   11/21/2019   8:26 PM        .vscode
            📁   11/21/2020   9:46 AM        .vscode-insiders
    .example
        # This time only on a specific property, the name.

        🐒> ls $Env:APPDATA
        | ?Str code Name

            Directory:C:\Users\<user>\AppData\Roaming


            Mode        LastWriteTime Length Name
            ----        ------------- ------ ----
            📁    8/30/2021   2:58 PM        Code
            📁    8/30/2021   7:44 PM        Code - Insiders
            📁   12/14/2020   5:14 PM        ICSharpCode
            📁    2/16/2019   4:46 PM        Visual Studio Code
            📁   12/12/2020   6:27 PM        vscode-mssql

    .example
        # full match still allows wildcards

        🐒> ls $Env:APPDATA | ?Str code.* Name -FullMatch

            Directory:C:\Users\<user>\AppData\Roaming


            Mode        LastWriteTime Length Name
            ----        ------------- ------ ----
            📁    8/30/2021   2:58 PM        Code
            📁    8/30/2021   7:44 PM        Code - Insiders
    .example
        # Now only find fullmatches

            🐒> ls $Env:APPDATA | ?Str code Name -FullMatch

                    Directory:C:\Users\<user>\AppData\Roaming


            Mode        LastWriteTime Length Name
            ----        ------------- ------ ----
            📁    8/30/2021   2:58 PM        Code
    .example
        # EnvIronment variable
        🐒> ls env: | ?str 'nin' -Starts Key

            Name             Value
            ----             -----
            Nin_Dotfiles     C:\Users\<user>\Documents\2021\dotfiles_git
            Nin_Home         C:\Users\<user>\Documents\2021
            Nin_PSModulePath C:\Users\<user>\Documents\2021\Powershell\My_Github
            NinNow           C:\Users\<user>\Documents\2021

        🐒> ls env: | ?str 'nin' Value

            Name                      Value
            ----                      -----
            COMPUTERNAME              NIN8
            LOGONSERVER               \\NIN8
            Path                      C:\Program Files\PowerShell\7;C:\Program Files\Ala
            USERDOMAIN                NIN8
            USERDOMAIN_ROAMINGPROFILE NIN8


        🐒> ls env: | ?str 'nin' Value -Starts

            Name                      Value
            ----                      -----
            COMPUTERNAME              NIN8
            USERDOMAIN                NIN8
            USERDOMAIN_ROAMINGPROFILE NIN8

        .outputs
            [object] as passed in

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

        # Both ends must match. This is equivalent to using both -Begins and -Ends
        [Parameter()][switch]$FullMatch,

        # # Uses -notMatch operator vs -match
        # [Alias('Not')]
        # [Parameter()][switch]$NotMatching,

        # Pattern beginning must match. It adds '^' to the start of the pattern
        [alias('Starts')]
        [Parameter()][switch]$Begins,


        # Pattern ending must match. It adds '$' to the end of the pattern
        # You can still use patterns like 'dog.*' -Ends
        # to get 'dog.*$'
        [Alias('Stops')]
        [Parameter()][switch]$Ends

        # # colorize matches? like using "rg 'a|b|c|$'"
        # [Parameter()][switch]$ColorizeMatches

    )
    begin {
        $MatchPattern = @(
            ($Begins -or $FullMatch) ? '^' : $null
            $MatchPattern
            ($Ends -or $FullMatch) ? '$' : $null
        ) | Join-String

        $PSBoundParameters | Format-Table | Out-String | Write-Verbose

        # "FullMatch? '$FullMatch'" | Write-Debug
        # $MatchPattern | Join-String -SingleQuote -op 'Regex: ' | Write-Debug
        $MatchPattern | Join-String -SingleQuote -op 'Regex: ' | Write-Verbose
        # Write-warning 'Colorize NYI' -Category NotImplemented
    }
    process {
        # try { #remove catch
        $InputObject
        | Where-Object {
            switch ($PSCmdlet.ParameterSetName) {
                'MatchOnProperty' {
                    Write-Debug "Match on Property '$Property'"
                    if ($InputObject.$Property -match $MatchPattern) {
                        $true
                        return
                    } else {
                        $false
                        return
                    }
                }
                default {
                    Write-Debug "Match on Text '$InputObject'"
                    if ($InputObject -match $MatchPattern) {
                        $true
                        return
                    } else {
                        $false
                        return
                    }
                }
            }
        }
        # } catch {
        # $PSCmdlet.WriteError( $_ ) # probably the problem here <--
        # }
    }
    end {
        # I think null values enumerated will work?

    }
}
