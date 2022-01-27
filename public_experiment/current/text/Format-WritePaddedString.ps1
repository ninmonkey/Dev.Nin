#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Format-WritePaddedText'
    )
    $experimentToExport.alias += @(
        'PadLeft', 'PadRight'
    )
}

function _whyIsthisHere_Get-ConsoleInfo {
    <#
    scraped from: todo: refactor to external mini utility
        Write-PromptDetectParent_iter0
        _Write-PromptForBugReport
    #>
    param()
    end {
        $meta = @{
            PSTypeName = 'DevNin.ConsoleInfo'
            Width      = $host.ui.RawUI.WindowSize.Width
        }


        $chunk = @()
        $template = "TermName: {0}`nIsVsCode: {1}`nIsPSIT: {2}"
        $chunk += $template -f @(
            $__ninConfig.Terminal.CurrentTerminal
        ($__ninConfig.Terminal.IsVSCode) ? 'Y' : 'N'
        ($__ninConfig.Terminal.IsVSCodeAddon_Terminal) ? 'Y' : 'N'
        ) | Join-String
        $chunk | Join-String -os "`n"
    }

}
function Format-WritePaddedText {
    <#
        .synopsis
            sugar for [string].PaddLeft(..) on the pipelin
        .notes
            .
            See immutatble string ets
        .example
            PS>
        .link
            dev.nin\Format-IndentText
        .link
            dev.nin\Format-UnindentText
        #>
    [outputtype( [string[]] )]
    [Alias('PadLeft', 'PadRight')]
    [cmdletbinding()]
    param(
        # docs
        # [Alias('y')]
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputText,

        # total string width (Or Rrather, total [char] length of [String])
        [Alias('Columns')]
        [Parameter(Position = 0, Mandatory)]
        [ArgumentCompletions(8, 20, 80, 140)]
        [int]$Width = 20,


        # direction
        [Parameter(Position = 1)]
        [ValidateSet('Left', 'Right')]
        [String]$Alignment = 'Left',

        # optional filler.
        [Alias('Char')]
        [Parameter(Position = 2)]
        [ArgumentCompletions(' ', '_', '-', 'x')]
        [char]$PaddingChar


        # extra options
        # [Parameter()][hashtable]$Options
    )
    begin {
        $invokeName = $PSCmdlet.MyInvocation.InvocationName
        $isSmartAlias = $myInvokeName -in @(
            'PadLeft', 'PadRight'
            # 'middle/center'
            # $PSCmdlet.MyInvocation.MyCommand.Name.ToString()

        )
        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        # [hashtable]$Config = @{
        #     AlignKeyValuePairs = $true
        #     Title              = 'Default'
        #     DisplayTypeName    = $true
        # }
        # $Config = Join-Hashtable $Config ($Options ?? @{})
        if ($IsSmartAlias) {
            $Alignment = $invokeName

        }
        $PSBoundParameters | Out-Default | Write-Debug
        $PSBoundParameters | format-dict | Out-Default | Write-Debug
    }
    process {
        $Alignment ??= 'Left'
        $InputText | ForEach-Object {
            $curLine = $_.ToString()
            $render = $curLine

            switch ($Alignment) {
                'Left' {
                    if ($null -eq $PaddingChar) {
                        $render = $curLine.PadLeft( $Width )
                    } else {
                        $render = $curLine.PadLeft( $Width, $PaddingChar )
                    }
                }
                'Right' {
                    if ($null -eq $PaddingChar) {
                        $render = $curLine.PadRight( $Width )
                    } else {
                        $render = $curLine.PadRight( $Width, $PaddingChar )
                    }
                }
                default {
                    throw "Unhandled '$Alignment' from '$PSCommandPath'"
                }
            }
            $render
        }
    }
    end {
    }
}

if (! $experimentToExport) {
    'a' | padLeft -Width 3
    # ...
}
