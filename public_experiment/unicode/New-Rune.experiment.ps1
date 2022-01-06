#Requires -Version 7.0

$experimentToExport.function += @(
    'New-Rune'
    # 'ConvertTo-Rune' # not sure which is more correct?
)
$experimentToExport.alias += @(
    'To->Rune'
    'ConvertTo-Rune'
    # 'Get-NamedRune'
    # 'UniChar'
)
# }


function New-Rune {
    <#
        .synopsis
            New Rune using unicode name, or codepoint
        .description
            .
        .NOTES
            maybe using -Help would open up:
                'https://www.compart.com/en/unicode/search?q={0}#characters' -
        .example
            PS> New-Rune
        .outputs
            [Text.Rune[]]
        .LINK
            https://docs.microsoft.com/en-us/dotnet/standard/base-types/character-encoding-introduction#grapheme-clusters
        .LINK
            https://docs.microsoft.com/en-us/dotnet/api/System.Text.Rune?view=net-6.0#query-properties-of-a-rune
        .link
            # Dev.Nin\_enumerateProperty
        .link
            Dev.Nin\iProp
        #>
    [Alias('To->Rune', 'UniChar', 'ConvertTo-Rune')]
    [cmdletbinding()]
    [OutputType('Text.Rune')]
    param(
        # any object: Rune, Char, Number, RuneEnumerator
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object[]]$InputObject

        # # preset column order, and to out-griview
        # [alias('oGv')]
        # [parameter()]
        # [switch]$FormatControlChar
    )
    begin {
        Write-Error 'warning: Infinite loop'
        $meta = @{}

        function _processSingle {
            param(
                [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
                [object]$target
            )

            process {
                if ($null -eq $target) { return }
                $curType = $target.GetType().FullName

                if ($CurType -in @('System.Text.Rune', 'System.Text.StringRuneEnumerator')) {
                    Write-Debug 'case: [Rune], [StringRuneEnumerator]'
                    return $target
                } elseif ($CurType -in @('System.String')) {
                    Write-Debug 'case: [String]'
                    return $target.enumerateRunes()
                } elseif ($CurType -in @('System.Int32', 'System.UInt32')) {
                    Write-Debug 'case: [int], [uint]'
                    return [Rune]::new($target)
                }

                try {
                    Write-Debug "case: [else]: from: '$curObj' as '$curType'"
                    $r = [System.Text.Rune]::new( $curobj )
                    return $r
                } catch {
                    Write-Debug "case: [Error]: Failed to create rune from: '$curObj' as '$curType'"
                    return [System.Text.Rune]::ReplacementChar
                }
            }
        }

    }
    process {
        foreach ($obj in $InputObject) {
            New-Rune $Obj
        }
    }
}

<#
#Import-Module Dev.Nin -Force

0x2404, 's', '🐒'
| %{
   $_ | New-Rune
}
hr 4

#
$runes_1 = $runes | at 0
$runes_1, $runes |  % gettype | % fullname | str QuotedList
'dfsf', 'a', 4, $runes_1, $runes | %{
     $tname = $_.gettype().FUllName
     $tname -in @('System.Text.Rune', 'System.Text.StringRuneEnumerator')
}

0x2404, 's', '🐒' | New-Rune -Debug
0x2404, 's', '🐒'
#>
