#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Get-DistinctUnicodeList'
    )
    $experimentToExport.alias += @(
        # ''
        'Uni->DistinctRunes' # 'Get-DistinctUnicodeList'
    )
}

function Get-DistinctUnicodeList {
    <#
    .synopsis
        test parts of a rune
    .description
        Desc
    .notes

    .notes
        performance:
            enumerating [char]: [EnumeratingChar](https://docs.microsoft.com/en-us/dotnet/api/system.text.stringbuilder?view=net-6.0#iterating-stringbuilder-characters)
        todo:
            speed test these:

                $str.GetEnumerator()
                $str -split ''
                $strBuilder.ToString().GetEnumerator()
    .example
        .
    .link
        https://docs.microsoft.com/en-us/dotnet/api/system.text.stringbuilder?view=net-6.0
    .link
        https://docs.microsoft.com/en-us/dotnet/standard/base-types/composite-formatting

    #>
    [Alias(
        'Uni->DistinctRunes'
    )]
    [CmdletBinding()]
    param(
        # input text
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$Text,

        # calculate distinct values by [char] or by Codepoint
        [Parameter(Position = 0)]
        [ValidateSet('Char', 'Rune', 'Grapheme', 'RawDebug')]
        [string]$CompareType = 'Rune'


    )

    begin {
        $strB = [Text.StringBuilder]::new()
    }
    process {
        [void]$strB.Append( $Text )
    }
    end {



        switch ($CompareType) {
            'Char' {
                $strB.ToString().GetEnumerator() | Sort-Object -Unique
            }
            'Rune' {
                $strB.ToString().EnumerateRunes() | Sort-Object -Unique Value | ForEach-Object ToString
            }
            'RawDebug' {
                $StrB.ToString() -split '' | ForEach-Object { $_ -split '' } | Sort-Object -Unique
                hr
                # Expected something like
                #  ForEach-Object { $_ -split '' } | Sort-Object -Unique


                gpstree . -Depth 2 | Out-String | Uni->ToCodepoint | Sort-Object -Unique | Uni->FromCodepoint | str str ''
                hr
                gpstree . -Depth 2 | Out-String | ForEach-Object { $_ -split '' } | Sort-Object -Unique | str str ''
                h1 'oh, maybe case-insensitive is the difference'
            }
            default {
                Write-Error "Not ImplementedType: $CompareType"
                return
            }
        }

        # if ($AsRune) {
        # }

        # gpstree . | Out-String | ForEach-Object { $_ -split '' } | Sort-Object -Unique | str csv

    }
}
