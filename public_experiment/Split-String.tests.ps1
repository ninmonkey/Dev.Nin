requires -modules @{ModuleName = 'Pester'; ModuleVersion = '5.0.0' }
BeforeAll {
    Import-Module Dev.Nin -Force
    $ErrorActionPreference = 'Stop'
}

Describe Split-String {
    Describe 'ParameterSet' {
        BeforeAll {
            $Sample = 'a,b,,c'
            $Expected = 'a,b,c'

            $Sample2 = "a`nb`nc"
            $Expected2 = 'a', 'b', 'c'

            $Sample3 = "a`n`n`nb`nc`n`ne"
            $Expected3 = 'a', 'b', 'c', 'e'
        }

        Describe 'SplitStyle' {
            It 'NewLine' {
                "a`n`n`nb`nc`n`ne" | SplitStr -as Newline
                | Should -Be 'a', '', '', 'b', 'c', '', 'e' -Because 'Manual case'
            }
            It 'Csv' {
                'a,b,,c' -split ',\s*' | SplitStr -as Csv
                | Should -Be @('a', 'b', '', 'c')
            }
            It 'Whitespace' {
                # /s+ is equiv to:'[\r\n\t\f\v ]+'
                # /w+ is equiv to:'[a-zA-Z0-9_]+'
                "a`n`n`nb`n`tc`r`n`ne" | SplitStr -as WhiteSpace
                | Should -Be 'a', 'b', 'c', 'e' -Because 'Manual case'
            }
            It 'Tab' {
                "z`t`tyk"
            }
            It 'Word' {
                $true | Should -Be $false -becaause 'test NYI'
            }
            It 'NonWord' {
                $true | Should -Be $false -becaause 'test NYI'
            }
            Describe 'ControlChar' {
                It 'Preserves NL,CR,Tab,Space' {
                    ("a`tb" | SplitStr -As ControlChar).count
                    | Should -Be 1 -Because 'Manual case'

                    ("a`tb" | SplitStr -As ControlCharAll).count
                    | Should -Be 2 -Because 'Manual case'
                }
            }

        }

        It 'Pipeline with regex' {
            $Sample | Split-String -match ',' | Should -Be $Expected
        }
        It 'Param with regex' {
            Split-String -InputObject $Sample -match ',' | Should -Be $Expected
        }
        It 'Pipeline with Type' {
            $Sample2 | Split-String -Type Newline | Should -Be $Expected2
        }
        # It 'Param with regex' {
        #     $Sample | Split-String -match ',' | Should -Be $Expected
        # }
    }

    It 'Runs without error' {
        { 'a1b' | Split-String '\d+' } | Should -Not -Throw
        # Split-String
        # $false | Should -Be $True -Because 'Write Split-String'
    }
    It 'Direct Compare' {
        $test1 = ('abc-de---39' -split '\-+') | Should -Be ('abc', 'de', 39)
        $test2 = 'abc-de---39' | Split-String '\-+' | Should -Be ('abc', 'de', 39)
        $test1 | Should -Be $Test2 -Because 'equivalent compare'
    }
    It 'basic Baseline' {
        # evaluates: abc,de,39
        ('abc-de---39' -split '\-+')
        | Should -Be @('abc', 'de', '39') -Because 'Manually written baseline'
    }
    It 'basic Pipe' {
        'abc-de---39' | Split-String '\-+'
        | Should -Be @('abc', 'de', '39') -Because 'Manually written baseline'
    }
    It 'Another Test' {
        ('abc-de---39' -split '\-+') -join ','
        ('abc-de---39' -split '\-+') | Should -Be ('abc', 'de', 39)

    }
}
