BeforeAll {
    Import-Module Dev.Nin
}

Describe 'Get-UnicodeLength' {
    It 'Unicode Length "<Text>" == <Expected> ' -ForEach @(
        @{ Text = '🐒' ; Expected = 1 }        
        @{ Text = 'a' ; Expected = 1 }        
        @{ Text = 'ab' ; Expected = 2 }        
    ) {
        Get-UnicodeLength -Text $Text
        | Should -Be $Expected -Because "It's the number of codepoints"

    }
}