function _Write-ErrorCountLabel {
    <#
    .synopsis
        macro to count errors, hides if == 0
    #>
    [Alias('errCount')]
    param( [string]$Prefix = '' )

    if ($error.Count -eq 0) { return; }
    $error.Count | Label "${Prefix}Errors"
}

function Get-NinLogSource {
    <#
        Get sources/providers that wrote to a Log
    .description

        similar to:
        PS> (Get-WinEvent -ListLog PowerShellCore/Operational).ProviderNames

        See -FilterHashtable
    #>
    param(
        # a log name
        [Parameter(Position = 0, Mandatory)]
        [string]$LogName
    )
    process {
        Get-WinEvent -ListLog $LogName | ForEach-Object ProviderNames
        # (Get-WinEvent -ListLog PowerShellCore/Operational).ProviderNames
    }
}
$related_involved_types = @(
    [System.Diagnostics.EventInstance]
    [System.Diagnostics.Eventing.Reader.ProviderMetadata]
    Find-Type -FullName 'System.Diagnostics.Eventing.Reader.*' #| ForEach-Object Name
    Find-Type -FullName 'System.Diagnostics.Eventing.*'
)
function _Get-LogListing {
    <#
    .synopsis
        enumerate log names, with and without read access.
    .notes
    see examples: <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.diagnostics/get-winevent?view=powershell-7.1&WT.mc_id=ps-gethelp#example-17--use-filterhashtable-to-get-application-errors>
    .outputs
        [System.Diagnostics.Eventing.Reader.EventLogConfiguration[]]

    #>
    param()
    $logNames = Get-WinEvent -ListLog * -ErrorVariable 'logErr' -ea silentlycontinue
    $logNamesRequirePerm = $Error | ForEach-Object {
        $curError = $_
        if ($curError.Exception.InnerException.Source -match 'EventLog') {
            if ($curError.Exception.Message -match 'To access the ''(?<LogName>.*)'' log start PowerShell') {
                $Matches.LogName
            }
        }
        else {}
    } | Sort-Object
    [pscustomobject]@{
        'LogName'         = $logNames
        'LogRequiresPerm' = $logNamesRequirePerm
    }
    $Error.Clear() # temporary quick hack
}



function Select-NinLogName {
    <#
    .synopsis
        select a WinEvent log (that you have permission for)
        refactor: should be 'log | SelectList LogName' that calls Out-fzf for you
    #>
    param(
        # PassThru
        [Parameter()]
        [switch]$PassThru
    )

    $listing = _Get-LogListing
    | ForEach-Object LogName | ForEach-Object LogName | Sort-Object -Unique

    if ($PassThru) {
        $listing
        return
    }
    $listing | Out-Fzf

}

function Get-NinEventProviderMetadata {
    <#
    .synopsis
        List EventIds from a Log provider
    .description
        see more:
            [System.Diagnostics.Eventing.Reader.ProviderMetadata] | Fm -Force *
        and
            [System.Diagnostics.Eventing.Reader.ProviderMetadata] | Fm -MemberType Property
    .notes
        from docs:
            (Get-WinEvent -ListProvider Microsoft-Windows-GroupPolicy).Events | Select-Object Id, Description
    #>
    [cmdletbinding()]
    [Alias('Get-EventProviderInfo')]
    param(
        # ...
        [Parameter(Position = 0, Mandatory)]
        [string[]]$ProviderName
    )

    # (Get-WinEvent -ListProvider $ProviderName).Events | Select-Object Id, Description
    $Top = Get-WinEvent -ListProvider $ProviderName
    # $Top | Select-Object Id, Description
    [pscustomobject]@{
        Keywords = $Top.Keywords
        LogLinks = $Top.LogLinks
        Levels   = $Top.Levels
        OpCodes  = $Top.Opcodes
        Tasks    = $Top.Tasks
        Events   = $Top.Events
    }
}

# Get-NinEventProviderMetadata -ProviderName $j_providerList[1]


function Get-NinLogIdMap {
    <#
    .synopsis
        List EventIds from a Log provider
    .notes
        from docs:
            (Get-WinEvent -ListProvider Microsoft-Windows-GroupPolicy).Events | Select-Object Id, Description
    #>
    [cmdletbinding()]
    [Alias('listEventId')]
    param(
        # ...
        [Parameter(Position = 0, Mandatory)]
        [string[]]$ProviderName
    )

    (Get-WinEvent -ListProvider $ProviderName).Events | Select-Object Id, Description
}

<#
now in Ninmonkey.Console

#>
if ($false) {
    function ConvertTo-Timespan {
        <#
        .synopsis
            converts fuzzy dates to a [datetime]
        .example
            1d3h4s -> #duration(1, 3, 4)'
        .outputs
            [timespan] or null
        .notes
            better verb? better name, timespan?
            ConvertTo ?
        #>
        [cmdletbinding()]
        [Alias('RelativeDt')]
        param(
            # relative string, ex: 1d3h4s
            [Parameter(Position = 0, Mandatory)]
            [string]$RelativeText
        )

        begin {
            $Regex ??= @{}
            $Regex.ParseString = @'
(?x)
        ^
        (
            (?<Days>\-?\d+)
        d)?
        (
            (?<Hours>\-?\d+)
        h)?
        (
            (?<Minutes>\-?\d+)
        m)?
        (
            (?<Seconds>\-?\d+)
        s)?
        (
            (?<Milliseconds>\-?\d+)
        ms)?
        (?<Rest>.*)
        $
'@
        }
        process {
            if (!($RelativeText -match $Regex.ParseString)) {
                Write-Error "Failed parsing string '$RelativeText'"
                return
            }

            $Days = $Matches.Days ?? 0
            $Hours = $Matches.Hours ?? 0
            $Minutes = $Matches.Minutes ?? 0
            $Seconds = $Matches.Seconds ?? 0
            $Milliseconds = $Matches.Milliseconds ?? 0

            $Days, $Hours, $Minutes, $Seconds, $Milliseconds
            | Join-String -sep ', ' | Label 'Args' | Write-Debug

            $ts = [timespan]::new($Days, $Hours, $Minutes, $Seconds, $Milliseconds)
            $ts
        }
    }
}

# main
# $j_providerList = Get-NinLogSource 'Microsoft-Windows-Store/Operational'
