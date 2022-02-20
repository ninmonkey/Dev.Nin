using namespace Management.Automation

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'New-TypeInfo'
    )
    $experimentToExport.alias += @(
        'asType'
    )
}

function New-TypeInfo {
    <#
    .synopsis
        Converts text to type instances, otherwise don't change existing type
    .description
       shorthand for when you have to do
       | %{ $_ -as 'type' }
    .example
          .
    .outputs
          [string | None]

    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Alias('Name')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )

    begin {
    }
    process {
        if ($_ -is 'type') {
            Write-Debug "Already a type: $InputObject"
            $InputObject
            return
        }
        $typeInstance = $_ -as 'type'
        if ($null -eq $typeInstance) {
            Write-Error "Failed to convert to a type: '$TypeInstance'"
        }
        $typeInstance
    }
    end {
    }
}
