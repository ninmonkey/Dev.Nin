BeforeAll {
    Import-Module Dev.Nin -Force
    Import-Module ninmonkey.console -Force
}

Describe 'New-VSCodeSnippet' {
    BeforeAll {
        [hashtable]$Sample = [ordered]@{}

        $Sample.Sample1 = @'
,
'@
        $Sample.Expected1 = @'
","
'@
    }
    It '"<Sample>" = "<Expected>"' -Pending -ForEach @(
        @{ Sample = $Sample.Sample1 ; Expected = $Sample.Expected1 }
    ) {
        $Sample | New-VSCodeSnippet -Verbose -Debug
        | Should -Be $Expected
    }
    It 'manual1' {

        $Sample.Sample1 | Should -Be $Sample.Expected1

    }
}

