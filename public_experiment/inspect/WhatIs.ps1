
if ( $experimentToExport ) {
    $experimentToExport.function += @(
        # 'Get-WhatObjectType' ?
        'Get-WhatTypeInfo'
        'Get-WhatIsShortName'
    )
    $experimentToExport.alias +=
    @(
        'ShortName'
        'Inspect->TypeInfo'
        # 'Find-ObjectProperty'
        # 'New-Sketch'
    )
}
# }


function Get-WhatIsShortName {
    <#
    .synopsis
        basic test-type , shortname
    .example
        ,@(,'a'), 0.3, 'a', (gi .), (get-date), @{}, [ordered]@{} | whatAmI
    #>
    [Alias('ShortName')]
    param(
        [parameter(ValueFromPipeline, Position = 0, Mandatory)]$InputObject
    )
    process {
        $InputObject | _mapFormatShortName

        # $InputObject.GetType().FullName -replace 'System.Collections\.', '' -replace '^System\.', ''
        # $InputObject.GetType().Name
    }
}


function Get-WhatTypeInfo {
    <#
        .synopsis
            gives type info, in a longer form, it's for interactive use rather that WhatTypeIsObj
        .description
            .
            #6 WIP
        .example
        .link
            # Dev.Nin\_enumerateProperty
        .link
            Dev.Nin\iProp
        .link
            Ninmonkey.Console\What-ParameterInfo
        #>
    [Alias('Inspect->TypeInfo')]
    [OutputTYpe('System.String')]
    [cmdletbinding()]
    param(
        # any object
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject
        # # preset column order, and to out-griview
        # [alias('oGv')]
        # [parameter()]
        # [switch]$OutGridView
    )
    process {
        if ($null -eq $InputObject) {
            [pscustomobject]@{
                PSTypeName = 'nin.WhatIsInfo'
                Value      = $null
            }
            return
        }
        $obj = $InputObject
        $tinfo = ($InputObject)?.GetType()

        $meta = [ordered]@{
            PSTypeName            = 'nin.WhatIsInfo'
            Type                  = $tinfo.Name
            # | Format-TypeName -WithBrackets #-ea Ignore
            FullName              = $tinfo.FullName
            Value                 = $InputObject
            TypeNames             = $tinfo.pstypenames
            TypeNamesFormat       = $tinfo.pstypenames
            | Format-TypeName -WithBrackets
            | str csv
            TypeNamesLong         = $tinfo.pstypenames -join '-'
            ImplementedInterfaces = $tinfo.ImplementedInterfaces
            # | Format-TypeName -WithBrackets -ea Ignore
            | str Csv
            # todo: make this render happen in formatting
            # keep full values in object
            # PSTypeNames = $f.pstypenames | convert 'type' | Format-TypeName -Brackets | str csv
        }

        $meta.type | format-typename -Brackets
        $meta | format-typename -Brackets

        # Name =
        # FullName

        # $meta | Format-Dict | wi
        [pscustomobject]$meta

        <#

maybe:

        $parsedInfo = [ordered]@{
            PSTypeName        = 'nin.ParsedTypeName'

            duties:
                external code/type has 'nin.TypeInfo' and other inspection

                Format-TypeName:
                    least amount of info, and dependencies as possible.
                    otherwise recursion

            # RenderName        = # plus, here, it's recursive. visual, maybe not? $tinfo | Format-TypeName -WithBrackets
            FullName          = $tinfo.FullName
            Name              = $tinfo.Name # would be format style / compute some
            NameSpace         = $tinfo.NameSpace
            OriginalReference = $tinfo
        }

        if ($PassThru) {
            [pscustomobject]$parsedInfo
            return
        }#>

    }
}

if (! $experimentToExport ) {

    # $res = What-TypeInfo (Get-Item . ) -infa Continue
    # $res | Format-List
    # hr
    # $sample = ((Get-Command ls).Parameters)
    # $tinfo = $sample.GetType()
    # $tinfo | HelpFromType -PassThru
    # $tinfo.Namespace, $tinfo.name -join '.'

    # WhatIs $tinfo | Format-List *
    # WhatIs $sample | Format-List *

    $res = What-TypeInfo (Get-Item . )
    $res | Format-List
    hr
    $sample = ((Get-Command ls).Parameters)
    $tinfo = $sample.GetType()
    $tinfo | HelpFromType -PassThru
    $tinfo.Namespace, $tinfo.name -join '.'
}
