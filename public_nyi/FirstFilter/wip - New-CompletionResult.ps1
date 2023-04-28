using namespace System.Management.Automation;
function New-CompletionResult {
    <#
    .synopsis
        Create a [System.Management.Automation.CompletionResult]
    .example
        PS> New-CompletionResult '--info' 'info' ParameterName 'List installed .net runtimes'

        CompletionText : --info
        ListItemText   : info
        ResultType     : ParameterName
        ToolTip        : List installed .net runtime
    #>
    param(
        [Parameter(
            Mandatory, Position = 0,
            HelpMessage = "Completion Result returned")]
        [string]$CompletionText,

        [Parameter(
            Mandatory, Position = 1,
            HelpMessage = 'Text displayed in the popup, usually equal to -CompletionText without a "--" prefix. ')]
        [string]$ListItemText,

        [Parameter(
            Mandatory, Position = 2,
            HelpMessage = "enum: [System.Management.Automation.CompletionResultType]
            note: it might need to be string for more compatability ?")]
        [CompletionResultType]$ResultType,

        [Parameter(
            Mandatory, Position = 3, HelpMessage = 'Verbose description shown when a single command is selected')]
        [string]$Tooltip
    )

    process {
        # Write-Debug "completion test: $($CompletionText.GetType())"

        # "New [CompletionResult]: $CompletionText, $ListItemText, $ResultType, $Tooltip" | Write-Debug


        $Result = [CompletionResult]::new( $CompletionText, $ListItemText, $ResultType, $Tooltip)
        $ResultType | Format-Table | Out-String -Width 99999 | Write-Debug

        $Result
    }
}

function findByName {
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Color
    )
}

# New-CompletionResult  -Debug
# hr
# [CompletionResult]::new( '/all', '/All', [CompletionResultType]::ParameterName, 'all' )
return

<# from SeeminglyScience #>
class EncodingArgumentCompleter : IArgumentCompleter {
    hidden static [string[]] $s_encodings

    static EncodingArgumentCompleter() {
        $allEncodings = [Text.Encoding]::GetEncodings()
        $names = [string[]]::new($allEncodings.Length + 7)
        $names[0] = 'ASCII'
        $names[1] = 'BigEndianUnicode'
        $names[2] = 'Default'
        $names[3] = 'Unicode'
        $names[4] = 'UTF32'
        $names[5] = 'UTF7'
        $names[6] = 'UTF8'

        for ($i = 0; $i -lt $allEncodings.Length; $i++) {
            $names[$i + 7] = $allEncodings[$i].Name
        }

        [EncodingArgumentCompleter]::s_encodings = $names
    }

    [IEnumerable[CompletionResult]] CompleteArgument(
        [string] $commandName,
        [string] $parameterName,
        [string] $wordToComplete,
        [CommandAst] $commandAst,
        [IDictionary] $fakeBoundParameters) {
        $results = [List[CompletionResult]]::new(<# capacity: #> 4)
        foreach ($name in $this::s_encodings) {
            if ($name -notlike "$wordToComplete*") {
                continue
            }

            $results.Add(
                [CompletionResult]::new(
                    <# completionText: #> $name,
                    <# listItemText:   #> $name,
                    <# resultType:     #> [CompletionResultType]::ParameterValue,
                    <# toolTip:        #> $name))
        }

        return $results.ToArray()
    }
}
