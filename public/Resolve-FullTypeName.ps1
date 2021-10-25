
function Resolve-FullTypeName {
    <#
    .SYNOPSIS
        Resolve a type's FullName from an instance, a 'type', typename as a string, or using wildcards.
    .description
        If type isn't found, it will use a wildcard search using 'ClassExplorer\Find-Type'
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

    [CmdletBinding( SupportsShouldProcess, PositionalBinding = $false)]
    [Alias('Fullname')]
    [OutputType([String])]

    Param (
        # you pass an object, name as text, a type instance, or even type name as a wildcard , name, string, instance
        # or even strings with wildcards
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [object]$InputObject,

        # Copy to clipboard
        [alias('Clip')]
        [Parameter()][switch]$SetClipboard

        # also check first element?
        # [Parameter()]
        # [switch]$IncludeChild


    )

    begin {
        function _maybeExport {
            param()
            if ($SetClipboard) {
                $InputObject.GetType().Fullname | Set-Clipboard
            }
        }
    }

    process {

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
            }
            elseif ( $maybeTypeName.Count -gt 1) {
                Write-Verbose "$($maybeTypeName.Count) matches found"
                $maybeTypeName.FullName
                return
            }
            else {
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
