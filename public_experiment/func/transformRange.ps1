#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'ConvertFrom-NumberRange'
    )
    $experimentToExport.alias += @(
        'To->TransformRange' # ''
        'Convert-NumberRangeFromRange'
    )
}


# function Convert-NumberRangeFromRange-NumberRange {
function ConvertFrom-NumberRange {
    <#
        .synopsis
            map a value from interval [a,b] to [c,d]
        .description
            map a value from interval [min1, max1] to [min2, max2]

            Example:

                RGB(50%, 100%, 10%) => RGB( 127, 255, 25)

            map the interval [a,b] onto the interval [c,d] in that order
            (meaning f(a)=c and f(b)=d), assuming a≠b.

            Naming:
                "ConvertFrom-NumberRange"
                    felt closer to a scalar from  mapping one range to another

                "Convert-NumberRangeFromRange"
                    I'm not happy with "Convert-NumberRangeFromRange" because it sounded
                    like you were returning a mapped range, not one value
        .notes
            .
        .example
            PS> Verb-Noun -Options @{ Title='Other' }
        .link
            https://math.stackexchange.com/a/1205746/9259
        .link
            https://math.stackexchange.com/a/914843/9259
        #>
    # [outputtype( number )]
    [Alias(
        'To->TransformRange',
        'Map->Range'
    )]
    [cmdletbinding()]
    param(
        # value to transform
        [Alias('X')]
        [parameter(Mandatory, ValueFromPipeline)]
        [object]$Value,

        # Min of first range
        [Alias('A', 'Minimum1')]
        [parameter(Mandatory, Position = 0)]
        [object]$Min1,

        # Max of first range
        [Alias('B', 'Maximum1')]
        [parameter(Mandatory, Position = 1)]
        [object]$Max1,

        [Alias('C', 'Minimum2')]
        [parameter(Mandatory, Position = 2)]
        [object]$Min2,

        [Alias('D', 'Maximum2')]
        [parameter(Mandatory, Position = 3)]
        [object]$Max2

        # extra options
        # [Parameter()][hashtable]$Options
    )
    begin {
        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        # [hashtable]$Config = @{
        #     AlignKeyValuePairs = $true
        #     Title              = 'Default'
        #     DisplayTypeName    = $true
        # }
        # $Config = Join-Hashtable $Config ($Options ?? @{})
        # preconditions
        if ($Min1 -eq $Max1) {
            Write-Error -Message 'Precondition failed: a ≠ b' -Category InvalidArgument -TargetObject @{
                A = $Min1; B = $Max1; Min2 = $Min2; Max2 = $Max2; X = $Value # or Category: InvalidData ?
            }
            if (!($value -ge $Min1 -and $Value -le $max1)) {
                Write-Error -Message 'Precondition failed: a ≤ x ≤ b' -Category InvalidArgument -TargetObject @{
                    A = $Min1; B = $Max1; Min2 = $Min2; Max2 = $Max2; X = $Value
                }

            }
            # @(
            #     # >  (meaning f(a)=c and f(b)=d), assuming a≠b.
            #     $Min1 -ne $Max1   # a≠b.
            # ) | Dev.Nin\Test-AllTrue
            # $Min
        }
    }
    process {

        <#
            f(t) = c + ( (d - c)  / (b - a) ) * (t - a)
            f(x) = $Min2 + ( ($Max2 - $Min2)  / ($Max1 - $min1) ) * ($X - $Min1)
        #>
        @{
            AsString = $false;
            X = $Value; A = $Min1 ; B = $Max1 ; C = $Min2; D = $Max2
        } | Format-HashTable -FormatMode SingleLine | Write-Debug
        @{
            AsString = $true;
            X = $Value; A = $Min1 ; B = $Max1 ; C = $Min2; D = $Max2
        } | Format-HashTable -FormatMode SingleLine -AsString | Write-Debug
        @{
            AsString = $false;
            X = $Value; A = $Min1 ; B = $Max1 ; C = $Min2; D = $Max2
        } | Format-HashTable -FormatMode SingleLine | Out-String | Write-Debug
        @{
            AsString = $true;
            X = $Value; A = $Min1 ; B = $Max1 ; C = $Min2; D = $Max2
        } | Format-HashTable -FormatMode SingleLine -AsString | Out-String | Write-Debug



        $Min2 + ( ($Max2 - $Min2) / ($Max1 - $min1) ) * ($Value - $Min1)

    }
    end {
        # Write-Warning 'does not run '

    }
}



if (! $experimentToExport) {
    # ...
}
