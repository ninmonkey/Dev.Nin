#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Show-History'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

function Show-History {
    <#
    .synopsis
        Show, and optionally select history using ogv
    #>
    param()

    # Get-History | Select-Object * | Out-GridView -PassThru
    Out-NinGridView (Get-History | Select-Object *)
}


if (! $experimentToExport) {
    # ...
}