
$experimentToExport.function += @(
    'Get-PropertyNameCompleter'
)
$experimentToExport.alias += @(

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
