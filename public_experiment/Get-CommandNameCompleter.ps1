$experimentToExport.function += @(
    'Get-CommandNameCompleter'
)
$experimentToExport.alias += @(
    'ValidArgCommand'
)

function Get-CommandNameCompleter {
    <#
    .synopsis
        get a valid list of functions, for argument completers
    .description
        future: create a real attribute completer so that it's reusable
    .notes
        future:
            - [ ] return a completion result kind with tooltip

        currently returns functions that end up as disk drives

    see also:
        [System.Management.Automation.CommandTypes]
        Alias, All, Application, Cmdlet, Configuration, ExternalScript, Filter, Function, Script

    .outputs
        either [string] or [Management.Automation.CommandInfo] with -passthru
    #>
    [Alias('ValidArgCommand')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Ignore Aliases
        [alias('IgnoreAlias')]
        [Parameter()][switch]$NoAlias,

        # Ignore providers ?
        [alias('IgnoreProvider')]
        [Parameter()][switch]$IgnoreDrives,

        # If not passthru, then return completer with tooltips, otherwise full command object
        [Parameter()][switch]$PassThru
    )

    begin {}
    process {
        $filesystemNames = Get-PSProvider -PSProvider FileSystem | ForEach-Object Drives
        | ForEach-Object { "${_}:" }

        $excludeNames = @(
            $filesystemNames
        )


        if (! $NoAlias) {
            if ($PassThru) {
                Get-ChildItem alias:
            } else {
                Get-ChildItem alias: | ForEach-Object Name
            }
        }
        $select_funcs = Get-ChildItem function:
        if ($IgnoreDrives) {
            # Testing name for a full match is intended
            $select_funcs = $select_funcs
            | Where-Object name -NotIn $excludeNames
        }
        if ($PassThru) {
            $select_funcs
        } else {
            $select_funcs.Name

        }
    }
    end {}
}


# Get-Module | Where-Object { $_.ExportedCmdlets | ForEach-Object { if ($_.name -match 'nin') { $true } } }
