#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Test-HasNewError'
        # 'errorCount'

    )
    $experimentToExport.alias += @(
        'Err?'
        # 'Err?Module'

    )
}

$__moduleMetaData_DidError ??= @{
    LastCount = 0 #$global:error.count
}

function Test-HasNewError {
    <#
    .synopsis
        tests errors, returns count[s] with passthru
    .description
        does not 'reset' automatically, so multiple calls (like outside the prompt
        or multiple calls per prompt) don't erase counts
        shortcut for the cli: list error counts, first error, and autoclear?
        smart alias 'Err?' automatically returns info?
    .notes
        .
    .example
    🐒> showErr -Recent
        ErrorRecord -> DriveNotFoundException
        Cannot find drive. A drive with the name '
        C' does not exist.
        ------------------------------------------------------------------------
        ErrorRecord -> SessionStateException

    🐒> err? -PassThru

        LastCount CurCount DeltaCount
        --------- -------- ----------
            27       27          2

    errΔ [2] of [27]
    🐒> err? -Reset


    🐒> showErr -Recent
    # shows 0, does not call clear on errors if -reset

    .example
        PS> Err?
        False

        1 / 0
        PS> Err?
        True
    .outputs
        [$null | bool | hashtable]

    #>
    [Alias('Err?')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Change nothing, just reset 'LastCount' to 0
        [Alias('SaveCurrent')]
        [Parameter()]
        [switch]$Reset,

        # clear the actualy '$error' list
        [Parameter()]
        [switch]$Clear,

        # return metadata other than bool
        [Parameter()] #, ParameterSetName = 'GetInfo')]
        [switch]$PassThru
        # # DoNotClear error variable
        # [Parameter()][switch]$AlwaysClear,
        # first X
        # [Parameter(Position = 0)][int]$Limit = 1

    )
    begin {
        $state = $script:__moduleMetaData_DidError

        if ($Clear) {
            $global:error.clear()
            $state.LastCount = 0
            return
        }
        if ($Reset) {
            $state.LastCount = $global:error.count
        }

    }
    end {
        # $state | Format-Table | Out-String | wi
        if ($PassThru) {
            [pscustomobject][ordered]@{
                LastCount  = $state.LastCount
                CurCount   = $global:error.count
                DeltaCount = $global:error.count - $state.LastCount
            }
            return
        }

        if ($Clear -or $Reset) {
            return
        }

        if ($global:Error.Count -eq 0) {
            $false; return;
        }

        if ($global:error.count -gt $state.LastCount) {
            $true; return;
        }

        $false; return
    }
}


if (! $experimentToExport) {
    # ...
    $error.count | str prefix 'errors?'
    Test-HasNewError -infa continue
    Test-HasNewError -PassThru
}
