$experimentToExport.function += @(
    'Invoke-MiniFuncDump'
)
$experimentToExport.alias += @(
    'InvokeFuncDump'
)

try {    
    $script:__miniFuncDump ??= @{}
    $state = $script:__miniFuncDump ?? @{}

    $state.HistoryFastPrint = {
        Get-History | Join-String -sep "`n`n$(hr)" -Property CommandLine
    }

} catch {
    Write-Warning "funcDumpErrorOnLoad: $_"    
}
function Invoke-MiniFuncDump {
    <#
    .synopsis
        1-liners or random one-offs not worth making a class
    .description
       .
    .example
          .
    .outputs
          [string | None]
    
    #>
    [Alias('InvokeFuncDump')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Alias('Name')]
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompletions('HistoryFastPrint')]
        [string]$ScriptName
    )
    
    begin {}
    process {
        $state = $script:__miniFuncDump
        if (! $State.ContainsKey($InputObject)) {
            Write-Error -ea stop "No matching keys: '$_'"
            return
        }
        
        try {        
            & $state[$ScriptName]
            return
        } catch {
            Write-Error "SBFailed: $_"
            return
        }

       
    }
    end {}
}

