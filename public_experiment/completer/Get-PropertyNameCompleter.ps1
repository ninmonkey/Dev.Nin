
$experimentToExport.function += @(
    'Get-PropertyNameCompleter'
)
$experimentToExport.alias += @(
    'Completer.PropName'
)

function Get-PropertyNameCompleter {
    <#
    .synopsis
        Stuff
    .description
       .
    .example
          .
    .outputs
          [string | None]

    #>
    [Alias('Completer.PropName')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter( Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )

    begin {}
    process {
        $InputObject | IterProp
        | ForEach-Object Name | Sort-Object -Unique
    }
    end {}
}

# Write-Error 'nyi paste'
