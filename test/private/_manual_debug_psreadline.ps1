# $Dest = 'temp:\ps.log'
[Microsoft.PowerShell.PSConsoleReadLine] | fm *buffer*state*

Set-PSReadLineKeyHandler -Chord 'ctrl+p' -ScriptBlock {
    $str = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref] $str, [ref] $null)
    $meta = @{
        'StrIsNull?' = $null -eq $str
        'Str.Length' = ($str)?.length ?? 0
    }

    $strFrom = 'test-nin'
    $strFrom = $str | Invoke-NinFormatter

    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
        <# start: #> 0,
        <# length: #> $strFrom.Length,
        <# replacement: #> $strFrom,
        <# instigator: #> $null, # $instigator,
        <# instigatorArg: #> $Null #$instigatorArg)
    )

    # [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition(0)

    # $newStr = $str | Invoke-NinFormatter

    # New-BurntToastNotification -Text 'hi'

    # [Microsoft.PowerShell.PSConsoleReadLine]::Insert($newStr)
} -BriefDescription 'formatting test' -Description 'formatter test ...'
Get-PSReadLineKeyHandler 'ctrl+p'

$exampleSb = @'
{
$y = 0..3 ;
foreach ($x in $y) {
$x
}
}
'@

$exampleStr = @'
0..4 | %{
if($true){$_}
}
'@

h1 'validate regular'
$sin1 = @'
@'
0..4 | %{
if($true){$_}
}
'@

$sin1
| Endcap🎨 -Label 'sin before'

Invoke-Formatter -ScriptDefinition $sin1
| Endcap🎨 -Label 'sin after'



$exampleStr
| Endcap🎨 -Label '$exampleStr' Bold

$exampleStr
| Invoke-NinFormatter
| Endcap🎨 -Label 'formatted' Bold
