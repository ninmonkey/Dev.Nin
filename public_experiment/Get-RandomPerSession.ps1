$experimentToExport.function += @(
    'Get-RandomPerSession',
    'Reset-RandomPerSession'
)
$experimentToExport.alias += @(
    'RandPerSess',
    'ResetAllSessRand'
)
[hashtable]$__randPerSession ??= @{}

function Reset-RandomPerSession {
    <#
    .synopsis
        Reset / forget a value
    .notes
        future: reset automatically after a certain time has passed
    .example
        PS> Reset-RandomPerSession -key 'BGColor'
    #>
    [CmdletBinding(PositionalBinding = $false,
        DefaultParameterSetName = 'ClearSingle')]
    param(
        # Keyname of value to forget
        [Alias('Name')]
        [Parameter(
            ParameterSetName = 'ClearSingle',
            Mandatory, Position = 0)]
        [string]$KeyName,

        # reset everything
        [Alias('All')]
        [Parameter(ParameterSetName = 'ClearAll')]
        [switch]$ResetAll
    )
    end {

        switch ($PSCmdlet.ParameterSetName) {
            'ClearAll' {
                $__randPerSession.Clear()
                Write-Debug 'Cleared All Values'
                break
            }
            'ClearSingle' {
                if (! $__randPerSession.ContainsKey($KeyName) ) {
                    return
                }
                $__randPerSession.Remove($KeyName)
                Write-Debug "Removed Key '$KeyName'"
            }
            default {}
        }
    }
}
function Get-RandomPerSession {
    <#
    .synopsis
        Random value from the ScriptBlock/pipeline, else, return the cached value original random value
    .description
        this is sort-of-a lazyEval Cached value pattern, but not exactly.
        for modes, choose between
            -ListKeyName
            -AllValues
            -Key Name -ScriptBlock $Sb -Num 3
            -Key Name -Value $val -Num 3

    .example
        PS> Get-RandomPerSession -key 'BGColor'
    .example
        # Create a single random color
        🐒> Get-RandomPerSession 'color.fg' { ls fg: }
    .example
        # Create a list of 8 colors
        🐒> Get-RandomPerSession 'colorList.fg' -Count 8 { ls fg: }

    .example

    .outputs
        [object]
    #>
    [CmdletBinding(
        PositionalBinding = $false,
        DefaultParameterSetName = 'SetOrGetKey'
    )]
    param(
        # Keyname of value to forget
        [Alias('Label')]
        [Parameter(
            ParameterSetName = 'SetOrGetKey',
            Mandatory, Position = 0)]
        [string]$Name,

        # Random count
        [Alias('Number')]
        [Parameter(
            ParameterSetName = 'SetOrGetKey')]
        [ValidateScript( { $_ -gt 0 })]
        [int]$Count = 1,

        # Only invoke once, if value already exists
        [ValidateNotNull()]
        [Parameter(
            ParameterSetName = 'SetOrGetKey',
            Mandatory, Position = 1)]
        [ScriptBlock]$ScriptBlock,

        # list stored key names
        [Alias('Keys')]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'ListAllKeys')]
        [switch]$ListKeys,

        # list stored Pairs
        [Alias('Pairs', 'All')]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'ListAllKeyValuePairs')]
        [switch]$ListPairs
    )

    end {
        try {

            switch ($PSCmdlet.ParameterSetName) {
                'ListAllKeyValuePairs' {
                    $__randPerSession.GetEnumerator()
                    return
                }
                'ListAllKeys' {
                    $__randPerSession.Keys
                    return
                }
                'SetOrGetKey' {
                    break
                }
                default {
                    Write-Error "Unhandled ParameterSet: $($PSCmdlet.ParameterSetName)"
                    return
                }
            }
            if ($PSCmdlet.ParameterSetName -eq 'ListAllKeys') {
                $__randPerSession.Keys
                return
            }
            if ($__randPerSession.ContainsKey($Name)) {
                Write-Debug "Using Cached Key '$Name'"
                $__randPerSession[$Name]
                return
            }
            Write-Warning 'todo: test if exception in SB is safe'
            $lazyTimer = Get-Date
            Write-Debug "Evalating new Cached Key '$Name'"
            $now = (Get-Date)

            $NewValue = & $ScriptBlock | Get-Random -Count $Count
            "Evaluated Key '$Name', Count: $Count in {0:n2} seconds" -f @(
                $now - $lazyTimer
            ).TotalSeconds | Write-Debug

            if ($null -eq $NewValue) {
                Write-Debug 'Evaluated as null'
                $exception = [System.ArgumentNullException]::new(
                    <# paramName: #> 'ScriptBlock',
                    <# message: #> 'Evaluated to null')

                $errorRecord = [errorRecord]::new(
                    <# exception: #> $exception,
                    <# errorId: #> 'InvalidResultNullScriptBlock',
                    <# errorCategory: #> [System.Management.Automation.ErrorCategory]::InvalidResult,
                    <# targetObject: #> $ScriptBlock)
                $PSCmdlet.WriteError( $errorRecord )
                return
            }
            $__randPerSession[$Name] = $NewValue
            # We need to return the value, even on first-set
            $newValue

        }
        catch {
            $PSCmdlet.WriteError( $_ )
        }
    }
}
