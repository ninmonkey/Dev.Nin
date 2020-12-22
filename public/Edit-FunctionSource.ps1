
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
        $items = Get-ChildItem function:$FunctionName
        # drill down
        | ForEach-Object ScriptBlock | ForEach-Object Ast | ForEach-Object Extent | ForEach-Object File
        | Get-Item -ErrorAction Continue

        Label 'Matches' $items.count

        if ($PassThru) {
            $items
            return
        }

        foreach ($item in $items) {
            Label 'Open' $item.FullName
        }


        # Get-Item function:'Write-ConsoleNewLine' | ForEach-Object ScriptBlock | ForEach-Object Ast | ForEach-Object Extent | ForEach-Object File

    }
}

# Edit-FunctionSource 'Write-ConsoleNewline'