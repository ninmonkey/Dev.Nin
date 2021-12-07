#Requires -Version 7.0

BeforeAll {
    Import-Module Dev.Nin -Force
}

Describe 'ShortenString' {
    BeforeAll {
        $Sample = @{
            BasicA = 'For a list of approved verbs, type Get-Verb'
        }

    }
    It 'First N' {
        $Sample.BasicA | ShortenString -MaxLength 3
        | Should -Be 'For'
    }
    It 'Last N' {
        $Sample.BasicA | ShortenString -MaxLength 4 -FromEnd
        | Should -Be 'Verb'
    }
}
