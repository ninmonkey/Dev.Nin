$experimentToExport.function += @(
    'Get-CommandNameCompleter'
)
$experimentToExport.alias += @(
    # 'ValidArgCommand'
    'MyGcm🐒'
    # 'Completer.Command'
    'Completer.CommandNin🐒'
)

function Get-CommandNameCompleter {
    <#
    .synopsis
        get a valid list of functions, for argument completers.
    .description
        returns just the name, unless using -passthru
        future: create a real attribute completer so that it's reusable

        with -PassThru:
            returns [ [FunctionInfo] | [AliasInfo] ]

            object instances of commands/function/aliases

        without -PassThru:
            name of command

            return [string]


        return [string] or [ [FunctionInfo] | [AliasInfo] | .. ]

        also try
                🐒> MyGcm🐒 * -PassThru | len
                263

                🐒> gcm * -ListImported | len
                2570

                🐒> gcm * | len
                7530

    .example
        🐒> MyGcm🐒 *item* | sort source, name | ft -AutoSize

            _FormatDictItem_Filepath
            Dev-GetNewestItem
            Find-DevItem
            Find-EnvVarItem
            Find-FDNewestItem
            Format-ChildItemSummary

    .example
        🐒> MyGcm🐒 *item* -PassThru | sort source, name | ft -AutoSize


            CommandType Name                     Version Source
            ----------- ----                     ------- ------
            Function    _FormatDictItem_Filepath 0.0.7   dev.nin
            Function    Dev-GetNewestItem        0.0.7   dev.nin
            Function    Find-DevItem             0.0.7   dev.nin
            Function    Find-EnvVarItem          0.0.7   dev.nin
            Function    Get-NinChildItem         0.1.1   Ninmonkey.Console
            Function    Measure-NinChildItem     0.1.1   Ninmonkey.Console
            Function    Get-ItemType             0.0.1   Ninmonkey.Powershell



    .notes
        future:
            - [ ] return a completion result kind with tooltip

        currently returns functions that end up as disk drives

    see also:
        [System.Management.Automation.CommandTypes]
        Alias, All, Application, Cmdlet, Configuration, ExternalScript, Filter, Function, Script
    .link
        Dev.Nin\Get-NinCommand

    .outputs
        either [string] or [Management.Automation.CommandInfo] with -passthru
    #>
    [Alias(
        'ValidArgCommand', 'Completer.Command',
        'Completer.CommandNin🐒', # smart alias
        'MyGcm🐒' # smart alias
    )]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Partial Text matching
        [Parameter(Position = 0)]
        [string]$Name,

        [Parameter()]
        [ValidateSet('Provider', 'Get-Command')]
        [string]$QuerySource,





        # Match module names
        # [alias('IgnoreAlias')]
        [Parameter()][string[]]$ModuleName,

        # Ignore Aliases
        [alias('IgnoreAlias')]
        [Parameter()][switch]$NoAlias,

        # Ignore providers ?
        [alias('IgnoreProvider')]
        [Parameter()][switch]$IgnoreDrives,

        # If not passthru, then return completer with tooltips, otherwise full command object
        [Parameter()][switch]$PassThru
    )

    begin {
        if ($PSCmdlet.MyInvocation.InvocationName -in @('MyGcm🐒', 'Completer.CommandNin🐒')) {
            $ModuleName += _enumerateMyModule
        }
    }
    process {
        if ($QuerySource -eq 'Get-Command') {
            Write-Error 'ShouldBe $PSCmdlet.ThrowTerminatingError()' ; return;
            # $PSCmdlet.ThrowTerminatingError()
        }
        $filesystemNames = Get-PSProvider -PSProvider FileSystem | ForEach-Object Drives
        | ForEach-Object { "${_}:" }

        $excludeNames = @(
            $filesystemNames
        )

        $select_alias = @()
        # if (! $NoAlias) {
        #     $select_alias = if ($PassThru) {
        #         Get-ChildItem alias:
        #     } else {
        #         Get-ChildItem alias: | ForEach-Object Name
        #     }
        # }
        $select_funcs = Get-ChildItem function:

        if (! [string]::IsNullOrWhiteSpace($Name)) {
            $select_funcs = $select_funcs | Where-Object Name -Like "*$Name*"
            $select_alias = $select_alias | Where-Object Name -Like "*$Name*"
        }
        if ($IgnoreDrives) {
            # Testing name for a full match is intended
            $select_funcs = $select_funcs
            | Where-Object name -NotIn $excludeNames
        }

        $select_alias = $select_alias | Sort-Object Name
        $select_funcs = $select_funcs | Sort-Object Name

        if ($ModuleName) {
            $select_alias = $select_alias | Where-Object {
                $_.Source -in $ModuleName
            }
            $select_funcs = $select_funcs | Where-Object {
                $_.Source -in $ModuleName
            }
        }

        if ($PassThru) {

            $select_alias
            $select_funcs

            return
        }

        $select_alias.Name
        $select_funcs.Name
    }

    end {}
}

# hr
# Get-CommandNameCompleter sysinternal -PassThru

# hr
# Get-CommandNameCompleter sysinternal
# Get-Module | Where-Object { $_.ExportedCmdlets | ForEach-Object { if ($_.name -match 'nin') { $true } } }
