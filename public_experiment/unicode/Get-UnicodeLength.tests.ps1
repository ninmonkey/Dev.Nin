BeforeAll {
    Import-Module Dev.Nin
}

Describe 'Convert-CharFromTo-Unicode' {
    BeforeAll {
        $Uni_String = @{
            Monkey = '🐒'
        }
        $Uni_Number = @{
            Monkey      = 0x1f412
            Random_list = 0x3dd23, 0xea47e, 0x75a0c, 0xfc155, 0x6225c
        }
    }
    
    It 'Round Trip' {
        $Uni_Number.Random_list
        | Convert-CharFromCodepoint
        | Convert-CodepointFromChar
        | Should -Be $Uni_Number.Random_list
    }

    Describe 'Compare-StringByChar' {
        It 'first' -Pending {
            $true | Should -Be $false
        }
    }
    Describe 'Convert-CharFromCodepoint' {
        It 'first' -Pending {
            $true | Should -Be $false
        }
    }
    Describe 'Convert-CodepointFromChar' {
        It '"<Text>" == <Expected> ' -ForEach @(

            @{ Text = $Uni_String.Monkey ; Expected = $Uni_Number.Monkey }        
            @{ Text = 'a' ; Expected = 1 }        
            @{ Text = 'ab' ; Expected = 2 }        
        ) {
            Get-UnicodeLength -Text $Text
            | Should -Be $Expected -Because "It's the number of codepoints"

        }
    }

    Describe 'Get-UnicodeLength' {
        It 'Unicode Length "<Text>" == <Expected> ' -ForEach @(
            @{ Text = '🐒' ; Expected = 1 }        
            @{ Text = 'a' ; Expected = 1 }        
            @{ Text = 'ab' ; Expected = 2 }        
            @{ Text = '' ; Expected = 2 }        
        ) {
            Get-UnicodeLength -Text $Text
            | Should -Be $Expected -Because "It's the number of codepoints"

        }
    }
}