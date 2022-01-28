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
# . (Get-Item (Join-Path $PSSCriptRoot 'module_GenerateColor/colors_gray.ps1'))
#     . (Get-Item (Join-Path $PSSCriptRoot 'module_GenerateColor/colors_colorspace.ps1'))



'colors_gray', 'colors_colorspaces' | ForEach-Object {
    $curScript = $_
    $fullpath = (Join-Path $PSSCriptRoot "module_GenerateColor/${curScript}.ps1")
    if (! (Test-Path $fullpath)) {
        Write-Error "Missing file: '$fullpath'"
    }
    . (Get-Item $fullPath)


}


function __importSubdirColors {
    # return # test -nop
    'colors_gray', 'colors_colorspaces' | ForEach-Object {
        $curScript = $_
        $fullpath = (Join-Path $PSSCriptRoot "module_GenerateColor/${curScript}.ps1")
        if (! (Test-Path $fullpath)) {
            Write-Error "Missing file: '$fullpath'"
        }
        . (Get-Item $fullPath)

    }
    # foreach($file in '')
    # . (Get-Item (Join-Path $PSSCriptRoot 'module_GenerateColor/colors_gray.ps1'))
    # . (Get-Item (Join-Path $PSSCriptRoot 'module_GenerateColor/colors_colorspace.ps1'))
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

        # list options
        [switch]$ListTemplates,

        # values to pass to inner queries
        [Alias('Args')]
        [parameter(Position = 1, ValueFromPipeline)]
        [string[]]$ArgumentList
    )
    process {
        if ($ListTemplates) {
            @(
                'Color->Gray'
                'Color->EnumerateGradient'
            )
            | Sort-Object -Unique
            return
        }

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

# if (! $experimentToExport) {
#     # ...
# } else {
#     __importSubdirColors
# }
Write-Warning "validate color->Colorspace is exporting. src: '$PSCommandPath'"
if ( $experimentToExport ) {
    Write-Warning '     importing...'
    __importSubdirColors
} else {
    Write-Warning '     [error] failed !'

}
