BeforeAll {
    Import-Module Dev.Nin -Force   
}

Describe 'Measure-NinSum' {
    BeforeAll {
        # $ErrorActionPreference = 'break'
    }
    It 'Measure-Object -Sum fails' {
        { @( Get-Date; Get-Date) | Measure-Object -Sum -ea stop }
        | Should -Throw -Because 'It is not using datetime''s sum methods'
    }
    It 'Final is equal to Explicit Sum' {
        $results = 0..4 | ForEach-Object {
            Measure-Command -InputObject 'x' -Expression { Get-ChildItem . }
        } 

        $explicitSum = $results
        | Measure-Object -Sum -Property TotalMilliseconds
        | ForEach-Object sum
    
        $results
        | Sum∑ -WithoutMeasureObject
        | ForEach-Object totalmilliseconds
        | Should -Be $explicitSum -Because 'Should Be Exactly Equal depsite decimal (Adding ms)'        
    }
}