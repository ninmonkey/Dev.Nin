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
    .outputs
        [object]
    #>
    [CmdletBinding(PositionalBinding = $false,
        DefaultParameterSetName = 'SetOrGetKey'
    )]
    param(
        # Keyname of value to forget
        [Alias('Name')]
        [Parameter(
            ParameterSetName = 'SetOrGetKey',
            Mandatory, Position = 0)]
        [string]$KeyName,

        # Only invoke once, if value already exists
        [ValidateNotNull()]
        [Parameter(
            ParameterSetName = 'SetOrGetKey',
            Mandatory)]
        [ScriptBlock]$ScriptBlock,

        # Random count
        [Alias('Number')]
        [Parameter(
            ParameterSetName = 'SetOrGetKey'
            # Position = 1
        )]
        [ValidateScript( { $_ -gt 0 })]
        [int]$Count = 1,

        # list stored key names
        [Alias('Keys')]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'ListAllKeys')]
        [switch]$ListKeyName,

        # list stored Pairs
        [Alias('Pairs')]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'ListAllKeyValuePairs')]
        [switch]$AllValues
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
            if ($__randPerSession.ContainsKey($KeyName)) {
                Write-Debug "Using Cached Key '$KeyName'"
                $__randPerSession[$KeyName]
                return
            }
            Write-Warning 'todo: test if exception in SB is safe'
            $lazyTimer = Get-Date
            Write-Debug "Evalating new Cached Key '$KeyName'"

            $__randPerSession[$KeyName] = & $ScriptBlock
            | Get-Random -Count $Count

            $now = (Get-Date)
            "Evaluated Key '$KeyName', Count: $Count in {0:n2} seconds" -f @(
                $now - $lazyTimer
            ).TotalSeconds | Write-Debug
        }
        catch {
            $PSCmdlet.WriteError( $_ )
        }
    }
}
