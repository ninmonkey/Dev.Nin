BeforeAll {
    Import-Module 'Dev.Nin' -Force #-wa ignore
    # $ErrorAction = 'Break'
}
# $ErrorAction = 'Break'

Describe 'Join-StringStyle' {
    BeforeAll {
        # $ErrorActionPreference = 'break'
    }

    It 'works?' {
        $true | Should -Be $True
    }
    Context 'ToImplement' -Tag 'nyi' -Skip {
        It 'Propertynames' {
            { Get-ChildItem . | Join-StringStyle NL 'hi' Name } | Should -Not -Throw -Because 'On TodoList: Property name'
        }
        It 'Propertynames' {
            { Get-ChildItem . | Join-StringStyle NL 'hi' Name | Write-Debug }
            | Should -Not -Throw -Because 'Samplecase'

            { Get-ChildItem . | Join-StringStyle NL 'hi' Name -Dbg | Write-Debug } | Should -Not -Throw -Because 'On TodoList: Property name'
        }
    }
    Describe 'Styles Implemented' {

        It 'No Styles Throw?' {
            # Should be dynamics
            {
                'Csv', 'NL', 'Prefix', 'QuotedList', 'Pair'
                | ForEach-Object {
                    0..2 | Join-StringStyle -JoinStyle $_ #'testInput'
                }
            } | Should -Not -Throw
        }
        It 'JoinStyle: "<Style>" does not throw?' -ForEach @(
            @{ Style = 'Csv' } # ; #Expected = y }
            @{ Style = 'NL' } # ; #Expected = y }
            @{ Style = 'QuotedList' } # ; #Expected = y }
            @{ Style = 'Pair' } # ; #Expected = y }
        ) {
            $InputObject = 0..3
            { $InputObject | Join-StringStyle -JoinStyle $Style }
            | Should -Not -Throw
        }
    }
    It 'HardCodedSample' {
        $Expected = 0..3 -join ', '
        0..3 | Join-StringStyle Csv -ea Break -Debug #-wa Continue
        | Should -Be $Expected
    }
    Describe 'Styles' {
        It '<Style> is <Expected>' -ForEach @(
            @{ Style = 'Csv'; Expected = '0, 1, 2, 3' }  # ; #Expected = y }
            @{ Style = 'NL'; Expected = "0`n1`n2`n3" } # ; #Expected = y }
            # @{ Style = 'QuotedList' ; $Expected = "'0', '1', '2', '3'" } # ; #Expected = y }
            @{ Style = 'Pair'; Expected = ': 0, 1, 2, 3' } # ; #Expected = y }
        ) {
            $InputObject = 0..3
            $InputObject | Join-StringStyle -JoinStyle $Style
            | Should -Be $Expected
        }
        It 'Prefix' {

        }
        It 'Chained Prefix' {
            0..4
            | Join-StringStyle csv
            | Join-StringStyle Prefix 'numbers: '
            | Should -Be 'numbers: 0, 1, 2, 3, 4'
        }
    }

    Describe 'Sorting' {
        It 'Csv' {
            'e', 'z', 'a' | Join-StringStyle -JoinStyle Csv -Sort
            | Should -Be 'a, e, z'
        }
        It 'Unique' {
            'z', 'e', 'z', 'a', 'e' | Join-StringStyle -JoinStyle Csv -Sort -Unique
            | Should -Be 'a, e, z'
        }
    }

}
