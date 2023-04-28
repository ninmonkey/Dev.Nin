#Requires -Version 7
# test this
if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Dump->PropListSketch'
        'Completion-PropertyName'
        '_get-ObjectProperty' # is Iter->Prop
        #
        '_iPropSketch'
    )
    $experimentToExport.alias += @(
        # 'iterProp'
        'Iter->Prop' # _get-ObjectProperty

        'Iter->PropName'    # Completion-PropertyName
        'Completions->PropertyName' # Completion-PropertyName



        # 'Find-ObjectProperty'
        # 'New-Sketch'

    )
}


function _iPropSketch {
    <#
    .synopsis
        sketch until DevNin\Iprop is refactored
    .example
        get-date | _iPropSketch -Options @{MaxWidth=10}
        get-date | _iPropSketch -Options @{MaxWidth=40}
    .example

        get-date | _iPropSketch -Options @{MaxWidth=5; ShortenAllCol=$false; SortOrder=@('Value', 'Name')}
        get-date | _iPropSketch -Options @{MaxWidth=5; ShortenAllCol=$false; SortOrder=@('Name', 'Type')}

    #>
    param(
        [parameter(Mandatory, ValueFromPipeline, Position = 0)]
        $InputObject,

        # extra options
        [Parameter()][hashtable]$Options,


        # should be redundant if formatter is specified
        [Parameter()][switch]$PassThru
    )
    # temp func before iProp is refactord
    begin {
        [hashtable]$Config = @{
            MaxWidth      = 40
            ShortenAllCol = $true
            SortOrder     = 'Type', 'Name', 'Value'
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})

    }
    process {
        if ($null -eq $InputObject) {
            return
        }

        $formatTableSplat_basic = [ordered]@{
            Property = 'Name', 'Value', 'TypeNameOfValue',
            @{
                n = 'TypeOfValue'
                e = { $_.value.GetType().Name }
            }
        }

        $actualType = $InputObject.GetType()
        $reportedType = $InputObject.TypeNameOfValue

        $formatTableSplat = [ordered]@{
            Property = @(
                'Name'
                @{
                    n = 'Type'
                    e = { $_.value.GetType().Name }
                }
                'TypeNameOfValue'
                'Value'
            )
        }


        $render = $InputObject
        | Iter->Prop
        | ForEach-Object {
            $curProp = $_
            $tinfo_actual = $curProp.Value.GetType().FullName
            $tinfo_reported = $curProp.TypeNameOfValue
            $tinfo_diff = $tinfo_actual -ne $tinfo_reported

            # $maybeShort = $_.| ShortenString 40 -FromEnd
            $colMax = $Config.MaxWidth

            # $Config_ShortenAllCols = $true
            if ($Config.ShortenAllCol) {
                $meta = [ordered]@{
                    Name  = $curProp.Name
                    | ShortenString -max $colMax -FromEnd

                    Type  = $tinfo_actual | ShortName
                    | ShortenString -max $colMax -FromEnd

                    TName = $tinfo_diff ? $tinfo_reported : ''
                    | ShortenString -max $colMax -FromEnd

                    Value = $curProp.Value
                    | ShortenString -max $colMax -FromEnd

                }
            } else {
                $meta = [ordered]@{
                    Name  = $curProp.Name


                    Type  = $tinfo_actual | ShortName
                    | ShortenString -max $colMax -FromEnd


                    TName = $tinfo_diff ? $tinfo_reported : ''


                    Value = $curProp.Value
                    | ShortenString -max $colMax

                }

            }
            [pscustomobject]$meta
            $curProp

        }
        | Sort-Object $Config.SortOrder

        if ( $PassThru) {
            $render
            return
        }
        $render
        | Format-Table -auto


        <#
        auto short only if too long
            'Microsoft.PowerShell.Commands.DisplayHintType'
                | if($_.toString().length -le 40) {
                @( '...';
                $_ | ShortenString 40 -FromEnd
                ) -join ''
                } else { $_ }
        #>
    }
}

function Completion-PropertyName {
    # re-evaluate me
    <#
    .synopsis
        Generate completions for an object's property names
    .notes
        'Completion' -> means get valid results
        'Completer' -> script that does more logic
    #>
    [Alias(
        'Completions->PropertyName',
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
    # todo: rename me
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
        Dev.Nin\Completion-PropertyName

    #>
    [Alias(
        'Iter->Prop'
        # '_enumerateProp'
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
                throw 'nyi'
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


function _dumpPropertySketch {
    <#
    .synopsis
        obsolete function. zero filtering. sugar for $x.psobject.properties.
    .description
        obsolete function.
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
        # [alias('oGv')]
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


if (! $experimentToExport) {
    # ...
}
