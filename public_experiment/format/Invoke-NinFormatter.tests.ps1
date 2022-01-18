BeforeAll {
    Import-Module Dev.Nin -Force
    # Import-Module Ninmonkey.Console -Force
}

Describe 'Invoke-NinFormatter' {
    It 'Should Not Throw' {
        { 'test' | Dev.Nin\Invoke-NinFormatter }
        | Should -Not THrow
    }
    It 'based2' {
        $True | Set-ItResult -Pending
    }
    It 'HardCoded' {
        $rawStr = @'
1 | %{
$_ * 2
0..3
| %{
$_ + }
'@
    }
}
