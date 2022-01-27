#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'New-ColorFromTemplate'
    )
    $experimentToExport.alias += @(
        'cDump' #New-ColorFromTemplate
        'Color->Template'

    )
}

function New-ColorFromTemplate {
    <#

        see also:
    .link

        New-ColorFromTemplate

    #>
    [alias('cDump',
        'Color->Template'
    )]
    param(

        # auto create from files
        [parameter(Position = 0)]
        [ValisateSet('Gray')]
        [string]$TemplateName,

        # values to pass to inner queries
        [Alias('Args')]
        [parameter(Position = 1, ValueFromPipeline)]
        [string[]]$ArgumentList
    )
}

if (! $experimentToExport) {
    # ...
}
