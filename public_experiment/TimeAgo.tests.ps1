BeforeAll {
    Import-Module Dev.Nin -Force
    Import-Module Ninmonkey.Console -Force
}

Describe 'Get-TimeStuff' {
    It 'a' {
        $tslist = @(
            2 | days
            3 | hours
        )

        $ts_sum = $tslist | Measure-Object TotalMilliSeconds -Sum | ForEach-Object Sum | ForEach-Object { 
            [timespan]::new(0, 0, 0, 0, $_)
        } 

        $ts_sum | Should -Be (RelativeTs 2d3h -Debug)

        $tslist = @(
            2 | days
            3 | hours
        )

        $total_ms = $tslist | Measure-Object TotalMilliSeconds -Sum | ForEach-Object Sum

        $ts_sum = $total_ms | ForEach-Object { 
            [timespan]::new(0, 0, 0, 0, $_)
        } 
        $tslist.TotalMilliseconds | Sum∑
    }
    Describe 'Results equal [timespan]::new' {
        It 'Basic Constructor' {
            2 | days 
            | Should -Be ([timespan]::new(2, 0, 0, 0, 0))
            
            5 | hours
            | Should -Be ([timespan]::new(0, 5, 0, 0, 0))

        }
        It 'need should be near value operator for floating' -Pending {
            $expected = [timespan]::new(0, 0, 354, 0, 0)
            
            354 | seconds
            | Should -Be $expected

            RelativeTs 354s
            | Should -Be $expected
        }
        # It '"<Timespan>" Returns "<expected>"' -ForEach @(
        #     @{
        #         Timespan = '0' ; Expected = '0'
        #         }
        # ) {
        #     YourFunction -Timespan $Timespan | Should -Be $Expected
        # }
    }

    Describe 'Summing Property Total Milliseconds' {
        BeforeAll {
            $timespan_list = @(
                2 | days
                3 | hours
            )
        }

        It 'Object vs Sum∑' {
            $sum1 = $timespan_list.TotalMilliseconds | Sum∑
            $sum2 = $timespan_list | Measure-Object -pro TotalMilliseconds -Sum | ForEach-Object sum
            $sum1 | Should -Be $sum2 -Because 'Duplicate Int sums should be equal'
        }
        It 'Equal to "RelativeTimespan"' { 
            $expected = RelativeTs 2d3h | ForEach-Object TotalMilliseconds
            
            $timespan_list.TotalMilliSeconds | Sum∑
            | Should -Be $expected
        }

    }
}