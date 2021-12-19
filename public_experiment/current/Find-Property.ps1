# if ($BadDebugEnabled) {

$experimentToExport.function += @(
    '_enumerateProperty'
    'Completion->PropertyName'
    '_get-ObjectProperty' # is Iter->Prop
)
$experimentToExport.alias += @(
    # 'iterProp'
    'Iter->Prop'
    'Iter->PropName'


    # 'Find-ObjectProperty'
    # 'New-Sketch'
)
# }
# fix me

function Completion->PropertyName {
    <#
    .synopsis
        Generate completions for an object's property names
    .notes
        'Completion' -> means get valid results
        'Completer' -> script that does more logic
    #>
    [Alias(
        'Iter->PropName'
    )]
    [cmdletbinding()]
    param(
        # any object
        [Parameter(
            Mandatory, Position = 0,
            ValueFromPipeline)]
        [object]$InputObject,

        # don't sort/unique
        [Parameter()][switch]$NoSort
    )
    process {
        $names = $InputObject.psobject.properties.Name
        if ($NoSort) {
            $names
            return
        }
        $names | Sort-Object -Unique
    }
}
function _get-ObjectProperty {
    <#
    .synopsis
        sugar for '$x.psobject.properties' # rename to functon: Iter-ObjectProperty
    .link
        Dev.Nin\_enumerateProperty
    .link
        Dev.Nin\Iter->PropName
    .link
        dev.nin\EnumerateProperty
    .link
        Dev.Nin\Completion->PropertyName

    #>
    [Alias(
        'Iter->Prop'
    )]
    [OutputType([Management.Automation.PSMemberInfoCollection[Management.Automation.PSPropertyInfo]])]
    [cmdletbinding()]
    param(
        # any object
        [AllowNull()]
        [Parameter(
            Mandatory, Position = 0,
            ValueFromPipeline)]
        [object]$InputObject,

        # don't sort/unique
        [Parameter()]
        [validateSet('PSObject')]
        [string]$PropertyType = 'PSObject'
    )
    process {
        switch ($PropertyType) {
            'DefaultDisplayPropertySet' {
                'nyi'
            }
            'PSObject' {
                $InputObject.psobject.properties
            }
            default {
                $InputObject.psobject.properties
            }
        }

    }
}


function _enumerateProperty {
    <#
    .synopsis
    zero filtering. sugar for $x.psobject.properties.
    .description
        .not sure if this should be called enumerate, becase you enumerate all values,
        or if this is an iterator (at least c style)
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
        Dev.Nin\_get-ObjectProperty
    .link
        Dev.Nin\iProp
    #>
    [Alias(
        # 'iterProp',
        # 'Iter->Prop'
        # 'Enumerate->' ?
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
    begin {
        Write-Warning 'actual error is in Format-TypeName'

        <#
            Dev.Nin\_enumerateProperty
            Dev.Nin\_gh_repoList_enumeratePropertyNames
            Dev.Nin\Get-PropertyNameCompleter
            Dev.Nin\iProp
            Dev.Nin\Invoke-PropertyChain
            Dev.Nin\Where-EmptyProperty
            Ninmonkey.Console\ConvertTo-PropertyList
            Ninmonkey.Console\Select-NinProperty
            '@ | SplitStr -SplitStyle Newline | Resolve-CommandName
            | editfunc -PassThru | % file | sort

        #>

    }
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
