$experimentToExport.function += @(
    'Get-CommandNameValue'
)
$experimentToExport.alias += @(
    'ValidArgCommand'
)

function Get-CommandNameValue {
    <#
    .synopsis
        get a valid list of functions, for argument completers
    .description
        future: create a real attribute completer so that it's reusable
    .notes
        currently returns functions that end up as disk drivves

    see also:
        [System.Management.Automation.CommandTypes]
        Alias, All, Application, Cmdlet, Configuration, ExternalScript, Filter, Function, Script

    .outputs

    #>
    [Alias('ValidArgCommand')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Ignore Aliases
        [alias('IgnoreAlias')]
        [Parameter()][switch]$NoAlias,

        # Ignore providers ?
        [alias('IgnoreAlias')]
        [Parameter()][switch]$NoProvider


    )

    begin {}
    process {
        $filesystemNames = Get-PSProvider -PSProvider FileSystem | ForEach-Object Drives
        | ForEach-Object { "${_}:" }

        $excludeNames = @(
            $filesystemNames
        )


        if (! $NoAlias) {
            Get-ChildItem alias:
        }
        $select_funcs = Get-ChildItem function:
        if ($IgnoreDrives) {
            # Testing name for a full match is intended
            $select_funcs = $select_funcs
            | Where-Object name -NotIn $excludeNames
        }
        $select_funcs



    }
    end {}
}


# Get-Module | Where-Object { $_.ExportedCmdlets | ForEach-Object { if ($_.name -match 'nin') { $true } } }
