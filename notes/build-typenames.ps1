## refactor into "Marking"

$namespaceQuery = @(
    'System.Text'
    'System.Management.Automation'
    'System.Management'
)

# Find-Type -Namespace system.text | ForEach-Object Name
# | str ul -Sort -Unique

# Find-Type -Namespace system.text -Interface

function _exportSingleMDList {
    param([string]$Namespace)

    # $namespace = 'system.management.automation'
    @(

        $namespace | ForEach-Object { $_ -replace '^system\.', '' }
        | str ul
        Find-Type -Namespace $Namespace | ForEach-Object Name
        | str ul -sort -Unique | Format-IndentText -Depth 2
    ) | str nl 0
}

$namespaceQuery | ForEach-Object {
    $item = $_
    h1 "First4: $item" -after 0

    Find-Type -Namespace $item
    | ForEach-Object Name -ov 'all1'
    | f 4 | str ul -sort -Unique

    '- [4] ... of [{0}] ' -f @($all1 | len)





    h1 "First4: alow partial $item" -after 0 -fg magenta

    Find-Type -Namespace "$item*"
    | ForEach-Object Name -ov 'all2'
    | f 4 | str ul -sort -Unique

    h1 '-Inherit Enum'
    Find-Type -InheritsType 'enum' | Get-Random -Count 4 | ForEach-Object name | str ul -op 'enums'
    Find-Type -ImplementsInterface System.Collections.IEnumerable

    # find-type -Namespace system.text -Interface



}
# ```ps1

# 🐒> gcm * | Get-Unique -OnType | % gettype |  % fullname | str ul -Sort -Unique

# - System.Management.Automation.AliasInfo
# - System.Management.Automation.ApplicationInfo
# - System.Management.Automation.CmdletInfo
# - System.Management.Automation.ExternalScriptInfo
# - System.Management.Automation.FilterInfo
# - System.Management.Automation.FunctionInfo
# ```