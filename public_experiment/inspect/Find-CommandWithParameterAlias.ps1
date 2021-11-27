$experimentToExport.function += 'Find-CommandWithParameterAlias'
$experimentToExport.alias += @(
    'DevTool💻-Params-FindCommandWithParameterAlias'
)

function Find-CommandWithParameterAlias {
    <#
    .synopsis
        Find-Command's that have Parameter-Aliases.  (not command aliases)
        filter commands that do not have at least one alias
    .description
        .
    .notes
        .
    .example
        PS> Get-NinCommandProxy | Get-ParameterInfo | ? Aliases | Ft
        PS> gcm * -Module (_enumerateMyModule)
            |  DevTool💻-Params-FindCommandWithParameterAlias | ft -AutoSize
    .example
        PS> gcm -Module (_enumerateMyModule) | Find-CommandWithParameterAlias | ft -AutoSize
    .link
        Dev.Nin\Find-CommandWithParameterAlias
    .link
        Ninmonkey.Console\Get-NinAlias
    #>
    [ALias('DevTool💻-Params-FindCommandWithParameterAlias')]
    [cmdletbinding(PositionalBinding = $false)]
    param (
        #
        [Parameter(Position = 0, ValueFromPipeline)]
        [string]$Name
    )
    begin {}
    process {
        Get-Command $Name | Get-ParameterInfo | Where-Object Aliases
    }
    end {}
}
