BeforeAll {
    Import-Module Dev.Nin -Force
    # $ErrorActionPreference = 'break'
}

Describe 'ConvertFrom-LiteralPath' {
    BeforeAll {
    }
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

    It '"<LiteralPath>" Returns "<Expected>"' -ForEach @(
        @{
            LiteralPath = "$Env:UserProfile\Users\cppmo_000\AppData\Roaming"
            Expected    = '$Env:APPDATA'
        }
        @{
            LiteralPath = 'C:\Users\cppmo_000\Documents\2021'
            Expected    = '$Env:UserProfile\Documents\2021'
        }
    ) {
        $LiteralPath | ConvertFrom-LiteralPath | Should -Be $Expected
        # . $__PesterFunctionName $LiteralPath | Should -Be $Expected
    }
}
