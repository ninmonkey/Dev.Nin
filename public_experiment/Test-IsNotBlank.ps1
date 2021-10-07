# allows script to be ran alone, or, as module import
if (! $DebugInlineToggle ) {
    $experimentToExport.function += @(
        'Test-IsNotBlank'
    )
    $experimentToExport.alias += @(
        '!Blank'
        'TextProcessing📚.IsNotBlank'
    )
}


function Test-IsNotBlank {
    <#
    .synopsis

    .outputs
        boolean
    #>
    [Alias('!Blank', 'TextProcessing📚.IsNotBlank', 'Validation🕵.IsNotBlank')]
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
