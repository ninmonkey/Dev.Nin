using namespace System.Text
using namespace System.Collections.Generic



if (! $_namedColors) {
    $_namedColors = @{}
}

$_namedColors.BlueNice = '38aaee'


function _filterByType_GetEmoji {
    $RegexAscii = '[\u0000-\u00ff]'
    $RegexAscii = '[\x00-0xff]'

    $InputObject -match $RegexAscii, ''
}


function Dev-Get-UnicodeDistinctRune {

    <#
    .synopsis
        return a distinct list of [Rune]. A distinct list of 'codepoints', **not Graphemes**
    .description
        the default action is to enumerate **all** text, then Sort -Distinct
    .notes
        ref:
            [StringBuilder](https://docs.microsoft.com/en-us/dotnet/api/system.text.stringbuilder?redirectedfrom=MSDN&view=net-5.0)
            [powershellexplained.com tutorial: string builder](https://powershellexplained.com/2017-11-20-Powershell-StringBuilder/)
    #>
    param(
        # input text
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$InputText
    )

    begin {
        $sbAllText = [System.Text.StringBuilder]::new()

    }
    process {
        $InputText | ForEach-Object {
            [void]$sbAllText.Append( $_ )
        }

        # ( Get-Clipboard).EnumerateRunes() | Sort-Object Value -Unique
        # | Join-String -sep "`n"
    }
    end {
        $sbAllText.ToString().Length | Label 'Initial'

        $sbAllText.ToString().EnumerateRunes()
        | Sort-Object -Unique Value
        | Join-String -sep "`n"
    }
}

function Get-NamedEmoji {
    <#
    .synopsis
    $sb = [System.Text.StringBuilder]::new()

    #>
}

function _Get-NinCommandSingle {
    <#
    .synopsis
        when Get-NinCommand -Module $scalar

    then group by verb
    #>

    Get-Command -Module Ninmonkey.Console | Sort-Object Name, Verb
}

function _Get-NinCommandMultiple {
    <#
    .synopsis
        when Get-NinCommand -Module 'Dev.Nin', 'Ninmonkey.Console'

    then group by module, maybe manually call _Get-NinCommandSingle
        otherwise a custom formatter?
    #>

    Get-Command -Module Ninmonkey.Console | Sort-Object Name, Verb
}


function Get-Rune {
    # throw "nyi"
    Write-Warning 'NYI: public\import-Dev-Unicode.ps1'
}

function _get-UnicodeHelp {
    @'
Wip

1. distinct runes from string
1. search Rune by Name / description (UD.csv)
1. get Name for Rune (UD.csv)
1. filter all non-emoji from string (select-emoji)
1. distinct grapheme is possible?
'@ | Label '' -sep '' -fg2 $_namedColors.BlueNice
}

if ($false -and $DebugTestMode) {

    H1 'CommandMulti'
    _Get-NinCommandMultiple
    | Select-Object -First 20

    H1 'CommandSingle'
    _Get-NinCommandSingle
    | Select-Object -First 20

    H1 'Get-Rune -Name cat'
    Get-NamedEmoji 'cat'

    H1 'Distinct Rune'
    'a = ✔️' |  Dev-Get-UnicodeDistinctRune

    H1 'Ninmonkey.Console\Get-UnicodeInfo'
    'a = ✔️' |  Get-UnicodeInfo | Format-Table

    H1 'Get-Rune'
    Get-Rune -Codepoint 128018 # Alias -cp

}
# write-warning 'wip:'
# _get-UnicodeHelp