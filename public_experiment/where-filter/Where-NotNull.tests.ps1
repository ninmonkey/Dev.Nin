BeforeAll {
    Import-Module Dev.Nin -Force
}

Describe 'Where-NotNull' {
    BeforeAll {
        $Sample.All3 = @(
            ''
            $null
            , @()
        )
    }
    Describe 'NullOrEmpty' {        
        It 'sdf' {

            "`n" | Where-NotNull NullOrEmpty | Should -Contain "`n"
            "`n" | Where-NotNull NullOrWhiteSpace | Should -Not -Contain "`n"
        }            
    }
    Describe 'NullOrWhiteSpace' {
        It 'static ' {
            'a', '', 'b' | Should -Contain ''
            'a', '', 'b' | Where-NotNull NullOrWhiteSpace | Should -Not -Contain ''
            'a', '', 'b' | Where-NotNull NullOrEmpty | Should -Not -Contain ''
        }
    }
    Describe 'TrueNull' {        
        It 'first' {
            # $null,
            'a', , @($null), $null, '', 'c'
            | Should -Contain $Null 

            'a', , @($null), $null, '', 'c'
            | Where-NotNull
            | Should -Not -Contain $Null 
        }
    }
}