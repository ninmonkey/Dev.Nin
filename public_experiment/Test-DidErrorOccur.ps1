$experimentToExport.function += @(
    'Test-DidErrorOccur'
    'errorCount'
)
$experimentToExport.alias += @(
    'Err?'
    # 'Err?Module'
)
$__moduleMetaData_DidError_PrevCount = 0

# function errorCount {
#   $error.count
# }
# # errorCount

function Test-DidErrorOccur {
    <#
    .synopsis
        shortcut for the cli: list error counts, first error, and autoclear
    .description
        .
    .notes
        & (Get-Module name) { $error }? But $error is
        <https://discord.com/channels/180528040881815552/447476117629304853/883390100870946948>

    #>
    [Alias('Err?')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # DoNotClear error variable
        [Parameter()][switch]$AlwaysClear,
        # first X
        [Parameter(Position = 0)][int]$Limit = 1

    )
    end {
        <#
        # todo: refactor:
            separate formatting from this test function
                then prompt invokes this and formats


        #>
        try {
            $globalError = $global:Error
            $script:__moduleMetaData_DidError_PrevCount ??= 0 # Gross, but module itself is
            $script:__moduleMetaData_TurnsSinceLastError ??= 0 # Gross, but module itself is

            # forced to be in user scope to access $error, I think.
            $curCount = $globalError.count
            $delta = $curCount - $script:__moduleMetaData_DidError_PrevCount
            $script:__moduleMetaData_DidError_PrevCount = $curCount

            if ($Delta -gt 0) {
                $script:__moduleMetaData_TurnsSinceLastError = 0
            }
            else {
                $script:__moduleMetaData_TurnsSinceLastError++
            }
            $turnsSinceLastCount = $script:__moduleMetaData_TurnsSinceLastError


            $c = @{
                errorFg     = '#E7B3B3'
                errorBg     = '#802D2D'
                normalFg    = '#B88591'
                normalFgDim = '#534C55'
                # errorBg = 80
                #E75252
                #E75252
                # errorBg = '#BED5BD'
            }

            $PSBoundParameters | Format-Table | Out-String | Write-Debug

            # $exceptionText = $globalError
            # # | Select-Object -First $Limit
            # | ForEach-Object {
            #     $curErr = $_
            #     Write-Debug "Handling: $curErr"
            #     $curErr.ToString() | ShortenString 90 | ForEach-Object {
            #         if ($_ -eq 0) {
            #             $_ | New-Text -fg $c.normalFgDim
            #         }
            #         else {
            #             $_ | New-Text -fg $c.normalFg
            #         }
            #     }
            #     | New-Text -fg $c.errorFg -bg $c.errorBg | ForEach-Object tostring
            # } | Select-Object -First $Limit

            $ExceptionOutputFormat = '' # delta
            switch ($ExceptionOutputFormat) {
                'delta' {
                    $FirstN = $Limit - $delta
                    $FirstN = [math]::min(
                        ($Limit - $delta),
                        $limit
                    )
                    $FirstN = $delta - $Limit
                }
                # 'fixed'
                default {
                    $FirstN = $Limit
                }
            }

            $FirstN
            if ($Delta -le 3) {
                # $FirstN = [math]::max($Delta, $FirstN)
                $FirstN = [math]::min($Delta, $FirstN)
            }
            else {
                $FirstN = 0
            }

            # "First: $FirstN, Limit: $Limit, D: $delta, L-D: $($limit - $delta)"
            # | Write-Host -ForegroundColor magenta

            $exceptionText = $globalError | Select-Object -First $FirstN | ForEach-Object { $curIndex = 0 } {
                $indexLabel = '{0,-2} ' -f $curIndex
                [string]$_ | ShortenString
                | Join-String -op $indexLabel

                $curIndex++
            } | Join-String -sep "`n" -op "`n"

            if ($turnsSinceLastCount -lt 3 ) {
                $exceptionText | New-Text -fg $c.errorFg -bg $c.errorBg | Join-String
            }

            $OutputFormatMode = 'default'
            if ($OutputFormatMode -eq 'classic') {

                $Template = @'

errors: {0}, new {1}, {2}
'@
                $Template -f @(
                    $curCount
                    $delta
                    $turnsSinceLastCount
                )
            }
            elseif ($OutputFormatMode -eq 'default') {
                "`n"
                @(
                    '[E]: {0} ' -f @($curCount)
                    | New-Text -fg '#AB7D88'
                    if ($turnsSinceLastCount -gt 3) {
                        'Last: {0}' -f @($turnsSinceLastCount)
                        | New-Text -fg '#3AB81C' #'#AB7D88'
                    }
                    else {
                        'New: +{0}' -f @($delta)
                        | New-Text -fg yellow
                    }
                ) | Join-String

            }
            # "Did $i"
            # $global:err = $global:error

            if ( $AlwaysClear) {
                $globalError.clear() # Forgive me 😿
            }
        }
        catch {
            $PSCmdlet.WriteError( $_ )
        }
    }
}
