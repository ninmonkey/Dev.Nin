#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Test-TabExpansionResult'
    )
    $experimentToExport.alias += @(
        'dev->TestTabExpand'
    )
}

function Test-TabExpansionResult {
    <#
    .synopsis
        formats results from tab completion
    .example

    🐒> dev->TestTabExpand 'ls'
    | ft -AutoSize ResultType, ListItemText, CompletionText, ToolTip


        ResultType ListItemText CompletionText ToolTip
        ---------- ------------ -------------- -------
           Command ls           ls             Get-ChildItem
           Command ls.exe       ls.exe         C:\Program Files\Git\usr\bin\ls.exe
           Command LsaIso.exe   LsaIso.exe     C:\Windows\system32\LsaIso.exe
           Command lsass.exe    lsass.exe      C:\Windows\system32\lsass.exe
           Command lsattr.exe   lsattr.exe     C:\Program Files\Git\usr\bin\lsattr.exe
           Command Lsd          Lsd            …
           Command LsExt        LsExt          Find-FileType
           Command lsFunc       lsFunc         Indented.ScriptAnalyzerRules\Get-FunctionInfo
           Command LsGit        LsGit          Find-GitRepo
           Command LsNew        LsNew          Format-ChildItemSummary
    .example
        PS> Test-TabExpansionResult 'ls ' 1
        | % CompletionMatches | fl
    .notes
        todo:
            cleanup/rewrite

    invoke
        🐒> gcm TabExpansion2 | Get-ParameterInfo  | Ft -au

            ParameterSet: ScriptInputSet

            Name         Aliases Mandatory Position Type
            ----         ------- --------- -------- ----
            inputScript          True      0        System.String
            cursorColumn         True      1        System.Int32

            ParameterSet: AstInputSet

            Name             Aliases Mandatory Position Type
            ----             ------- --------- -------- ----
            ast                      True      0        System.Management.Automation.Language.Ast
            tokens                   True      1        System.Management.Automation.Language.Token[]
            positionOfCursor         True      2        System.Management.Automation.Language.IScriptPosition

            ParameterSet: ScriptInputSet

            Name    Aliases Mandatory Position Type
            ----    ------- --------- -------- ----
            options         False     2        System.Collections.Hashtable

            ParameterSet: AstInputSet

            Name    Aliases Mandatory Position Type
            ----    ------- --------- -------- ----
            options         False     3        System.Collections.Hashtable


    see also:
        gcm tabExpansion2 (from builtins)

        gcm TabExpansion2 | Get-ParameterInfo

            [ArgumentCompleterAttribute]
            [System.Management.Automation.CommandCompletion]
            [System.Management.Automation.Language.Ast]
            [System.Management.Automation.Language.Token]
            [System.Management.Automation.Language.IScriptPosition]
    .link
        [ArgumentCompleterAttribute]
    .link
        [System.Management.Automation.CommandCompletion]
    .#>
    [alias('dev->TestTabExpand')]
    [OutputType([System.Management.Automation.CommandCompletion])]
    param(
        # string that user would have entered
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$CommandText,

        # where cursor is in the command string?
        # Defaults to the end of the string if not set
        [Parameter(Position = 1)]
        [int]$CursorColumn,

        # options
        [hashtable]$Options = $Null,

        # preserve all metadata
        [switch]$Full
    )
    if ($CursorColumn -lt 0) {
        $CursorColumn = $CursorColumn + $CommandText.Length
    }
    if (! $CursorColumn) {
        $CursorColumn = $CommandText.Length
    }

    $Query = TabExpansion2 -inputScript $CommandText -cursorColumn $CursorColumn -options $null
    if (! $Full) {
        $Query = $Query.'CompletionMatches'
    }

    $id = 0
    $query | ForEach-Object {
        $mergeOther = $_ | New-HashtableFromObject
        $meta = @{
            PSTypeName = 'dev.TabExpandResult'
            Query      = $CommandText
            Id         = $id++
        }
        [pscustomobject]( Join-HashTable $meta $mergeOther )
    }
}

@'
left off:
    type should auto show as table

    'Todo
    [ ] -> Ensure ResultType is visible as  table column ;
    [ ] - If ListItemText and Completion are equal, visually DIM the text on display
'@ | Write-Warning


@'
🐒> Test-TabExpansionResult '*json*' | ft -AutoSize ListItemText, CompletionTex

        ListItemText      CompletionText           Query    ResultType ToolTip
        ------------      --------------           -----    ---------- -------
        manpage.json      .\manpage.json           *json* ProviderItem C:\Users\cppmo_0
        ConvertFrom-Json  ConvertFrom-Json         *json*      Command …
        ConvertTo-Json    ConvertTo-Json           *json*      Command …
        Format-PrettyJson Format-PrettyJson        *json*      Command …
'@

if (! $experimentToExport) {
    # @(
    #     dev->TestTabExpand -CommandText 'git st'
    #     hr
    #     dev->TestTabExpand -CommandText 'git s' ) | Format-Table -AutoSize

    # return

    # dev->TestTabExpand -CommandText 'git s' | Format-Table -AutoSize
    # $res = dev->TestTabExpand -CommandText 'git s' | Format-Table -AutoSize
    # $res.count
    # if ($false) {
    #     0..3 | ForEach-Object {
    #         $CurColumn = $_
    #         $result = Test-TabExpansionResult 'ls . -f' -CursorColumn $CurColumn
    #         $result | Format-Table
    #         $x = 1 + 34
    #         $CompleterMatch = $result | Select-Object -ExpandProperty 'CompletionMatches' | Tee-Object -var 'LastCompleterMatch'
    #         $CompleterMatch
    #     }
    # }

    # h1 'fin'


    # # ...
    # $CommandText = 'git s'
    # $res = TabExpansion2 -inputScript $CommandText -cursorColumn $CursorColumn -options $null
    # $CursorColumn = $null
    # $res.count
    # $res | ForEach-Object {
    #     $merge = $_ | New-HashtableFromObject
    #     $meta = @{
    #         PSTypeName = 'dev.TabExpandResult'
    #         Query      = $CommandText
    #         Id         = $id++
    #     }
    #     [pscustomobject]( Join-HashTable $meta $Merge )
    # }
    # # | ForEach-Object CompletionMatches
    # # | Add-Member -NotePropertyName 'Query' $CommandText -PassThru
    # | Add-Member -NotePropertyName 'Id' -NotePropertyValue ($id++) -PassThru
    # | Add-Member -NotePropertyName 'PSTypeName' 'dev.TabExpandResult' -PassThru
}
