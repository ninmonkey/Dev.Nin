
$experimentToExport.function += 'Where-EmptyProperty'
$experimentToExport.alias += 'whereEmptyProp'



function Where-EmptyProperty {
    <#
    .synopsis
        Abstract, test if any of these props are empty, or at least [string]::IsNullOrWhiteSpace()
    .description
        Desc
    .outputs

    #>
    [Alias('whereEmptyProp')]
    [CmdletBinding(PositionalBinding = $false, DefaultParameterSetName = 'WeakCompare')]
    param(
        # Property Name
        [Parameter(Mandatory, Position = 0)]
        [string[]]$PropertyName,

        # Only return true if it's exactly equal to $null
        [Parameter(ParameterSetName = 'ExactCompare', Mandatory)][switch]$ExactlyNull,

        # InputObject
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject
    )

    begin {

    }
    process {
        Write-Warning 'total rewrite, this is ancient'

        $foundAnyNull = $false

        $PropertyName | ForEach-Object {
            $curPropName = $_
            switch ($PSCmdlet.ParameterSetName) {
                'ExactCompare' {
                    if ($null -eq $InputObject.$curPropName) {
                        $isNotEmpty = $true
                        return
                    }
                    break
                }

                default {
                    throw "Unhandled ParameterSet: $($PSCmdlet.ParameterSetName)"
                }
            }

        }
        # empty is success for this command
        if ($foundAnyNull) {
            $InputObject
        }
        else {

        }
    }
    end {}
}
