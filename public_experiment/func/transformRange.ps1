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
    [Alias('To->TransformRange')]
    [cmdletbinding()]
    param(
        # docs
        [Alias('X')]
        [parameter(Mandatory, ValueFromPipeline)]
        [object]$Value,

        [Alias('A', 'Min1')]
        [parameter(Mandatory, Position = 0)]
        [object]$Minimum1,

        [Alias('B', 'Max1')]
        [parameter(Mandatory, Position = 0)]
        [object]$Maximum1,

        [Alias('C', 'Min2')]
        [parameter(Mandatory, Position = 0)]
        [object]$Minimum12,

        [Alias('D', 'Max2')]
        [parameter(Mandatory, Position = 0)]
        [object]$Maximum2

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
        @(
            # >  (meaning f(a)=c and f(b)=d), assuming a≠b.
            $Minimum1 -ne $Maximum1   # a≠b.
        )
    }
    process {
    }
    end {
        <#
            f(t) = c + ( (d - c)  / (b - a) ) * (t - a)
        #>

    }
}



if (! $experimentToExport) {
    # ...
}
