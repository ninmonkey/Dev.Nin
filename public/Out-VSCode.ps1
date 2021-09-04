<#
.notes
    1]
        running 'code' from within 'VS Code' 'PowershellIntegratedTerminal' displays this error
            [1227/084413.896:ERROR:registration_protocol_win.cc(103)] CreateFile: The system cannot find the file specified. (0x2)

        VS Code appears to work fine, it's related to electron's file creation?

        using 'start-process' hides that from the user.
        Start-Process 'code' -WindowStyle Hidden -ArgumentList @('"C:\Users\cppmo_000\Documents\2020\todo\todo ⇽ 2020-12.md"')
#>

Write-Warning 'see: seeminglySci: Out-VS Code <Invoke-VSCode https://github.com/SeeminglyScience/dotfiles/blob/c4fa75ceddbdb5d9b6d16b90428969cc1c37fbe7/PowerShell/Utility.psm1#L119>

    and indented (last write 2years)

    - <https://github.com/indented-automation/Indented.Profile/blob/7e593e871db6800ba5d757ecd9bcb1b124d205cf/Indented.Profile/public/Get-CommandInfo.ps1>
    - <https://github.com/indented-automation/Indented.Profile/blob/7e593e871db6800ba5d757ecd9bcb1b124d205cf/Indented.Profile/public/Get-CommandSource.ps1>
'
function Out-VSCode {
    <#
    .synopsis
        open files in VS Code with options
    .description
        the most basic usage is like running:

            PS > Get-ChildItem . -File | ForEach-Object { code $_ }
    .notes

    todo: Features
        - [ ] pipe a file or folder list
        - [ ] `confirm` when filelist > 4
        - [ ] sametab vs new-window
        - [ ] diff file1 file2>

    autopipe to temp, but arg -Dump will save to
}


    .example
        PS>

    #>
    [Alias('Out-Code')]
    param (
        # show help
        [Parameter()][switch]$Help,

        # filenames piped input
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [Alias('PSPath')]
        [string[]]$FileName

        # [1] Future: param -Property
        # [2] future: support PSObjects with property '.Name' or ToString


        # future: Maximum selection: --multi[=max]
        # [Parameter()][int]$MaxMultiSelect
    )

    begin {
        $debugMeta = @{}

        if ($Help) {
            '<https://github.com/junegunn/fzf#tips> and ''fzf --help'''
            break
        }
        return

        $binFzf = Get-Command 'fzf' -CommandType Application
        $fzfArgs = @()
        $inputList = [list[string]]::New()

        if ( ! [String]::IsNullOrWhiteSpace(  $PromptText  ) ) {
            $fzfArgs += ('--prompt={0}' -f $PromptText)
        }

        if ($MultiSelect) {
            $fzfArgs += '--multi'
        }

        $debugMeta.FzfArgs = $fzfArgs
    }
    process {
        foreach ($Line in $FileName) {
            $inputList.add( $Line )
        }
    }
    Hr 1;
    Label 'ParameterSetName' 'SingleQuote'
    Label 'ParameterName' 'OutputPrefix'

    $cinfo.ParameterSets | Where-Object Name -EQ 'singlequote' | Select-Object -exp Parameters
    | Where-Object Name -Match 'OutputPrefix' -ov filtered

    Label '-OutputPrefix' 'ParameterType'
    $filtered.ParameterType | Format-Table *

    # same
    @($filtered)[0].parametertype | Format-Table *

    $info = [ordered]@{
        SetName = 'SingleQuote'
        Name    = 'OutputPrefix'
        Type    = 'x.parametertype'
    }
    end {
        # $Selection = $inputList | & $binFzf @fzfArgs
        # $Selection

        # style 1]
        # $debugMeta.InputListCount = $inputList.Count
        # $debugMeta.SelectionCount = $Selection.Count
        # $debugMeta.Selection = $Selection | Join-String -sep ', ' -SingleQuote | Label 'Selection'

        # style 2]
        # style wise, this looks cleaner, but throws on duplicate key names
        $debugMeta += @{
            # InputListCount = $inputList.Count
            # SelectionCount = $Selection.Count
            # Selection      = $Selection | Join-String -sep ', ' -SingleQuote | Label  'Selection'

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


if ($true -and $TempDebugTest) {
    Push-Location 'C:\Users\cppmo_000\Documents\2020\todo' -StackName 'debugStack'

    Pop-Location -StackName 'debugStack'

    out-vsc

}
