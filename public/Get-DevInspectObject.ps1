function Get-DevInspectObject {
    <#
    .synopsis
    wrapper to run a few inspections on an object
    .notes
        - [ ] better verbs?
        - [ ] maybe add either 'Find-Member' or 'Get-Member'
    #>
    [Alias('Inspect')]
    param(
        # input
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject,

        # Shows more information Detail
        [Parameter()][switch]$Detail

    )

    process {
        'Inspect: "{0}"' -f $InputObject.ToString() | H1
        $InputObject | Prop | Format-Table -AutoSize
        # $maybeChild = @($InputObject)[0]
        $maybeChild = $InputObject | Select-Object -First 1
        [bool]$hasChild = $InputObject.Count -gt 1   # $null -ne $maybeChild


        $InputObject | TypeOf GetType | Label 'Type'
        if ($hasChild) {
            $maybeChild | TypeOf GetType | Label 'Type : Child'
        }


        if ($Detail) {
            $InputObject | TypeOf | Label 'type Names'

            if ($hasChild) {
                @($maybeChild)[0] | TypeOf | Label 'type Names : Child'
            }

            $InputObject.ToString() | Label 'To String()'
            if ($hasChild) {
                $maybeChild.ToString() | Label 'To String() : Child'
            }
        }
    }
}

if ($DebugTestMode) {
    H1 'test case: multi items'
    # (ls .)[0] | inspect
    Get-ChildItem 'c:\' | Get-Unique  -OnType | inspect
    H1 'test case: without child'
    'a' | Inspect
    hr
    'a' | Inspect

    $l = [list[object]]::new()
    $l.add(34)
    $l.Add((Get-Date))
    hr
    , $l | Inspect
    hr
}