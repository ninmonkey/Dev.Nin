#Requires -Version 7
#Requires -Module @{ ModuleName = 'Pester'; ModuleVersion = '5.0' }

BeforeAll {
    Import-Module Dev.Nin -Force
}

Describe 'Test-ObjectHasProperty' {
    It 'Directory' {
        Get-Item .
        | Test-ObjectHasProperty -Prop 'Name', 'Length'
        | Should -BeExactly @($true, $false)
    }

    It 'All Props (static)' {
        @{} | Test-ObjectHasProperty -prop 'Count', 'IsFixedSize', 'IsReadOnly', 'IsSynchronized', 'Keys', 'SyncRoot', 'Values'
        | Should -BeIn @($true)
    }
    It 'All Props (dynamic)' {
        $names = @{} | Iter->PropName
        @{} | Test-ObjectHasProperty -prop $Names
        | Should -BeIn @($true)
    }
}
