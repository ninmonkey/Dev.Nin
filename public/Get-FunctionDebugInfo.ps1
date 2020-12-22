
function Get-FunctionDebugInfo {
    <#
    .synopsis
        wrapper to autoexport useful function stats
    .description
    .example
        # basic
        PS> Get-FunctionDebugInfo $PSCmdlet
    .example
        # customize output
        Get-FunctionDebugInfo $PSCmdlet -PassThru | Format-HashTable SingleLine
        Get-FunctionDebugInfo $PSCmdlet -PassThru | Format-HashTable

    .notes
        todo:
            If not using passthru, it should be called Write-DebugFunctionInfo instead? Otherwise it is not really 'get'-ing as the verb says.

        alias Write-DebugFunctionInfo ?
        alias Get-FunctionDebugInfo
    #>
    param (
        # PSCmdletInfoState
        [Parameter(
            Mandatory, Position = 0)]
        [object]$PSCmdletInputObject,

        # Additional Hashtable info
        [Alias('AdditionalInfo')]
        [Parameter(Position = 1)]
        [Hashtable]$HashInfo,

        # Detailed Info
        [Parameter()][switch]$Detail,

        # Return detailed info as an object
        [Parameter()][switch]$PassThru
    )

    # $meta = [ordered]@{
    $meta = @{
        'ParameterSetName'                                         = $PSCmdletInputObject.ParameterSetName
        'Command'                                                  = $PSCmdletInputObject.CommandRuntime.ToString()
        'wip: PSBoundParams without passing 2 args per func call?' = 'wip'
    }
    $metaVerbose = [ordered]@{
        'Event.Subscribers'    = $PSCmdletInputObject.Events.Subscribers
        'Event.ReceivedEvents' = $PSCmdletInputObject.Events.ReceivedEvents
        'CommandRuntime.Host'  = $PSCmdletInputObject.CommandRuntime.Host
    }

    if ($Detail) {
        $meta = Ninmonkey.Powershell\Join-Hashtable $meta $metaVerbose
    }

    # if ($false) {
    #     Write-Warning 'Probably should refactor to be cleaner'
    #     H1 'Max detail'
    #     $PSCmdletInputObject | Find-Member

    #     $PSCmdletInputObject | Fm -MemberType Property
    #     | ForEach-Object Name | Sort-Object | Join-String -sep ', ' -SingleQuote
    #     | Label 'PropertyList'
    # }

    if ($PassThru) {
        # [pscustomobject]$meta
        $meta
        return
    }

    $meta | Format-HashTable
    # [pscustomobject]$meta

}

if ($false) {


    function _Invoke-WebHook {
        [cmdletbinding()]
        param(
            # Uri
            [Parameter(Mandatory, Position = 0)]
            [string]$UriEndpoint,


            # Method
            [Parameter(Position = 1)]
            [ValidateSet('GET', 'POST', 'PUT', 'PATCH')]
            [string]$Method = 'GET',

            # Method
            [Parameter(Position = 2)]
            [object]$Body = $null,

            # WhatIf
            [Parameter()][switch]$WhatIf
        )
        # $Body = $null
        $splat_irm = @{
            Uri    = $Urls.GetHook_FromToken
            Method = 'Get'
            Body   = $Body
        }

        $debugMeta = [ordered]@{
            UriEndpoint       = $UriEndpoint
            Method            = $Method
            Body              = $Body
            ParameterSetName  = $PSCmdlet.ParameterSetName
            PSBoundParameters = $PSBoundParameters | Format-HashTable SingleLine
            WhatIf            = $WhatIf
        }

        $splat_irm | Format-HashTable -Title '_Invoke-WebHook: splat_irm'
        | Join-String -sep "`n" -OutputPrefix "`n"
        | Write-Information -Tags 'debug'

        $debugMeta | Format-HashTable -Title '_Invoke-WebHook: debugMeta'
        | Write-Information -Tags 'verbose'

        if (! $WhatIf ) {
            Invoke-RestMethod @splat_irm
        }

    }
}
'afds' | Dev-GetHelpFromType -PassThru