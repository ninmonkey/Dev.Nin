function Lsd {
    <#
    .synopsis
        tiny wrapper hack, still pretty prints.
    .description
        future:
            - *smart alias* by using '[System.Management.Automation.ProxyCommand]'

            - maybe a smart alias that calls 'Get-NinChildItem', removing logic / decreaseing total commands
            - how can I pass path / complete nicer ? $args doesn't seem to be exposed to me.
    .example
        PS> Lsd
    #>
    # [cmdletbinding()]
    # param()
    # Get-process {
    # $x = 3
    # }
    # $args
    Get-ChildItem -Directory #$args
}