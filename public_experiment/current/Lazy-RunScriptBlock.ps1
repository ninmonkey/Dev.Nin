if ($experimentToExport) {
    $experimentToExport.function += @(
        'Lazy-InvokeScriptBlock'
        'Lazy-Invoke'
    )
    $experimentToExport.alias += @(
    )
}

function Lazy-InvokeScriptBlock {
    <#
    .synopsis
        cache results of scriptblocks, or, lazilyInvokeScriptBlock
    .description
        personal profile adds verb: Lazy
    .notes
        .
        future:
            Invoke-Conditional
    .example
            PS> Verb-Noun -Options @{ Title='Other' }
        #>
    # [outputtype( [string[]] )]
    # [Alias('x')]
    [cmdletbinding()]
    param(
        # docs
        # [Alias('y')]
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # extra options
        [Parameter()][hashtable]$Options
    )
    begin {
        Write-Debug 'already have a cache func or not?'
        Write-Error -CategoryActivity NotImplemented -m 'NYI: wip: LazyInvokeScriptBlock'
        [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        [hashtable]$Config = @{
            AlignKeyValuePairs = $true
            Title              = 'Default'
            DisplayTypeName    = $true
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})
    }
    process {
    }
    end {
    }
}

if (!$experimentToExport) {


}
