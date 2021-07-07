BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe "Compare-StrictEqual" {
    It 'String == int' {
        Compare-StrictEqual 5 '5' | Should -Be $false
    }
    It 'String == int' {
        Compare-StrictEqual ([double] 5) '5' | Should -Be $false
    }
    It 'double == int' {
        $splat = @{
            A = [double]5
            B = [int]'5'

        }
        Compare-StrictEqual @splat | Should -Be $false
    }
    It 'int32 == int64' {
        $splat = @{
            A = [int64]5
            B = [int32]5

        }
        Compare-StrictEqual @splat | Should -Be $false
    }
    It 'int32 == int32' {
        $splat = @{ A = [int32]20; B = [int32]20 }
        Compare-StrictEqual @splat | Should -Be $true
    }
}
