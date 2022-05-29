
if ( $experimentToExport ) {
    $experimentToExport.function += @(
        # 'Get-WhatObjectType' ?
        'Get-WhatTypeInfo'
        'Get-WhatIsShortTypeName'
        'Get-WhatGenericTypeInfo' # nyi
        'Get-WhatIsShortPSTypeName'

        #
        'Resolve-TypeInfo'
        'Inspect->GenericInfo' # 'Get-WhatGenericTypeInfo'

    )
    $experimentToExport.alias += @(
        # '?' # 'Resolve-TypeInfo'
        'Resolve->TypeInfo' # 'Resolve-TypeInfo'

        'ShortName' #  'Get-WhatIsShortTypeName'
        'ShortPSTypeName' # 'Get-WhatIsShortPSTypeName'
        'Inspect->TypeInfo'
        'Inspect->Interface' # 'Get-WhatInterfaceTypeInfo'
        'Inspect->GenericInfo' # to make
        # 'Find-ObjectProperty'
        # 'New-Sketch'
    )
}
# }
# function Resolve-BasicTypeInfo

# function Invoke-WhatCommand {
#     [Alias('WhatType')]
#     [CmdletBinding()]
#     param(
#         [ValidateSet('Generic', 'Interface', 'ShortName')]
#         [string]$CommandName
#     )
#     begin {
#         Write-Warning 'I''m not sure I want this command'
#     }
#     process {
#         'not sure if thi will let me pipem be discoverable,  and etc... unless it''s a proxy'
#     }
#     end {
#     }

# }
function Resolve-TypeInfo {

    <#
    .SYNOPSIS
        Resolve a typeInfo instance, or else $null
    .description
        I'm using the term "TypeInfo" for resolved types

    .notes
        next:
            implement [ResolvedTypeInfoParamAttribute()]
        future:
            - [ ] optionally run output through [Format-TypeName] to strip extra 'AssemblyQualifiedName' info


            - [ ] If type isn't found, error'ClassExplorer\Find-Type'

        refactor / share code for
            Dev.Nin\ResolveTypeInfo
            Dev.Nin\ResolveTypeName



           # $target = (Get-Item . | ForEach-Object GetTYpe )
        try {
            # this implicityly catches strings, in all cases ?
            $target = $InputObject
            $isType = $target -as 'type' -is 'type'
            # wont this lose pstypenames, if added?
            #       $target -as 'type' -is 'type'

            $tinfo = $isType ? $target -as 'type' : $target.GetType()
        } catch {
            if ($_ -match 'unable to find type') {
                (Find-Type  ) | Assert-OneOrNone
            }

        }
        $tinfo
        .link
        Get-WhatIsShortTypeName
    .link
        Get-WhatIsShortPSTypeName
    .link
        Resolve-TypeName
    .link
        Resolve-TypeInfo
    .link
        Get-WhatInterfaceTypeInfo
    .link
        Get-WhatGenericTypeInfo
    #>

    #6 WIP
    [Alias('Resolve->TypeInfo')]
    [OutputType('RuntimeType', 'Reflection.TypeInfo', $null)]
    param(
        [Parameter(Mandatory, Position = 0,
            ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [object]$InputObject
    )
    process {
        $obj = $InputObject
        if ($null -eq $obj) {
            return
        }
        if ($obj -is 'type') {
            return $Obj
        }
        $tinfo = $Obj.GetType()
        return $tinfo


    }
}

function Get-WhatGenericTypeInfo {
    #6  nyi
    [Alias('Inspect->GenericInfo')]
    [cmdletbinding()]
    param(
    )
    #6 WIP
    throw "nyi: $PSCommandPath"
}
function Get-WhatInterfaceTypeInfo {
    <#
    .synopsis
        inspect interfaces of type
    .example
        ,@(,'a'), 0.3, 'a', (gi .), (get-date), @{}, [ordered]@{} | whatAmI
        #6
    #>
    [Alias(
        'Inspect->Interface'
        # 'What->Interface'
    )]
    param(
        #6
        # (new issue): custom argument transformations
        #    ->resolveTypeInfo ->resolveTypeName ->resolveValidCommandName
        [AllowEmptyString()]
        [AllowNull()]
        [parameter(ValueFromPipeline, Position = 0, Mandatory)]
        $InputObject
    )
    begin {
        Write-Warning "Finish: '$PSCmdlet' at '$PSCommandPath'"
    }
    process {
        if ($null -eq $InputObject) {
            return
        }

        if ('tempWorkAround-assumestype') {
            [pscustomobject]@{
                FullName     = $_.GetType().FullName
                IsDisposable = $_ -is [System.IDisposable]
            }
            return
        }

        $tinfo = $InputObject | Resolve-TypeName

        $InputObject | _mapFormatShortName

        # $InputObject.GetType().FullName -replace 'System.Collections\.', '' -replace '^System\.', ''
        # $InputObject.GetType().Name
    }
}


function Get-WhatIsShortTypeName {
    <#
    .synopsis
        Minimize output from GetType().FullName
    .example
        ,@(,'a'), 0.3, 'a', (gi .), (get-date), @{}, [ordered]@{} | whatAmI
    .link
        Dev.Nin\Get-WhatIsShortPSTypeName
    .link
        Dev.Nin\Get-WhatIsShortTypeName
    #>
    [Alias('ShortName')]
    param(
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [parameter(ValueFromPipeline, Position = 0, Mandatory)]
        $InputObject
    )
    process {
        if ($null -eq $InputObject) {
            return
        }
        # resolve-TypeInfo
        $tinfo = if ($InputObject -is 'type') {
            $tinfo = $InputObject
        } else {
            $tinfo = $InputObject.GetType()
        }
        $Tinfo | _mapFormatShortName


        $InputObject.GetType()
        # $InputObject | _mapFormatShortName
    }
}

function Get-WhatIsShortPSTypeName {
    <#
    .synopsis
        Minimize output from x.PSTypeNames
    .example

    .link
        Dev.Nin\Get-WhatIsShortPSTypeName
    .link
        Dev.Nin\Get-WhatIsShortTypeName
    #>
    [Alias('ShortPSTypeName')]
    param(
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [parameter(ValueFromPipeline, Position = 0, Mandatory)]
        $InputObject,

        # extra options
        [Parameter()][hashtable]$Options
    )
    begin {
        [hashtable]$Config = @{
            RegexIgnoreList = @(
                'System.MarshalByRefObject'
                'System.Object'
            ) | RegexLiteral
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})
    }
    process {
        if ($null -eq $InputObject) {
            return
        }

        $InputObject.PSTypeNames
        | Where-Object {
            foreach ($re in $Config.RegexIgnoreList) {
                if ($_ -match $re) {
                    return $false
                }
            }
            return $true

        }
        | _mapFormatShortName
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
    begin {
        # Write-Error "Finish: $PSCommandPath"
    }
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

        $meta.type | Format-TypeName -Brackets
        $meta | Format-TypeName -Brackets

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
    Hr
    $sample = ((Get-Command ls).Parameters)
    $tinfo = $sample.GetType()
    $tinfo | HelpFromType -PassThru
    $tinfo.Namespace, $tinfo.name -join '.'
}
