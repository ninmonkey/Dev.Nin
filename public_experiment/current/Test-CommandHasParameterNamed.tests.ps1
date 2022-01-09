#requires -modules @{ModuleName = 'Pester'; ModuleVersion = '5.0.0' }
#Requires -Version 7

BeforeAll {
    Import-Module Dev.Nin -Force
}

Describe 'Test-CommandHasParameterNamed' {
    It 'Known Names' {
        Test-CommandHasParameterNamed -Command 'Microsoft.PowerShell.Management\Get-ChildItem' -Param 'Path'
        | Should -Be $True

    }
    It 'Alias with Known Names' {
        Test-CommandHasParameterNamed 'ls' -Param 'Path'
        | Should -Be $True

    }
    It 'Missing Names' {

        Test-CommandHasParameterNamed -Command 'Microsoft.PowerShell.Management\Get-ChildItem' -Param 'fakedoesnotexist'
        | Should -Be $false
    }
}
