BeforeAll {

    $Env:NO_COLOR = $null
    function Test-NoColorIsSet {
        Test-Path Env:NO_COLOR
        return
    }

}

Describe 'Test-NoColorIsSet' {
    Describe 'EnvVar Exists' {
        BeforeAll {
            $Env:NO_COLOR = $true
        }
        It '$Null Value' {
            $Env:NO_COLOR = $null        #    Test-Path Env:NO_COLOR
            | Should -Be $true
        }
    }
    It 'DoesNotExist' {
        Remove-Item $ENV:NO_COLOR
        Test-Path Env:NO_COLOR
        | Should -

    }
}