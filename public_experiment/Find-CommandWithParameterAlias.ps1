$experimentToExport.function += 'Find-CommandWithParameterAlias'
# $experimentToExport.alias += 'RegexEitherOrder'

function Find-CommandWithParameterAlias {
    <#
    .synopsis
        filter commands that do not have at least one alias
    .description
        .
    .example
        PS> Get-NinCommand | Get-ParameterInfo | ? Aliases | Ft
    .notes
        .
    #>
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
