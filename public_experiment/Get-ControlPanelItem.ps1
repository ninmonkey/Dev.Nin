$experimentToExport.function += @(
    'Get-ControlPanelSetting'
)
# $experimentToExport.alias += @(
#     'EditModule'
# )

$script:__ControlPanelMap = @(
    @(
        'ms-settings:about'
        'ms-settings:apps-volume'
        'ms-settings:bluetooth'
        'ms-settings:clipboard'
        'ms-settings:cortana-notifications'
        'ms-settings:cortana-windowssearch'
        'ms-settings:easeofaccess-eyecontrol'
        'ms-settings:easeofaccess-mouse'
        'ms-settings:fonts'
        'ms-settings:gaming-gamebar'
        'ms-settings:gaming-trueplay'
        'ms-settings:help'
        'ms-settings:messaging'
        'ms-settings:mouse'
        'ms-settings:network-status'
        'ms-settings:network-vpn'
        'ms-settings:network-wifisettings'
        'ms-settings:network'
        'ms-settings:notifications'
        'ms-settings:personalization-start-places'
        'ms-settings:personalization-start'
        'ms-settings:privacy-activityhistory'
        'ms-settings:privacy-backgroundapps'
        'ms-settings:privacy-notifications'
        'ms-settings:quiethours'
        'ms-settings:quietmomentshome'
        'ms-settings:savelocations'
        'ms-settings:startupapps'
        'ms-settings:troubleshoot'
        'ms-settings:usb'
        'ms-settings:vpn'
    ) | ForEach-Object {
        $key, $endpoint = $_ -split ':'
        @{
            Label       = $endpoint
            Url         = $_
            Description = '[?]'
        }
    }

    # now hard-coded ones
    @(
        @{
            Label       = 'Root'
            Url         = 'ms-settings:'
            Description = 'Opens at the top level'
        }
        @{
            Label       = 'Volume'
            Url         = 'ms-settings:apps-volume'
            Description = 'Set audio and mic input, per-application [recently added]'
        }
    )
) | ForEach-Object {
    [pscustomobject]$_
} | Sort-Object Url

function Get-ControlPanelSetting {
    <#
    .synopsis
        Opens control panel from names
    .description
        Descd
    .example
        # find hard-coded / configs with a description
        PS> Get-ControlPanelSetting -List  | sort Description
    .outputs

    #>
    [CmdletBinding(PositionalBinding = $false, DefaultParameterSetName = 'LookupUrl')]
    param(
        # Return all metadata
        [Parameter(
            ParameterSetName = 'ListOnly'
        )][switch]$List,

        # Open a random control panel
        [Parameter()][switch]$Random,

        #
        [Alias('Key')]
        [Parameter(
            Mandatory, Position = 0,
            ParameterSetName = 'LookupUrl'
        )]
        [string]$Name
    )

    begin {
        $UrlMap =
        @(
            @{
                Label = 'Volume'
            }

        )
    }
    process {
        if ($List) {
            $script:__ControlPanelMap
            return
        }

        if ($Random) {
            $Name = $script:__ControlPanelMap.keys | Get-Random -Count 1
            "Random Page: '$Name'" | Write-Information
        }

        switch ($PSCmdlet.ParameterSetName) {
            'ListOnly' {
                $script:__ControlPanelMap
                break
            }

            'LookupUrl' {
                $mapping = $script:__ControlPanelMap
                if (! $mapping.containsKey( $Name ) ) {
                    $PSCmdlet.ThrowTerminatingError( "$Name" )
                    return
                }
                $Url = $Mapping[ $Name ]
                $Url | Write-Information
                Start-Process -path $Url
            }

            default {
                throw "Unhandled ParameterSet: $($PSCmdlet.ParameterSetName)"
            }
        }
        # Start-Process
        # Write-Error 'left off: use dynamic generated key value pairs for auto complete'

    }
    end {
        'done scraping from: "C:\Users\cppmo_000\Documents\2021\Powershell\buffer\2021-01\ms-settings url ⁞ Control panel uri url\Ms-Settings url uri ⁞ Basic Invocation ┐2021-01-28.ps1" ?'
    }
}

if ($false) {
    Get-ControlPanelSetting -infa continue -List -Debug
}
