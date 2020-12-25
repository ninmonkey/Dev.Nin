function Out-Fzf {
    <#
    .synopsis
        uses commandline app 'fzf' similar to 'out-gridview'
    .description
        a simple multi-item selection for the console without the extra features of 'Out-ConsoleGridView'
    .notes
        selected items are returned **in-order** that they are selected in 'fzf'
    .example
        PS>
    .notes
        .
    #>
    param (
        # show help
        [Parameter()][switch]$Help,

        # Multi select
        [Parameter()][switch]$MultiSelect,

        # Prompt title
        [Parameter()]
        [String]$PromptText,

        # main piped input
        # Docstring
        [Parameter(
            Mandatory, ValueFromPipeline)]
        [string[]]$InputText # future: support PSObjects with property '.Name' or ToString


        # future: Maximum selection: --multi[=max]
        # [Parameter()][int]$MaxMultiSelect
    )

    begin {
        $debugMeta = @{}

        if ($Help) {
            '<https://github.com/junegunn/fzf#tips> and ''fzf --help'''
            break
        }
        $binFzf = Get-Command 'fzf' -CommandType Application # -ErrorAction Stop

        $inputList = [list[string]]::New()

        $fzfArgs = @()

        if ( ! [String]::IsNullOrWhiteSpace(  $PromptText  ) ) {
            $fzfArgs += ("--prompt={0}" -f $PromptText)
        }

        if ($MultiSelect) {
            $fzfArgs += '--multi'
        }

        $debugMeta.FzfArgs = $fzfArgs
    }
    process {

        foreach ($Line in $InputText) {
            $inputList.add( $Line )
        }

        # $fromPipe = 0..10
        # $finalCommand = {

        # $fromPipe
        # | & $binFzf @fzfArgs

        # }

        # $selection = 0..10
        # | fzf
        # $selection

        # Write-Information

    }
    end {

        $Selection = $inputList | & $binFzf @fzfArgs
        $Selection

        # style 1]
        # $debugMeta.InputListCount = $inputList.Count
        # $debugMeta.SelectionCount = $Selection.Count
        # $debugMeta.Selection = $Selection | Join-String -sep ', ' -SingleQuote | Label 'Selection'

        # style 2]
        # style wise, this looks cleaner, but throws on duplicate key names
        $debugMeta += @{
            InputListCount = $inputList.Count
            SelectionCount = $Selection.Count
            Selection      = $Selection | Join-String -sep ', ' -SingleQuote | Label  'Selection'

        }
        $debugMeta | Format-HashTable -Title '@debugMeta' | Write-Debug
    }
}

if ($false) {
    Goto $nin_paths.GithubDownloads
    <# examples
        Out-Fzf -Debug -Help
        Out-Fzf -Debug -PromptText 'cat' -Help
        # $x = Out-Fzf
        #>

    Get-ChildItem | Select-Object -First 3
    | Out-Fzf -Debug

    # Get-ChildItem -Name | Out-Fzf -MultiSelect -Debug
}
