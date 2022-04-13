function Lsd_old {
    <#
    .synopsis
        tiny wrapper hack, still pretty prints.
    .description
        future:
            - number files in folder
            - colorize based on lastmodified ramping
            - *smart alias* by using '[System.Management.Automation.ProxyCommand]'

            - maybe a smart alias that calls 'Get-NinChildItem', removing logic / decreaseing total commands
            - how can I pass path / complete nicer ? $args doesn't seem to be exposed to me.
    .example
        PS> lsd .. | SelectProp Name

        PS> Lsd
    #>
    [cmdletbinding()]
    param(
        # Path
        [Parameter(Position = 0)]
        [string]$Path
    )

    Write-Warning "Old $PSCommandPath"

    # Get-process {
    # $x = 3
    # }
    # $args
    # $SepStr = New-Text ' * ' | ForEach-Object ToString
    $SepStr = New-Text -Fg 'gray50' ' * ' | ForEach-Object Tostring
    Get-ChildItem -Directory -Path $Path -Recurse:$false -Force
    | Sort-Object LastWriteTime -Descending
    | Select-Object -First 20
    | Join-String -sep $SepStr {
        @(
            '/'
            $_.Name
            #'/'
        ) -Join ''
    }
}

# Lsd ~
