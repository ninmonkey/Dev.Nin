#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Compare-StringByChar'
    )
    $experimentToExport.alias += @(
        'diff->ByChars'
        # 'CompareCharType' ?
        # 'diff->[chars]'
        # 'A'
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
    # alias Convert-CharFromCodeoint
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

    [cmdletbinding(DefaultParameterSetName = 'fromString')]
    param(
        # char (string, not surrogates)
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'fromString', Position = 0)]
        [string]$Char,

        # high pair for: [char]::ConvertToUtf32
        [Parameter(Mandatory, ParameterSetName = 'fromSurrogate', Position = 0)]
        [char]$HighSurrogate,

        # low pair for: [char]::ConvertToUtf32
        [Parameter(Mandatory, ParameterSetName = 'fromSurrogate', Position = 1)]
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
                    Write-Warning 'Expected Len == 1, using first index '                    
                }
                [char]::ConvertToUtf32( $Char, 0 )

                
                
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

        if ($PassThru ) {
            [PSCustomObject]@{
                Index   = $index
                Equal   = $areSame
                Left    = $l
                Right   = $r6
                LeftCp  = Convert-CodepointFromChar $l 
                RightCp = Convert-CodepointFromChar $r
            }
            return 
        }

        if (! $PassThru ) {
            # "[$_] ? = $areSame"
            # $l, $r | Join-String -sep ' = ' -SingleQuote -op "`t"
            if (! $areSame) { 
                $l, $r | Get-RuneDetail -wa Ignore
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
    Compare-StringByChar $left $right -PassThru
    Compare-StringByChar $left $right
    # ...
}