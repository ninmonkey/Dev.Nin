$experimentToExport.function += @(
    '_quickNetTest'
)
$experimentToExport.alias += @(
    'PingQuick'
    'NetworkTool🌎.SlowNetTest'
)

function _quickNetTest {
    <#
    .synopsis
        when you don't need detailed stats, just a quick ping result
    .link
        Dev.Nin\NetworkTool🌎.SlowNetTest
    #>
    # quick 1 off test
    [Alias('NetworkTool🌎.SlowNetTest', 'PingQuick')]
    [CmdletBinding()]
    param(
        [switch]$Traceroute
    )
    $isp_dns = @('205.171.2.25', '205.171.3.25')
    $known_dns = @('1.1.1.1', '8.8.8.8')
    $targets = @(
        $isp_dns
        $known_dns
        'google.com', 'reddit.com', 'ninmonkeys.com', 'ninmonkey.com'
    )
    Test-Connection -TargetName $targets -ResolveDestination -Traceroute $Traceroute
}
