#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Select-Interactively' # ''
    )
    $experimentToExport.alias += @(
        # 'Select-Interactively'
    )
}

function Select-Interactively {
    <#
    .notes
        original: https://discord.com/channels/180528040881815552/447476117629304853/946142730847944744

        Wow, this is just fantastic. Thank you so much and thank you @IISResetMe . I created this little function that allows me to press q during any pipeline processing that will stop the pipeline, but isn't a hard throw like ctrl+c:
    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(ValueFromPipeline)]
        [psobject] $InputObject
    )
    process {
        if ($null -eq $InputObject) {
            return
        }

        # yield
        $InputObject

        if ([Console]::KeyAvailable) {
            $keyInfo = [Console]::ReadKey($true)
            if ($keyInfo.KeyChar -eq 'q') {
                EnsureCommandStopperInitialized
                [UtilityProfile.CommandStopper]::Stop($PSCmdlet)
            }
        }
    }
}


if (! $experimentToExport) {
    # ...
}
