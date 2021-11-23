#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Compare-StringByChar'
        'Get-UnicodeLength'
        'Convert-CharFromCodepoint'
        'Convert-CodepointFromChar'

    )
    $experimentToExport.alias += @(
        # 'diff->ByChars'
        # 'CompareCharType' ?
        # 'diff->[chars]'
        # 'A'
        # 'diff->ByChars'
        # 'diff->ByChars'
        'Uni->FromCodepoint'
        'Uni->Length'
        'Uni->ToCodepoint'
    )
}

function Get-UnicodeLength {
    <#
    .synopsis
        Get length of a string, specifically counting by the number of codepoints    
    .example
        PS> Get-UnicodeLength '🐒'
        # 1 
    #>
    [ Alias('Uni->Length')]
    [OutputType('int')]
    [cmdletbinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Text
    )
    process {
        $Text.EnumerateRunes() | Len
    }
}
function Convert-CharFromCodepoint {        
    # Convert-RuneFromCodepoint {
    <#
    .synopsis
        converts [int] to char [string]
    .link
        Convert-CharFromCodepoint
    .link
        Convert-CodepointFromChar    
    .outputs
        [string]
    #>
    [ Alias('Uni->FromCodepoint')]
    [cmdletbinding(DefaultParameterSetName = 'fromString')]
    param(
        # Codepoint
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [int]$Codepoint
    )
    process {
        [char]::ConvertFromUtf32( $Codepoint )
    }
}


function Convert-CodepointFromChar {
    <#
    .synopsis
        converts [char] to Codepoint [int]
    
    names   
        Convert-CodepointFromChar
        ConvertTo-UniCodepoint
        ConvertFrom-CharToCodepoint
        ConvertFrom-UniChar        

    .outputs
        [int] in range [0..10ffff]
    #>
    [Alias('Uni->ToCodepoint')]
    [cmdletbinding(DefaultParameterSetName = 'fromString', PositionalBinding = $false)]
    param(
        # char (string, not surrogates)
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'fromString', Position = 0)]
        [string]$Char,

        # Issues with conversion paths and params, just disabling these as defaults
        # high pair for: [char]::ConvertToUtf32
        [Parameter(
            # Mandatory, ParameterSetName = 'fromSurrogate', Position = 0
        )]
        [char]$HighSurrogate,

        # low pair for: [char]::ConvertToUtf32
        [Parameter(
            # Mandatory, ParameterSetName = 'fromSurrogate', Position = 1
        )]
        [char]$LowSurrogage
    )
    process {
        # (char highSurrogate, char lowSurrogate);
        # public static int ConvertToUtf32(string s, int index);
        switch ($PSCmdlet.ParameterSetName) {
            'fromSurrogate' {
                [char]::ConvertToUtf32( $HighSurrogate, $LowSurrogage )
                break
            }        
            default {
                $numCp = Get-UnicodeLength $Char
                if ($numCp -gt 1) {
                    Write-Verbose 'Expected Len == 1, enumerating found codepoints.'                    
                    $char.EnumerateRunes().Value
                    return
                }
                [char]::ConvertToUtf32( $Char, 0 ) # maybe no longer required, with runes in 7+            
                # $char.EnumerateRunes().Value
            }
        }
    }
}
function Compare-StringByChar { 
    <#
    .synopsis
        compare strings. enumerates by [char] **index** not by **code point** !
    .description
        does NOT enumerate on codepoints.
        currently does not return objects.
    
    #>
    [alias('diff->ByChars')]
    param(
        # first string to compare
        [Parameter(Mandatory)]
        [string]$left,
        
        # other string to compare
        [Parameter(Mandatory)]
        [string]$right,
        
        # return an object instead of color
        [switch]$PassThru
    )

    0..($left.Length - 1)
    | ForEach-Object {
        # br 2
        $index = $_
        $l = $left[$index]
        $r = $right[$index]
        $areSame = $l -eq $r

        function _invokeIfNotNull {
            param($maybeNull) 
            if ($null -eq $maybeNull) {
                return; 
            }
            Convert-CodepointFromChar $maybeNull
        }

        if ($PassThru ) {
            [PSCustomObject]@{
                Index   = $index
                Equal   = $areSame
                Left    = $l
                Right   = $r
                LeftCp  = Convert-CodepointFromChar $l 
                # RightCp = Convert-CodepointFromChar $r
                RightCp = _invokeIfNotNull $r
            }
            return 
        }

        if (! $PassThru ) {
            # "[$_] ? = $areSame"
            # $l, $r | Join-String -sep ' = ' -SingleQuote -op "`t"
            if (! $areSame) { 
                $l, $r | Where-NotNull NullOrWhiteSpace | Get-RuneDetail #-wa Ignore
                | Format-Table | Out-String
                | Write-Color orange
            } else {

                $l, $r | Get-RuneDetail -wa Ignore
                | Format-Table | Out-String
                | Write-Color blue
            }
        }
  
    }

}

if (! $experimentToExport) {
    $left = '| Format-Table | Out-String'
    $right = '|  Formt-Table | out-Strnig'
    $res1 = Compare-StringByChar $left $right -PassThru
    Compare-StringByChar $left $right
    
    hr 2 
    h1 'Function: Dev.Nin\Compare-StringByChar'
    @{ Left = $Left | Join-String -DoubleQuote; Right = $Right | Join-String -DoubleQuote } | Format-HashTable
    $res1 | Format-Table -AutoSize
    # ...
}