#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Find-FileFromHandle'
    )
    $experimentToExport.alias += @(
        'Find->FromHandle'
    )
}

function Find-FileFromHandle {
    <#
        .synopsis
            .
        .notes
        docs:
            usage: handle [[-a [-l]] [-u] | [-c <handle> [-y]] | [-s]] [-p <process>|<pid>] [name] [-nobanner]
                -a         Dump all handle information.
                -l         Just show pagefile-backed section handles.
                -c         Closes the specified handle (interpreted as a hexadecimal number).
                            You must specify the process by its PID.
                            WARNING: Closing handles can cause application or system instability.
                -y         Don't prompt for close handle confirmation.
                -s         Print count of each type of handle open.
                -u         Show the owning user name when searching for handles.
                -p         Dump handles belonging to process (partial name accepted).
                name       Search for handles to objects with <name> (fragment accepted).
                -nobanner  Do not display the startup banner and copyright message.

            examples of original invoke


            process (fast)
                handle64 -p 3914

            process + pattern (fast)
                handle64 -p 39144 msmdsrv4
            pattern (slow)
                handle64 msmdsrv
        .example
            PS> Verb-Noun -Options @{ Title='Other' }
        #>
    # [outputtype( [string[]] )]
    [Alias('Find->FromHandle')]
    [cmdletbinding()]
    param(
        # docs
        # process Id
        [Alias('Pid', 'Id')]
        [parameter()]
        [int]$ProcessId,

        # file handle
        [parameter()]
        [int]$HandleId,

        # partial basic pattern matching? at least substr.
        [alias('Name')]
        [parameter()]
        [string]$InputName,

        [switch]$Help,

        # extra options
        [Parameter()][hashtable]$Options
    )
    begin {
        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        # [hashtable]$Config = @{
        #     AlignKeyValuePairs = $true
        #     Title              = 'Default'
        #     DisplayTypeName    = $true
        # }
        # $Config = Join-Hashtable $Config ($Options ?? @{})
    }
    process {
        $binHandle = Get-NativeCommand 'handle64' -ea stop
        $PSBoundParameters | Format-dict
        if ($Help) {
            & $binHandle --help
            @'
    ParameterSets, sort of:

        handle [
            | [-a [-l]] [-u]
            | [-c <handle> [-y]]
            | [-s]
        ]
        [-p <process>|<pid>] [name] [-nobanner]
'@
        }



        [object[]]$mdArgs = @(
            if ($HandleId) {
                '-c'
                $HandleId
            } else {
                #exclusive?
                '-p'
                $ProcessId

            }
            if ( ! [string]::IsNullOrWhiteSpace($Pattern) ) {
                $Pattern
            }
            '-nobanner'

        )

        $mdArgs | Str sep ' ' | write-color 'orange' | Label 'handle args:' | wi

    }
    end {
    }
}

if (! $experimentToExport) {
    # ...
    hr -fg magenta
    Find->FromHandle -help
    $pbi ??= Get-Process 'msmdsrv'

    hr -fg magenta
    Find->FromHandle -ProcessId $pbi.Id -infa continue
    $handles = $pbi.Handles
    $pbi.Id | Label 'pid'
    $handles | Label 'handles'
    hr -fg magenta

}
