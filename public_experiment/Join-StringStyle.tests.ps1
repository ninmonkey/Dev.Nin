BeforeAll {
    Import-Module 'Dev.Nin' -Force #-wa ignore
    # $ErrorAction = 'Break'
}
# $ErrorAction = 'Break'

Describe 'Dev.Join-StringStyle' {
    BeforeAll {
    }
    It 'works?' {
        $true | Should -Be $True
    }
    Context 'ToImplement' {
        It 'Propertynames' {
            { Get-ChildItem . | Dev.Join-StringStyle NL 'hi' Name } | Should -Not -Throw -Because 'On TodoList: Property name'
        }
        It 'Propertynames' {
            { Get-ChildItem . | Dev.Join-StringStyle NL 'hi' Name | Write-Debug }
            | Should -Not -Throw -Because 'Samplecase'

            { Get-ChildItem . | Dev.Join-StringStyle NL 'hi' Name -Dbg | Write-Debug } | Should -Not -Throw -Because 'On TodoList: Property name'
        }
    }
    Describe 'Styles Implemented' {

        It 'No Styles Throw?' {
            # Should be dynamics
            {
                'Csv', 'NL', 'Prefix', 'QuotedList', 'Pair'
                | ForEach-Object {
                    0..2 | Dev.Join-StringStyle -JoinStyle $_ #'testInput'
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
            { $InputObject | Dev.Join-StringStyle -JoinStyle $Style }
            | Should -Not -Throw
        }
    }
    It 'HardCodedSample' {
        $Expected = 0..3 -join ', '
        0..3 | Dev.Join-StringStyle Csv -ea Break -Debug #-wa Continue
        | Should -Be $Expected
    }
    Describe 'Styles'  -ForEach @(
        @{ Style = 'Csv'; Expected = '0, 1, 2' }  # ; #Expected = y }
        @{ Style = 'NL'; Expected = "0`n1`n2" } # ; #Expected = y }
        # @{ Style = 'QuotedList' ; $Expected = "'0', '1', '2', '3'" } # ; #Expected = y }
        @{ Style = 'Pair'; Expected = 'Numbers: 0, 1, 2, 3' } # ; #Expected = y }
    ) {
        $InputObject ??= 0..3
        $InputObject | Dev.Join-StringStyle -JoinStyle $Style
        | Should -Be $Expected
    }

    Describe 'Sorting' {
        It 'Csv' {
            'e', 'z', 'a' | Dev.Join-StringStyle -JoinStyle Csv -Sort
            | Should -Be 'a, e, z'
        }
        It 'Unique' {
            'z', 'e', 'z', 'a', 'e' | Dev.Join-StringStyle -JoinStyle Csv -Sort -Unique
            | Should -Be 'a, e, z'
        }
    }

}
