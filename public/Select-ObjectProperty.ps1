
function Select-ObjectProperty {
    <#
    .synopsis
        select properties of an object using 'Out-Fzf'
    .link
        Where-FzfSelectObject
    #>
    [Alias('SelectProp')]
    [cmdletbinding()]
    param(
        # Object
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [object]$InputObject
    )

    begin {}
    process {

        $PropList = $InputObject.psobject.properties.Name
        if (
            (! $PropList ) -or ($PropList.count -le 0)
        ) {
            throw "NoPropertiesException: [$($inputObject.GetType().FullName)] $($InputObject) found no properties."
        }
        $SelectedProps = $PropList | Out-Fzf -MultiSelect -PromptText 'Select Properties'

        $SelectedProps | Join-String -sep ', ' -SingleQuote | Write-Debug

        $InputObject | Select-Object -Property $SelectedProps
    }
    end { }
}

if ($DebugRunTests) {
    { 4 | Select-ObjectProperty }
    | Should -Throw -Because 'no psobject.properties on [int]'
    Hr
    '4' | Select-ObjectProperty
}

# Get-ChildItem . | Select-Object -First 1 | Select-ObjectProperty
# @() | Select-ObjectProperty
# @(3) | Select-ObjectProperty
# $null | Select-ObjectProperty
