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
        # any object
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # preset column order, and to out-griview
        [alias('oGv')]
        [parameter()]
        [switch]$OutGridView
    )
    process {
        $meta = @{
            # ImplementedInterfaces
        }
        $tinfo = $InputObject.GetType()
        [ordered]@{
            Name     = $tinfo.Name
            TypeName = $tinfo | Format-TypeName -Brackets
        } | Format-Dict
        | Write-Information

        $tinfo.ImplementedInterfaces | Format-TypeName -Brackets
        | STR UL -Sort -Unique
        | str Prefix 'ImplementedInterfaces: '
        | Write-Information

        if (! $OutGridView ) {
            $InputObject.psobject.properties
            return
        }

        $title_ogv = '{0} ⁞ {1}' -f @(
            $tinfo | Format-TypeName -Brackets
            $Tinfo.FullName -replace '^System\.', ''
        )
        $InputObject.psobject.properties
        | Select-Object Name, Value, TypeNameOfValue, * -ea ignore
        | Sort-Object Name # TypeNameOfValue
        | Out-GridView -PassThru -Title $title_ogv
    }
}