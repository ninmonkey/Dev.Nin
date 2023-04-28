#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Resolve-TypeName'
    )
    $experimentToExport.alias += @(
        'FullName'      # 'Resolve-TypeName'
        'To->TypeName'  # 'Resolve-TypeName'
    )
}


function Resolve-TypeName {
    <#
    .SYNOPSIS
        Resolve a type's FullName from an instance, a 'type', typename as a string, or using wildcards.
    .description
        If type isn't found, it will use a wildcard search using 'ClassExplorer\Find-Type'

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

    .notes
        future:
            - [ ] optionally run output through [Format-TypeName] to strip extra 'AssemblyQualifiedName' info

        related:
            [AppDomain]::CurrentDomain.GetAssemblies()
            [System.Management.Automation.PSTypeName]

            /EditorServicesCommandSuite/Reflection/MemberUtil.cs | ResolveTypes
            https://github.com/SeeminglyScience/EditorServicesCommandSuite/blob/52d079f6de0c00eb66034acd940fa3abf520d039/src/EditorServicesCommandSuite/Inference/InferenceExtensions.cs#L160

    .example
        PS>  # partial finds

        $foo | FullName
        $foo.GetType() | FullName
        'Toast*' | FullName
        'ConsoleColor' | FullName
    #>

    [CmdletBinding(  )]
    [Alias(
        'FullName',
        'To->TypeName'
    )]
    [OutputType([String])]

    Param (
        # you pass an object, name as text, a type instance, or even type name as a wildcard , name, string, instance
        # or even strings with wildcards
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [object]$InputObject

        # # Copy to clipboard
        # [alias('Clip')]
        # [Parameter()][switch]$SetClipboard

        # also check first element?
        # [Parameter()]
        # [switch]$IncludeChild


    )

    begin {
        # function _maybeExport {
        #     param()
        #     if ($SetClipboard) {
        #         $InputObject.GetType().Fullname | Set-Clipboard
        #     }
        # }
    }

    process {

        # original was stable
        if ($False) {
            #
            # function _resolveTypeInfo {
            #     # resolve as typeinfo
            #     param( $Type )
            #     $tinfo = if ($Type -is 'type') {
            #         $Type
            #     } else {
            #         ($Type)?.GetType() ?? "`u{2400}"
            #     }
            #     return $tinfo
            # }
        }

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
        hr
        return

        $isAType = $inputObject -as 'type' -is 'type'
        if (! $isAType ) {
            $tinfo = $InputObject.GetType()
        }
        $tinfo = $inputObject -as 'type'
        $tinfo = if ($InputObject -is 'type') {
            $Input
        }
        # if )


        Write-Warning 'jumping to old code'

        # type of type isn't useful here, so use typeinfo [RuntimeType] ?
        if ($InputObject -is 'type') {
            $InputObject.GetTypeInfo().Fullname
            return
        }
        # Assume strings are real types
        if ($InputObject -is 'string') {
            # if in the namespace
            $maybeTypeName = $InputObject -as 'type'
            if ($maybeTypeName) {
                $maybeTypeName.FullName
                return
            }
            $maybeTypeName = ClassExplorer\Find-Type -Name $InputObject
            if ($maybeTypeName.Count -eq 1) {
                $maybeTypeName.FullName
                return
            } elseif ( $maybeTypeName.Count -gt 1) {
                Write-Verbose "$($maybeTypeName.Count) matches found"
                $maybeTypeName.FullName
                return
            } else {
                ''.GetType().FullName
                return
            }
        }
        # it's a typeinfo, string, or string-wildcard
        $InputObject.GetType().Fullname
        return
    }

    end {
        # $Output | Sort-Object -Unique # did not work.
    }
}


if (! $experimentToExport) {
    # ...
}
