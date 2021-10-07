BeforeAll {
    . "$PSScriptRoot/Test-IsNotBlank.ps1"
}

Describe 'Test-IsNotBlank' {
    BeforeAll {
        $ErrorActionPreference = break
    }
    Describe 'Exceptions' {
        It 'Literal Empty' {
            { '' | Test-IsNotBlank } | Should -Not -Throw
            { Test-IsNotBlank '' } | Should -Not -Throw

        }
        It 'Literal Empty' {
            Test-IsNotBlank '' | Should -Be $False
        }
    }
    It 'Basic' {
        Test-IsNotBlank ' ' | Should -Be $True
    }
}