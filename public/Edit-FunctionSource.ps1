
function Edit-FunctionSource {
    <#
    .synopsis
        open script that declares funnction
    .notes
        - [ ] needs to be tested on binary imports
        - [ ] default to require confirm / should process

        - [ ] allow pipe from 'Get-Command'
        - [ ] and 'Alias'

            PS> Get-Command 'Get-Enum*' | Edit-FunctionSource
            PS> Alias 'Br' | Edit-FunctionSource
    #>

    # Function Name
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [Alias('Name')]
        [string]$FunctionName,

        # Return path only
        [Parameter()][switch]$PassThru
    )

    Process {
        $maybeFunc = $FunctionName
        $functionQuery = $FunctionName | ForEach-Object {
            $isAlias = (Get-Command $maybeFunc -ea SilentlyContinue).CommandType -eq 'alias'
            if ($isAlias) {
                $resolvedAlias = Get-Alias -ea SilentlyContinue $maybeAlias | ForEach-Object ResolvedCommand
                $resolvedAlias
            } else {
                Get-Command $FunctionName -ea SilentlyContinue
            }
        }
        <# this wasn't working properly

        $maybeAlias = $FunctionName
        $resolvedAlias = Get-Alias -ea SilentlyContinue $maybeAlias | ForEach-Object ResolvedCommand | ForEach-Object Name

        $queryForFunc = Get-ChildItem function: | Where-Object {
            ($_.Name -like $resolvedAlias) -or
            ($_.Name -like $FunctionName)
        }


        # $items = Get-ChildItem function:$FunctionName
        # or catch [ItemNotFoundException] {
        if ($queryForFunc.count -eq 0) {

            'No matches for: "{0}", "{1}"' -f @(
                $resolvedAlias, $functionName
            ) | Write-Error
            return

        }
        #>

        # $functionQuery



        Label 'Matches' $functionQuery.count | Write-Host
        if (! $functionQuery ) {
            Write-Error "FunctionNotFound: No matches for query: '$FunctionName'"
            return
        }

        # if ($PassThru) {
        #     $functionQuery
        #     return
        # }

        # foreach ($item in $functionQuery) {
        #     Label 'Open' $item.FullName
        # }

        if ($functionQuery.count -eq 1) {
            $autoOpen = $true
        }
        if ($PassThru) {
            $autoOpen = $false
        }

        # | ForEach-Object ScriptBlock | ForEach-Object Ast
        # | ForEach-Object Extent | ForEach-Object File | ForEach-Object {
        $functionQuery | ForEach-Object {
            $curCommand = $_
            $Path = $curCommand.ScriptBlock.Ast.Extent.File | Get-Item -ea Continue
            if ($Path) {
                # Label 'path' $Path
                $Path
            } else {
                H1 "shouldNeverException: curCommand = '$($curCommand.ScriptBlock.Ast.Extent.File)'`n`Unless it's non-text / assembly" | Write-Host
            }
            # $curCommand | ForEach-Object {
            #     $curPath = $_
            #     $curPath | Label 'found'
            # }

        }
        # $functionQuery | Get-Item -ea Continue | ForEach-Object {
        # code $_
    }


    # Get-Item function:'Write-ConsoleNewLine' | ForEach-Object ScriptBlock | ForEach-Object Ast | ForEach-Object Extent | ForEach-Object File


}

# Edit-FunctionSource 'Write-Conso'
if ($TempDebugTest) {
    # Edit-FunctionSource 'Write-ConsoleLabel' -ov 'FuncSourceRes'

    H1 'test1: as param'
    Edit-FunctionSource 'Write-ConsoleLabel' -ov 'FuncSourceRes1' -PassThru

    H1 'test2: as pipe'$FuncSourceRes | Join-String -SingleQuote -sep ', ' Name
    'ls', 'hr', 'Write-ConsoleHeader', 'Find-Type'
    | Edit-FunctionSource 'Write-ConsoleLabel' -ov 'FuncSourceRes2' -PassThru

    H1 'Test Results:'
    $FuncSourceRes1 | Join-String -SingleQuote -sep ', ' Name -OutputPrefix 'As Param = '
    $FuncSourceRes2 | Join-String -SingleQuote -sep ', ' Name -OutputPrefix 'As Pipe = '
    # $res[0]
    # Edit-FunctionSource 'Write-ConsoleLabefl'
    # Edit-FunctionSource 'hr'
}