#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Measure-NinSum'
    )
    $experimentToExport.alias += @(
        'Sum∑'
    )
}


function Measure-NinSum {
    <#
    .synopsis
        Sugar for summation. Does not explicitly modify types.
    .description
       .
    .example
          .
    .outputs
          [string | None]

    #>
    [Alias('Sum∑')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory, Position = 0, valueFromPipeline)]
        [object[]]$InputObject,

        [Alias('WithoutMeasureObject')]
        [Parameter()] 
        [switch]$UseNativeOperators
    )

    begin {
        $inputList = [list[object]]::new()
    }
    process {
        $InputObject | ForEach-Object {
            $inputList.Add( $_ )
        }
    }
    end {
        if (! $UseNativeOperators) {
            $inputList | Measure-Object -Sum | ForEach-Object Sum
            return 
        }

        $accum = $inputList | Select-Object -First 1        
        $rest = $inputList | Select-Object -Skip 1
        @{
            accum = $accum
            rest  = $rest | str Csv
        } | format-dict | Write-Information
        $rest | ForEach-Object {
            @(
                $accum
                $accum += $_
                $accum
            ) | Join-String -sep ' -> ' | Write-Debug
        }        
        $accum
        
        
    }
}

if (! $experimentToExport) {
    # 'hi'
    # ...
    0..4 | ForEach-Object {
        Measure-Command -InputObject 'x' -Expression { Get-ChildItem . }
    } | ForEach-Object totalmilliseconds | Sum∑ -WithoutMeasureObject:$false
    hr
    0..4 | ForEach-Object {
        Measure-Command -InputObject 'x' -Expression { Get-ChildItem . }
    } | ForEach-Object totalmilliseconds | Sum∑ -WithoutMeasureObject
}

