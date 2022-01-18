#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Test-CommandHasParameterNamed'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

function Test-CommandHasParameterNamed {
    <#
    .synopsis
        Quick test if a parameter exists, without throwing
    .description
        sugar for:
            (Get-Command 'Set-PSReadLineOption'
            | ForEach-Object Parameters | ForEach-Object keys) -contains 'PredictionViewStyle'
    .notes
        future: move to ninmonkey/Testning

    .example
        Test-CommandHasParameterNamed -Command 'Microsoft.PowerShell.Management\Get-ChildItem' -Param 'Path'
    .example
        Test-CommandHasParameterNamed 'ls' -Param 'Path'
    #>
    [outputType([System.Boolean])]
    [CmdletBinding(DefaultParameterSetName = 'TestNamed')]
    param(
        # Which command ? # future: complete command names
        [ALias('Name')]
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'TestNamed')]
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'ListNames')]
        [string]$CommandName,

        # Give the parameter name
        [Parameter(
            Mandatory, Position = 1, ValueFromPipeline,
            ParameterSetName = 'TestNamed'
        )]
        [string]$ParameterName,

        # enumerate possible parameters
        [Parameter(Mandatory, ParameterSetName = 'ListNames')]
        [switch]$List
    )
    process {
        # sugar for:
        #     (Get-Command 'Set-PSReadLineOption'
        #     | ForEach-Object Parameters | ForEach-Object keys) -contains 'PredictionViewStyle'
        switch ($PSCmdlet.ParameterSetName) {
            'TestNamed' {
                $cmd = rescmd $CommandName
                $cmd.Parameters.Keys -contains $ParameterName

            }
            'ListNames' {
                $cmd = rescmd $CommandName
                $cmd.Parameters.Keys | Sort-Object -Unique

            }

            default {
                Write-Error -Message "Unhandled ParameterSet: $($PSCmdlet.ParameterSetName) at '$($PSCommandPath)'" #-TargetObject $PSCmdlet
            }
        }

    }
}

if (! $experimentToExport) {
    # ...
}
