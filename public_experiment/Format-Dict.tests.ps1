BeforeAll {
    Import-Module Dev.Nin -Force
}

Describe 'Format-Dict: Visual Test' -Skip -Tag 'VisualTest' {

    It 'Basic args' {
        $stdout = @(

            @{a = 3 } | Format-dict -Options @{'DisplayTypeName' = $false }
            @{a = 3 } | Format-dict -Options @{'DisplayTypeName' = $true }
            @{a = 3 } | Format-dict -Options @{'DisplayTypeName' = $true ; 'PrefixLabel' = 'true'; }
        )
        $stdout | Write-Host

    }
}