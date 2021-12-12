#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Format-NativeCommandArgs'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}


function Format-NativeCommandArgs {
    <#
            .synopsis
                sugar 'pretty print' args the binary will use
            .example
                PS> $argList | Format-NativeCommandArgs
            #>
    [cmdletbinding()]
    param(
        # arg  listing
        [parameter(Mandatory, Position = 0)]
        [object[]]$ArgList,

        # string prefix
        [parameter(Position = 1)]
        [string]$Name
    )

    process {
        $prefix = if ($Name) {
            "${Name}: " ?? ''
            | Write-Color -fg blue
        } else {
            ''
        }
        # Wait-Debugger
        $list = $ArgList | Join-String -sep ' ' -op $prefix
        "${fg:blue}${Prefix}${fg:pink}${list}"

        # | Write-Color -fg pink
        #| Join-String
    }
}


if (! $experimentToExport) {
    # ...
}
