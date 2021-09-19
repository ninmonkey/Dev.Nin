#requires -modules @{ModuleName='Pester';ModuleVersion='5.0.0'}
BeforeAll {
    Import-Module Dev.Nin -Force
    $ErrorActionPreference = 'stop'
}

Describe Write-AnsiBlock -Tag 'AnsiEscape' {
    It 'Basic Run' {
        [rgbcolor]'green' | Write-AnsiBlock -WithoutMode | Format-ControlChar
        | Should -Be '␛[102m ␛[49m'

        'green' | Write-AnsiBlock -WithoutMode | Format-ControlChar
        | Should -Be '␛[102m ␛[49m'
    }
}
Describe New-VtEscapeClearSequence -Tag 'AnsiEscape' {
    BeforeAll {
        $StrConst = @{
            Fg        = "${fg:clear}" | Format-ControlChar
            Bg        = "${bg:clear}" | Format-ControlChar
            Fg_and_Bg = "${fg:clear}${bg:clear}" | Format-ControlChar
        }
    }

    It '"Fg: <Fg> and Bg: <Bg>" Should be "<Expected>"' -ForEach @(
        @{ Fg = $true  ; Bg = $true; Expected = $StrConst.Fg_and_Bg }
        @{ Fg = $false ; Bg = $false; Expected = $StrConst.Fg_and_Bg }
        @{ Fg = $true  ; Bg = $false; Expected = $StrConst.Fg }
        @{ Fg = $false ; Bg = $true; Expected = $StrConst.Bg }
    ) {
        New-VtEscapeClearSequence -Fg:$Fg -bg:$Bg
        | Format-ControlChar | Should -Be $Expected
    }
}
