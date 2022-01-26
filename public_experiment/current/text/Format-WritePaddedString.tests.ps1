#Requires -Module @{ ModuleName = 'Pester'; ModuleVersion = '5.0' }
before all {
    Import-Module Dev.Nin
}

Describe 'Format-WritePaddedString' {
    BeforeAll {
        $Expected['SpaceLeft'] = @'
        12345
            cat
'@

    }
    It 'char Pipe' {
        $row = 932445, 'cat'
        $row | Format-WRitePaddedString -

    }
}
