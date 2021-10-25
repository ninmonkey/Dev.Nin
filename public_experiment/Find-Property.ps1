# if ($BadDebugEnabled) {

$experimentToExport.function += @(
    '_enumerateProperty'
)
$experimentToExport.alias += @(
    'iterProp'
    'Find-ObjectProperty'

    # 'New-Sketch'
)
# }


function _enumerateProperty {
    <#
    .synopsis
    zero filtering. plain sugar for $x.psobject.properties
    .description
        .
    .example
        $foo | _enumerateProperty
    .example
        $foo | _enumerateProperty | % Name
    .link
        Dev.Nin\_enumerateProperty
    .link
        Dev.Nin\iProp
    #>
    [Alias('iterProp', 'Find-ObjectProperty')]
    [cmdletbinding()]
    param(
        #
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )
    process {
        $InputObject.psobject.properties
    }
}