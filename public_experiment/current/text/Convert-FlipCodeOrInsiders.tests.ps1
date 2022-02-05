
BeforeAll {
    # Import-Module Dev.NiN -Force
    . (Get-Item(Join-Path $PSSCriptRoot 'Convert-FlipCodeOrInsiders.ps1'))
}

Describe 'Convert-FlipCodeOrInsiders' {
    BeforeAll {
        $Example = @{}
        $Example.Settings_Insider = 'C:\Users\cppmo_000\AppData\Roaming\Code - Insiders\User\settings.json'
        $Example.Settings_Code = 'C:\Users\cppmo_000\AppData\Roaming\Code\User\settings.json'
    }
    It 'First' {
        $Example.Settings_Insider
        | Dev.Nin\Convert-FlipCodeOrInsiders
        | Should -Be $Example.Settings_Code
    }
}
