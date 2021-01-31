BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe "Get-Exponentiation" {
    It 'Equal to Math.Pow()' {
        $testCases = @(
            , (2, 8)
            , (2, 7)
            , (10, -3)
            , (-3, -3)
        )

        $testCases | ForEach-Object {
            $sample = $_
            $Expected = [math]::Pow($sample[0], $sample[1])

            # Pow $sample[0] $sample[1]
            Pow @sample
            | Should -Be $Expected
        }

    }
    It 'Hard-Coded exponents' {
        Pow 2 8 | Should -Be 256

        (Pow 2 8) - 1 | Should -Be ([byte]::MaxValue)
    }
    # It 'String == int' {
    #     Compare-StrictEqual 5 '5' | Should -Be $false
    # }
    # It 'String == int' {
    #     Compare-StrictEqual ([double] 5) '5' | Should -Be $false
    # }
    # It 'double == int' {
    #     $splat = @{
    #         A = [double]5
    #         B = [int]'5'
    #     }
    #     Compare-StrictEqual @splat | Should -Be $false
    # }
    # It 'int32 == int64' {
    #     $splat = @{
    #         A = [int64]5
    #         B = [int32]5
    #     }
    #     Compare-StrictEqual @splat | Should -Be $false
    # }
    # It 'int32 == int32' {
    #     $splat = @{ A = [int32]20; B = [int32]20 }
    #     Compare-StrictEqual @splat | Should -Be $true
    # }
}