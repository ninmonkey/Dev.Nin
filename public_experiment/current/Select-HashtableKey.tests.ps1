BeforeAll {
    Import-Module Dev.Nin -Force    
}

Describe 'Select-HashtableKey' {
    BeforeAll {
        $Samples = @{

        }
    }

    It 'Basic' {
        $h1 = @{'a' = 1; 'b' = 2 }
        $H2 = @{'a' = 4; 'q' = 9 }
        $ExpectedH2 = @{'q' = 9 }


        $h2 | Select-HashtableKey -IncludeRegex 'q'
        | Should -Be $ExpectedH2
    }
}
