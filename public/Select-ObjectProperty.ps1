function Sort-ObjectProperty {
    <#
    .synopsis
        sort objects using properties in-order of selection in 'Out-Fzf'
    #>

}
function Select-ObjectProperty {
    <#
    .synopsis
        select properties of an object using 'Out-Fzf'
    #>
    param(
        # Object
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [object]$InputObject
    )

    begin {
        $isFirstRun = $true
    }
    process {
        if ($isFirstRun) {
            $isFirstRun = $false

            $PropList = $InputObject.psobject.properties.Name
            if(
                (! $PropList ) -or ($PropList.count -le 0)
            ) {
                throw "NoPropertiesException: [$($inputObject.GetType().FullName)] $($InputObject) found no properties."
            }
            $SelectedProps = $PropList | Out-Fzf -MultiSelect
        }
        $SelectedProps | Join-String -sep ', ' -SingleQuote | Write-Debug

        $InputObject | Select-Object -Property $SelectedProps
    }
    end {

    }
}

if($DebugRunTests) {
    { 4 | Select-ObjectProperty }
    | Should -Throw -Because 'no psobject.properties on [int]'
}

'4' | Select-ObjectProperty
# Get-ChildItem . | Select-Object -First 1 | Select-ObjectProperty
# @() | Select-ObjectProperty
# @(3) | Select-ObjectProperty
# $null | Select-ObjectProperty