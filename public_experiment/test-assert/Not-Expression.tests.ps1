#Requires -Version 7

BeforeAll {
    Import-Module Dev.Nin -Force
}

Describe 'Not-Expression' {
    It 'Basic Bool' {
        $true | Not! | Not! | Should -Be $false
        $false | Not! | Not! | Should -Be $true
    }
    It 'Round Trip' {
        $true | Not! | Not! | Should -Be $false
        $false | Not! | Not! | Should -Be $true
    }
    It '$null' {
        $expected = ! ($null)
        $null | Not! | Should -Be $expected

        $expected = ! ! ($null)
        $null | Not! | Not! | Should -Be $expected -Because 'Should Mirror $null truth table, for scalars'
    }
    It 'Empty String' {
        $expected = ! ( '' )
        '' | Not! | Should -Be $expected

        $expected = ! ! ( '' )
        '' | Not! | NoT! | Should -Be $expected
    }

    It 'Elements' {
        $sample = $true, $false, $true
        $sample | not!
        | Should -Be @($false, $true, $false)
    }
}
