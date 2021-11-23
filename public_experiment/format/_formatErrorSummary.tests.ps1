BeforeAll {
    Import-Module Dev.Nin -Force
}

Describe 'formatErr' -Tag 'Write-Host', 'Ansi', 'Color', 'Console' {
    BeforeAll -Skip {
        # # generate some errors
        # 1 / 0
        # [uint]-14
    }
    It 'basic' {
        @(
            $global:error | Get-Random -Count 10
            | formatErr -Options @{'ColorErrorRed' = 'red' }
        ) | Write-Host
        $true | Should -Be $True
        # Set-ItResult -Pending -Because 'write-host' -
    }
}
    