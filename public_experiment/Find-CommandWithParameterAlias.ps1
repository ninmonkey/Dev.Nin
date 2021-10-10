$experimentToExport.function += 'Find-CommandWithParameterAlias'
$experimentToExport.alias += @(
    'RegexEitherOrder'
    'DevTool💻-Params-FindCommandWithParameterAlias'
)

function Find-CommandWithParameterAlias {
    <#
    .synopsis
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
