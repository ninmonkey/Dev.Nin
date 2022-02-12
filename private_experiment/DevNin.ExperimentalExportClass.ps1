using namespace System.Colections.Generic

# see: <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes?view=powershell-7#example-simple-class-with-properties-and-methods>
# future: Use namespace devnin or nin, and rename ExperimentalExport to something else?
class DevNinExperimentalExport {
    # note: linter can't seem to resolve namespaces for class member types
    [Collections.Generic.List[object]]$Function
    [Collections.Generic.List[object]]$Alias
    [Collections.Generic.List[object]]$Cmdlet
    [Collections.Generic.List[object]]$Variable
    [Collections.Generic.List[scriptblock]]$TypeDataInit
    # [Collections.Generic.List[object]]$Meta
    # [Collections.Generic.List[object]]$ExperimentFuncMetadata
}
# tod
[DevNinExperimentalExport]$DevExport = [DevNinExperimentalExport]::new()


# [hashtable]$script:__registeredModules = @{

class AutoloaderComponent {
    # module as in groupings, not true individual modules
    [IO.FileInfo]$Filepath
    [Collections.Generic.list[string]]$Functions = [Collections.Generic.list[string]]::new()
    # could also have auto-collected func info and AST
    # maybe that's the difference

    [Collections.Generic.list[string]]$Aliases = [Collections.Generic.list[string]]::new()
    [string[]]$Tags
    [boolean]$Enabled = $false

    # future implementation
    <#
    [Collections.Generic.list[string]]$TypeData = [Collections.Generic.list[string]]::new()
    [Collections.Generic.list[string]]$FormatData = [Collections.Generic.list[string]]::new()
    [Collections.Generic.list[ScriptBlock]]$ConstructorScript = [Collections.Generic.list[ScriptBlock]]::new()
    [Collections.Generic.list[ScriptBlock]]$DestructorScript = [Collections.Generic.list[ScriptBlock]]::new()
    #>
}

class AutoloadModuleManager {
    [Collections.Generic.list[AutoloaderComponent]]$Modules = [Collections.Generic.list[AutoloaderComponent]]::new()
}
