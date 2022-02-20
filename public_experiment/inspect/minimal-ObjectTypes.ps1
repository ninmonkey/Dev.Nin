using namespace Management.Automation

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'objTypes'
    )
    $experimentToExport.alias += @(
        'Info->objTypes'
    )
}


function objTypes {
    <#
    .example
        , (Get-ChildItem .) | objTypes
    #>
    [cmdletbinding()]
    param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )

    process {
        $InputObject.GetType().Name
        $InputObject.PSTypeNames
        | ShortName
        | Join-String -sep ', '
        | Join-String -op 'PSTypeNames: '
        | Join-String -sep ', '
        | Format-IndentText
        if ($InputObject.count -gt 1) {
            $InputObject[0].GetType().Name
            | Join-String -op 'Child: '
            | Format-IndentText -Depth 2

            $InputObject[0].PSTypeNames
            | ShortName
            | Join-String -sep ', '
            | Join-String -op 'Child: PSTypeNames: '
            | Format-IndentText -Depth 2

        }
    }
}
