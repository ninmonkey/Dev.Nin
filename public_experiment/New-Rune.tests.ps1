BeforeAll {
    Import-Module Dev.Nin -Force
}

Describe 'New-Rune' {
    BeforeAll {
        $Str =  @{
            TrueNullStr = "`u{0}"
            NullSymbol = "`u{2400}"
            NL = "`n"
            CR = "`r"
        }
    }
    it 'NullStr' {
        New-Rune 0x2400
        | Should -be $Str.NullSymbol
    }
    it '-FormatControlChar' {
        New-Rune 0 | Format-ControlChar
        | Should -be "`u{2400}" 

        New-Rune 0 | Should -be $Str.TrueNullStr
    }
}