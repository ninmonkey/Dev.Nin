# allows script to be ran alone, or, as module import
if (! $DebugInlineToggle ) {
    $experimentToExport.function += @(
        'Set-NegateExpression'
    )
    $experimentToExport.alias += @(

        # 'Not',
        'Not!',
        # 'FlipBool',
        'Not¬'
    )

    # )
}

function Set-NegateExpression {
    <#
    .synopsis
        mainly CLI sugar to negate expressions
    .notes
        I'm not sure which verb
            set/update/modify: maybe the best verbs?
            test: it doesn't test, it's used by caller's test
            switch:  desc is both waus

        future:
            Should whitespace negate as if $null?

    .link
        Where-IsNotBlank
    .outputs
        boolean
    #>
    [Alias(
        'Not',
        'Not!',
        'Not¬',
        'FlipBool'
    )]
    [outputtype([bool])]
    [cmdletbinding()]
    param(
        # Input text line[s]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyCollection()]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, position = 0)]
        [object]$InputObject
    )
    process {

        ! ( $InputObject )
    }
}
