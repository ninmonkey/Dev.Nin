$experimentToExport.function += @(
    'Measure-NinSum'
)
$experimentToExport.alias += @(
    'Sum∑'
)

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
        [object[]]$InputObject
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
        $inputList | Measure-Object -Sum | % Sum
    }
}