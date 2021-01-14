

function Get-DevParameterInfo {
    <#
    .synopsis
        wrapper for 'PSScriptTools\Get-ParameterInfo'
    #>
    [Alias('ParamInfo')]
    param(
        # Command
        [Parameter(Mandatory, Position = 0)]
        [string[]]$Command,

        # parameterList
        [Parameter(Position = 1)]
        [string[]]$ParameterName = '*'
    )

    begin {
        try {
            Get-Command 'PSScriptTools\Get-ParameterInfo' -ea stop | Out-Null
        } catch {
            "Requires: 'PSScriptTools\Get-ParameterInfo'"
        }
    }
    process {

        $Command | ForEach-Object {
            $curCommand = $_

            $ParameterName = $ParameterName | Sort-Object

            # $PSBoundParameters | Format-HashTable -Title 'PSBoundParams'
            # | Write-Information | Write-Host

            # $ParameterName | Join-String -sep ', ' -SingleQuote | Label '$ParameterNames'
            # | Write-Information | Write-Host

            $ParameterName  | ForEach-Object {
                $curParam = $_
                Get-ParameterInfo -Command $curCommand -Parameter $curParam
            } | Sort-Object ParameterSet

        }

        # $ParameterName  | ForEach-Object {
        #     $splat_ParamInfo = @{
        #         Command   = $Command
        #         Parameter = $ParameterName
        #     }

        #     Get-ParameterInfo @splat_ParamInfo
    }

}


$Result = Get-DevParameterInfo 'Get-Module'  'All', 'ListAvailable' -InformationAction Continue
# | Format-Table

$Result | Format-Table