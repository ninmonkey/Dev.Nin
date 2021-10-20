BeforeAll {
    Import-Module 'Dev.Nin' -Force #-wa ignore
    # $ErrorAction = 'Break'
}
# $ErrorAction = 'Break'

Describe 'Join-StringStyle' {
    BeforeAll {
        $ErrorActionPreference = 'break'
        $Listing = @{
            SmartAliases   = @(
                'Str', 'JoinStr',
                'Csv', 'NL',
                'Prefix', 'Suffix',
                'QuotedList',
                'UL', 'Checklist'
            )
            JoinStyleParam = @(
                'Csv', 'NL', 'Prefix', 'QuotedList',
                'UL', 'Checklist'
            )
        }
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


        It '<Style> is <Expected>' -ForEach @(
            @{ Style = 'Csv'; Expected = '0, 1, 2, 3' }  # ; #Expected = y }
            @{ Style = 'NL'; Expected = "0`n1`n2`n3" } # ; #Expected = y }
            # @{ Style = 'QuotedList' ; $Expected = "'0', '1', '2', '3'" } # ; #Expected = y }
            # @{ Style = 'Prefix'; Expected = ': 0, 1, 2, 3' } # ; #Expected = y }
        ) {
            $InputObject = 0..3
            $InputObject | Join-StringStyle -JoinStyle $Style
            | Should -Be $Expected
        }

        It 'Valid Styles <Style>' -ForEach @(
            @{ Style = 'Csv' }
            @{ Style = 'NL' }
            # @{ Style = 'Prefix' } # requires param
            @{ Style = 'QuotedList' }
            @{ Style = 'UL' }
            @{ Style = 'Checklist' }
        ) {
            {

                0..2 | Join-StringStyle -JoinStyle $Style #'testInput'
            }
        } | Should -Not -Throw

    }
    # Should be dynamics

    # It 'JoinStyle: "<Style>" does not throw?' -ForEach @(
    #     @{ Style = 'Csv' } # ; #Expected = y }
    #     @{ Style = 'NL' } # ; #Expected = y }
    #     @{ Style = 'QuotedList' } # ; #Expected = y }
    #     @{ Style = 'Pair' } # ; #Expected = y }
    # ) {
    #     $InputObject = 0..3
    #     { $InputObject | Join-StringStyle -JoinStyle $Style }
    #     | Should -Not -Throw
    # }

    It 'HardCodedSample' {
        $Expected = 0..3 -join ', '
        0..3 | Join-StringStyle Csv -ea Stop -Debug #-wa Continue
        | Should -Be $Expected
    }
    Describe 'Styles Without SecondaryParams' {
        It '<Style> is <Expected>' -ForEach @(
            @{ Style = 'Csv'; Expected = '0, 1, 2, 3' }  # ; #Expected = y }
            @{ Style = 'NL'; Expected = "0`n1`n2`n3" } # ; #Expected = y }
            # @{ Style = 'QuotedList' ; $Expected = "'0', '1', '2', '3'" } # ; #Expected = y }
            # @{ Style = 'Pair'; Expected = ': 0, 1, 2, 3' } # ; #Expected = y }
        ) {
            $InputObject = 0..3
            $InputObject | Join-StringStyle -JoinStyle $Style
            | Should -Be $Expected
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