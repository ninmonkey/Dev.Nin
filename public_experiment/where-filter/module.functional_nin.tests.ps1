BeforeAll {
    Import-Module Dev.Nin
}

Describe 'Functional Dev.Nin' {
    BeforeAll {
        $ErrorActionPreference = 'stop'
    }
    AfterAll {
        $ErrorActionPreference = 'stop'
    }
    # It 'First' {
    #     $true, $true, $false
    #     | Dev.Nin\Test-AllTrue
    #     | Should -Be $False
    # }
    Describe 'Test-AllTrue' {
        It 'Test-AllTrue <Sample> is <Expected>' -ForEach @(
            @{
                Sample   = $true, $false
                Expected = $false
            }
            @{
                Sample   = $null, $true
                Expected = $false
            }
            @{
                Sample   = $true
                Expected = $true
            }
            @{
                Sample   = $false
                Expected = $false
            }
            @{
                Sample   = $true, '', $true
                Expected = $false
            }
        ) {
            $Sample | Dev.Nin\Test-AllTrue
            | Should -Be $Expected

        }
    }
    Describe 'Test-AllFalse' {
        It 'Test-AllFalse <Sample> is <Expected>' -ForEach @(
            @{
                Sample   = $true, $false
                Expected = $false
            }
            @{
                Sample   = $null, $true
                Expected = $false
            }
            @{
                Sample   = $true
                Expected = $false
            }
            @{
                Sample   = $false
                Expected = $true
            }
            @{
                Sample   = $true, '', $true
                Expected = $false
            }
            @{
                Sample   = '', $null, ''
                Expected = $true
            }
        ) {
            $Sample | Dev.Nin\Test-AllFalse
            | Should -Be $Expected

        }
    }
    Describe 'Test-AnyTrue' {
        It 'Test-AnyTrue <Sample> is <Expected>' -ForEach @(
            @{
                Sample   = $true, $false
                Expected = $true
            }
            @{
                Sample   = $null, $true
                Expected = $true
            }
            @{
                Sample   = $true
                Expected = $true
            }
            @{
                Sample   = $false
                Expected = $false
            }
            @{
                Sample   = $true, '', $true
                Expected = $true
            }
        ) {
            $Sample | Dev.Nin\Test-AnyTrue
            | Should -Be $Expected

        }
    }
    Describe 'Test-AnyFalse' {
        It 'Test-AnyFalse <Sample> is <Expected>' -ForEach @(
            @{
                Sample   = $true, $false
                Expected = $true
            }
            @{
                Sample   = $null, $true
                Expected = $true
            }
            @{
                Sample   = $true
                Expected = $false
            }
            @{
                Sample   = $false
                Expected = $true
            }
            @{
                Sample   = $true, '', $true
                Expected = $true
            }
        ) {
            $Sample | Dev.Nin\Test-AnyFalse
            | Should -Be $Expected

        }
    }

}
