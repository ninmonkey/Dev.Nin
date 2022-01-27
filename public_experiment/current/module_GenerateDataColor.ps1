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

function __importSubdirColors {
    # foreach($file in '')
    . (Get-Item (Join-Path $PSSCriptRoot 'module_GenerateColor/colors_gray.ps1'))
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
        [ValidateSet('Gray')]
        [string]$TemplateName,

        # values to pass to inner queries
        [Alias('Args')]
        [parameter(Position = 1, ValueFromPipeline)]
        [string[]]$ArgumentList
    )
    process {
        switch ($TemplateName) {
            'Gray' {
                # '_colorDump_Gray '
                Color->Gray $Args
            }
            default {
            }
        }
    }
}

if (! $experimentToExport) {
    # ...
} else {
    __importSubdirColors
}
