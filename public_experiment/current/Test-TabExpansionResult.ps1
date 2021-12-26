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
        [Parameter(Position = 1)]
        [int]$CursorColumn,

        # options
        [hashtable]$Options = $Null,

        # hashtable-like/flat
        [Alias('Full')]
        [switch]$PassThru
    )
    if ($CursorColumn -lt 0) {
        $CursorColumn = $CursorColumn + $CommandText.Length
    }
    if (! $CursorColumn) {
        $CursorColumn = $CommandText.Length
    }

    # pretty print


    $id = 0
    if ($Passthru) {

        TabExpansion2 -inputScript $CommandText -cursorColumn $CursorColumn -options $null
        | Add-Member -NotePropertyName 'Id' ($id++) -PassThru
        # | Add-Member -NotePropertyName 'Query' $CommandText -PassThru
        # | Add-Member -NotePropertyName 'PSTypeName' 'dev.TabExpandResultFull' -PassThru

    } else {

        $query = TabExpansion2 -inputScript $CommandText -cursorColumn $CursorColumn -options $null
        $query | ForEach-Object CompletionMatches
        | ForEach-Object {
            $mergeOther = $_ | New-HashtableFromObject
            $meta = @{
                PSTypeName = 'dev.TabExpandResult'
                Query      = $CommandText
                Id         = $id++
            }
            [pscustomobject]( Join-HashTable $meta $mergeOther )
        }



        # | Add-Member -NotePropertyName 'Query' $CommandText -PassThru
        # | Add-Member -NotePropertyName 'Id' -NotePropertyValue ($id++) -PassThru
        # | Add-Member -NotePropertyName 'PSTypeName' 'dev.TabExpandResult' -PassThru

    }

    # "Id: $id"
}
<#
example 1 returns files
Test-TabExpansionResult 'ls . -f' 1
#>
@'
left off:
    type should auto show as table

'@ | Write-Warning

if (! $experimentToExport) {
    @(
        dev->TestTabExpand -CommandText 'git st'
        hr
        dev->TestTabExpand -CommandText 'git s' ) | Format-Table -AutoSize

    return

    dev->TestTabExpand -CommandText 'git s' | Format-Table -AutoSize
    $res = dev->TestTabExpand -CommandText 'git s' | Format-Table -AutoSize
    $res.count
    if ($false) {
        0..3 | ForEach-Object {
            $CurColumn = $_
            $result = Test-TabExpansionResult 'ls . -f' -CursorColumn $CurColumn
            $result | Format-Table
            $x = 1 + 34
            $CompleterMatch = $result | Select-Object -ExpandProperty 'CompletionMatches' | Tee-Object -var 'LastCompleterMatch'
            $CompleterMatch
        }
    }

    h1 'fin'


    # ...
    $CommandText = 'git s'
    $res = TabExpansion2 -inputScript $CommandText -cursorColumn $CursorColumn -options $null
    $CursorColumn = $null
    $res.count
    $res | ForEach-Object {
        $merge = $_ | New-HashtableFromObject
        $meta = @{
            PSTypeName = 'dev.TabExpandResult'
            Query      = $CommandText
            Id         = $id++
        }
        [pscustomobject]( Join-HashTable $meta $Merge )
    }
    # | ForEach-Object CompletionMatches
    # | Add-Member -NotePropertyName 'Query' $CommandText -PassThru
    # | Add-Member -NotePropertyName 'Id' -NotePropertyValue ($id++) -PassThru
    # | Add-Member -NotePropertyName 'PSTypeName' 'dev.TabExpandResult' -PassThru
}
