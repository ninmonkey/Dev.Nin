BeforeAll {
    # . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
    Import-Module Dev.Nin -Force
}

Describe 'ConvertFrom-LiteralPath' {
    It 'UserProfile' {
        $Sample = 'C:\Users\cppmo_000\Documents\2021'
        $Expected = '$Env:UserProfile\Documents\2021'

        $Sample | ConvertFrom-LiteralPath -Debug
        | Should -Be $Expected
    }

    It 'RandomInput' {
        { 'sfa3vqfsdf23' | ConvertFrom-LiteralPath -ea stop }
        | Should -Throw -Because 'Invalid Path'
    }
}
