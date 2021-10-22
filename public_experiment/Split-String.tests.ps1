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
