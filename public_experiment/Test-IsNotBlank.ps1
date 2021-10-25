# allows script to be ran alone, or, as module import
if (! $DebugInlineToggle ) {
    $experimentToExport.function += @(

        'Test-IsNotBlank'
    )
    $experimentToExport.alias += @(
        'TextProcessing📚.IsNotBlank'
        'Assert-IsNotBlank'
    )
}

function Test-IsNotBlank {
    <#
    .synopsis
        asserts, todo: Maybe throw ann error too?
    .link
        Where-IsNotBlank
    .outputs
        boolean
    #>
    [Alias('!Blank', 'TextProcessing📚.IsNotBlank',
        'Validation🕵.IsNotBlank',
        'Assert-IsNotBlank'
    )]
    [outputtype([bool])]
    [cmdletbinding()]
    param(
        # Input text line[s]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, position = 0)]
        [string[]]$Text
    )
    process {
        [string]::IsNullOrWhiteSpace( $InputText )
    }
}
