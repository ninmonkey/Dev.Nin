BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe 'Invoke-GitMergeMany' {
    BeforeAll {
    }

    It 'Bad Merge Name' {
        Invoke-GitMergeMany 'sdfsd'
        $false | Should -Be $false
    }
}
