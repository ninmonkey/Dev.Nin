BeforeEach {
    Import-Module dev.nin -Force
}

Describe 'Module: Dev.nin' -Skip {
    It 'Import Does not Throw' {
        { Import-Module Dev.Nin -Force -ea stop } | Should not -Throw
    }
}