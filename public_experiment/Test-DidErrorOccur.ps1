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
            $Template = @'

errors: {0}, new {1}
'@
            # forced to be in user scope to access $error, I think.
            $curCount = $globalError.count
            $delta = $curCount - $script:__moduleMetaData_DidError_PrevCount
            $script:__moduleMetaData_DidError_PrevCount = $curCount


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

            $exceptionText = $globalError | Select-Object -First $Limit | ForEach-Object { $curIndex = 0 } {
                $indexLabel = '{0,-2} ' -f $curIndex
                [string]$_ | ShortenString
                | Join-String -op $indexLabel

                $curIndex++
            } | Join-String -sep "`n"

            $exceptionText | New-Text -fg $c.errorFg -bg $c.errorBg | Join-String
            $Template -f @(
                $curCount
                $delta
            )
            # "Did $i"
            # $global:err = $global:error

            if ( $AlwaysClear) {
                $globalError.clear()
            }
        }
        catch {
            $PSCmdlet.WriteError( $_ )
        }
    }
}


if ($false) {
    function _origTest-DidErrorOccur {
        <#
    .synopsis
        shortcut for the cli: list error counts, first error, and autoclear
    .description
        .

    #>
        [Alias('Err?')]
        [CmdletBinding(PositionalBinding = $false)]
        param(
            # DoNotClear error variable
            # [Parameter()][switch]$DoNotClearErrorVar,
            [Parameter(Position = 0)][int]$Limit = 1

        )

        Write-Warning 'this doesn'' seem to have access to profile''s error scope'
        $curCount = $script:error.count
        $delta = $curCount - $__moduleMetaData_DidError_PrevCount
        $__moduleMetaData_DidError_PrevCount = $curCount

        $script:error | Select-Object -First $Limit
        'errors: {0}, new {1}' -f @(
            $curCount
            $delta
        )
        # $global:err = $global:error

        # if(! $DoNotClearErrorVar) {
        #     $global:error.clear()
        # }
    }

}
