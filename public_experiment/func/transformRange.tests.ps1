BeforeAll { _
    Import-Module Dev.Nin -Force
}

Describe 'ConvertFrom-NumberRange' {
    Describe 'StaticTests' {
        It 'RGB' {
            100 | Dev.Nin\ConvertFrom-NumberRange 0 100 0 255
            | Should -Be 255
        }
    }
    Context 'Dynamic Int' {
        It '(maybe) Perfect Int: fn(<x>) [<Min1>, <Min2>] => [<Min2, Max2>] = <ExpectedX>' -ForEach @(
            @{
                $Min1 = 0 ; $Max1 = 255
                $Min2 = 0 ; $Max2 = 100
                $X = 255 ; $ExpectedX = 100

            }
        ) {
            $convertFromNumberRangeSplat = @{
                Min1  = $Min1
                Max1  = $Max1
                Min2  = $Min2
                Max2  = $Max2
                Value = $X
            }

            Dev.Nin\ConvertFrom-NumberRange @convertFromNumberRangeSplat
            | Should -Be $ExpectedX

        }
    }
}
