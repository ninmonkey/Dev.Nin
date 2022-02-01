#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Get-PropertyNameCompletionsName'
        'Get-PropertyTypeNameCompletionsName'
    )
    $experimentToExport.alias += @(
        'Completions->PropName' # 'Get-PropertyNameCompletionsName'
        'Completions->PropType' # 'Get-PropertyTypeNameCompletionsName'

        'Completions->PropertyName' # 'Get-PropertyNameCompletionsName'
        'Completions->PropertyTypeName' # 'Get-PropertyTypeNameCompletionsName'
    )
}



function Get-PropertyNameCompletionsName {
    <#
    .synopsis
        Names of Properties
    .notes
        future: optionally -> sort -unique or | select -first 1 uniques
        future: include Membernames
    .description
       .
    .example
          .
    .link
        Dev.Nin\Get-PropertyNameCompletionsName
    .link
        Dev.Nin\Get-PropertyTypeNameCompletionsName
    .outputs
          [string | None]

    #>
    [Alias(
        'Completions->PropertyName',
        'Completions->PropName'
    )]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter( Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject

        # automatically collect pipeline, returning uniques
        # [switch]$Unique
    )

    begin {
    }
    process {
        $InputObject | Dev.Nin\Iter->Prop | ForEach-Object Name | Sort-Object -Unique
    }
    end {
    }
}

function Get-PropertyTypeNameCompletionsName {
    <#
    .synopsis
        TypeNames of Properties of an object
    .description
       .
    .notes
        future: optionally -> sort -unique or | select -first 1 uniques
        future: include Membernames
    .example
          .
    .link
        Dev.Nin\Get-PropertyNameCompletionsName
    .link
        Dev.Nin\Get-PropertyTypeNameCompletionsName
    .outputs
          [string | None]

    #>
    [Alias(
        'Completions->PropType',
        'Completions->PropertyTypeName'
    )]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter( Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )

    begin {
    }
    process {
        $InputObject | Dev.Nin\Iter->Prop | ForEach-Object TypeNameOfValue | Sort-Object -Unique
    }
    end {
    }
}


if (! $experimentToExport) {
    # ...
}
