$ValidValues = @('apple', 'banana', 'etc')
$ValidValues = Get-Module 'ninmonkey*' | ForEach-Object name | Sort-Object -Unique


function Get-DevModule {
    [Alias('Get-DevModule')]
    param (
        # Module to get
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter( {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)
                return $ValidValues -like "$WordToComplete*"
            }
        )]
        [string[]]$Fruit

        # [-ListAvailable]
    )


    process {
        $PSBoundParameters | Format-HashTable -Title 'PSBoundParams' | Write-Debug
        $Fruit | Join-String -sep "`n- " -OutputPrefix "`n- " | Label 'FruitNames'
    }

}

throw "WIP: autocomplete my modules, allow any"

<#
Get-DevModule nin*

Get-Module [[-Name] <string[]>] -CimSession <CimSession>
[-FullyQualifiedName <ModuleSpecification[]>]
 [-SkipEditionCheck] [-Refresh]
[-CimResourceUri <uri>] [-CimNamespace <string>]
[<CommonParameters>]
#>