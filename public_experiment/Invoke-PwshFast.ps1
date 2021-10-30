$experimentToExport.function += @(
    'Invoke-PwshFast'
)
$experimentToExport.alias += @(
    'PwshFast'
)

function Invoke-PwshFast {
    <#
    .synopsis
        wrapper to call Pwsh externally with simplified args
    .description
        sugar for 'pwsh -Nol -File foo.ps1'
    .example
        🐒> _findEnvPattern do
    #>
    [cmdletbinding()]
    [Alias('PwshFast')]
    param(
        [Alias('Path')]
        [parameter(Mandatory, position = 0)]
        [string]$FilePath,

        [Alias('Rest')]
        [parameter(ValueFromRemainingArguments, position = 1)]
        [string]$RemainingArgs
    )
    process {
        $binPwsh = Get-NativeCommand 'pwsh'
        $pwshArgs = @(
            '-NoL', '-NoP'
            '-File'
            $FilePath
            if ($RemainingArgs) {
                $RemainingArgs
            }
        )
        "bin: $binPwsh"
        | Write-Debug

        $pwshArgs | Join-String -sep ' ' -op 'Args: '
        | Write-Debug
        & $binPwsh @pwshArgs
    }
}