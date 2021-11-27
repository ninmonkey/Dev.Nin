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
       'Sum∑ -WithoutMeasureObject' will add objects, like timespans
        without errors, or explicitly specifying property names.
        See example:
    .example
          .
          $results
        | Measure-Object -Sum -Property TotalMilliseconds
        | ForEach-Object sum
    
        # this works
            
            $results
            | Sum∑ -WithoutMeasureObject

        # same usage of measure-object throws execption

            $results
            | Measure-Object -Sum | ForEach-Object sum

            Error: Measure-Object: 
                Input object "00:00:00.0050233" is not numeric.

        # to resolve that, explicitly use a property

            $results
            | Measure-Object -Sum -Property TotalMilliseconds
            | ForEach-Object sum

    .outputs
          [string | None]

    #>
    [Alias('Sum∑')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory, Position = 0, valueFromPipeline)]
        [object[]]$InputObject,

        # Sum objects with the += operator, verses using measure-object -Sum
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

