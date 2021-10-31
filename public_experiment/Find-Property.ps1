# if ($BadDebugEnabled) {

$experimentToExport.function += @(
    'iterProp'
)
$experimentToExport.alias += @(
    '_enumerateProperty'

    # 'Find-ObjectProperty'
    # 'New-Sketch'
)
# }


function _enumerateProperty {
    <#
    .synopsis
    zero filtering. sugar for $x.psobject.properties.
    .description
        .
    .example
        [datetime]::Now | iterprop -OutGridView
    .example
        $foo | _enumerateProperty | % Name
    .example
        # See also:
        $x.GetType() | fm | Format-MemberSignature
        $x[0].GetType() | Format-MemberSignature
    .link
        # Dev.Nin\_enumerateProperty
    .link
        Dev.Nin\iProp
    #>
    [Alias('iterProp'
        #'Find-ObjectProperty' find might be for iprop, not this?
    )]
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

        $tinfo.CustomAttributes
        | STR UL -Sort -Unique
        | str Prefix 'CustomAttributes: '
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