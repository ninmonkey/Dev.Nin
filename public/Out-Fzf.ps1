function Out-Fzf {
    <#
    .synopsis
        uses commandline app 'fzf' similar to 'out-gridview'
    .description
        a simple multi-item selection for the console without the extra features of 'Out-ConsoleGridView'
    .notes
        selected items are returned **in-order** that they are selected in FZF
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
        if ($Help) {
            '<https://github.com/junegunn/fzf#tips> and ''fzf --help'''
            break
        }
        $binFzf = Get-Command 'fzf' -ErrorAction Stop

        $inputList = [list[string]]::New()

        $fzfArgs = @()

        if ( ! [String]::IsNullOrWhiteSpace(  $PromptText  ) ) {
            $fzfArgs += ("--prompt={0}" -f $PromptText)
        }

        if ($MultiSelect) {
            $fzfArgs += '--multi'
        }
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
        $inputList
        | & $binFzf @fzfArgs

        Label 'Final' $inputList.count | Write-Debug
        Label 'args' $fzfArgs | Write-Debug


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

}