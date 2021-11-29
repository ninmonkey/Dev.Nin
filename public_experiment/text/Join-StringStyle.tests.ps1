BeforeAll {
    Import-Module 'Dev.Nin' -Force #-wa ignore
    # $ErrorAction = 'Break'
    # New-Alias 'str' -Value Join-StringStyle
    # $ErrorAction = 'Break'
}

Describe 'Join-StringStyle' {
    # BeforeAll {
    #     # $ErrorActionPreference = 'break'
    #     $Listing = @{
    #         SmartAliases   = @(
    #             'Str', 'JoinStr',
    #             'Csv', 'NL',
    #             'Prefix', 'Suffix',
    #             'QuotedList',
    #             'UL', 'Checklist'
    #         )
    #         JoinStyleParam = @(
    #             'Csv', 'NL', 'Prefix', 'QuotedList',
    #             'UL', 'Checklist'
    #         )
    #     }
    # }
    #     It 'Split Inputs by Newline -SplitNL' {
    #         $ExpectedLiteral = @'

    # - a
    # - b
    # '@ -split '\r?\n' | Join-String -sep "`n"
    #         # $ExpectedLiteral = $ExpectedLiteral -split '\r?\n' | str nl
    #         $InputText = "a`nb"
    #         $Expected = $InputText -split '\r?\n' | str ul
    #         $a = $InputText | Split-String Newline | Str UL
    #         $b = $InputText | Str UL -SplitNL

    #         $a | Should -Be $b
    #         $a | Should -Be $Expected
    #         $a | Should -Be $ExpectedLiteral -Because 'Was statically created from original'
    #         $a | uni->Length | Should -Be 8
    #     }


    # Context 'ToImplement' {
    #     It 'Propertynames' -Pending {
    #         # props NYI
    #         { Get-ChildItem . | Join-StringStyle NL 'hi' Name -ea stop }
    #         | Should -Not -Throw -Because 'On TodoList: Property name'
    #     }
    #     It 'Propertynames' -Pending {
    #         { Get-ChildItem . | Join-StringStyle NL 'hi' Name -ea stop }
    #         | Should -Not -Throw -Because 'Samplecase'

    #         { Get-ChildItem . | Join-StringStyle NL 'hi' Name -Dbg -ea stop }
    #         | Should -Not -Throw -Because 'On TodoList: Property name'
    #     }
    # }
    Context 'Newer Tests' {
        It 'a' {
            Should -Be $false

        }
    }
    Context 'Older Tests' {
        Describe '$null Joiner' {

            It 'Expect Empty and Null to be Equal' {
                $a = 0..2 | str csv
                $b = 0..2 | str csv -sep $Null
                $c = 0..2 | str csv -sep ''
                $a | Should -Be $B
                $a | Should -Be $c
            }
        }
        Describe 'Quotes' {
            Context 'With Joiner' {
                It 'Default' {
                    0..2 | str Csv -SingleQuote | Should -Be "'0','1','2'"
                }
                It 'Default Double' {
                    0..2 | str Csv -DoubleQuote | Should -Be '"0","1","2"'
                }
                It 'Space' {
                    0..2 | str Csv -sep ' ' -SingleQuote | Should -Be "'0', '1', '2'"

                }
                It 'Space Double' {
                    0..2 | str Csv -sep ' ' -DoubleQuote | Should -Be '"0", "1", "2"'
                }

            }
        }
        Describe 'Styles Implemented' {
            It '<Style> is <Expected>' -Foreach @(
                @{ Style = 'Csv'; Expected = '0,1,2,3' }  # ; #Expected = y }
                @{ Style = 'NL'; Expected = "0`n1`n2`n3" } # ; #Expected = y }
                # @{ Style = 'QuotedList' ; $Expected = "'0', '1', '2', '3'" } # ; #Expected = y }
                # @{ Style = 'Prefix'; Expected = ': 0, 1, 2, 3' } # ; #Expected = y }
            ) {
                $InputObject = 0..3
                $InputObject | Join-StringStyle -JoinStyle $Style
                | Should -Be $Expected
            }

            It 'Valid Styles <Style>' -Foreach @(
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
                | Should -Not -Throw
            }

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
            It '<Style> is <Expected>' -Foreach @(
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
}