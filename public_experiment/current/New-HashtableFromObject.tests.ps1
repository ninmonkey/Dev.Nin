BeforeAll {
    Import-Module Dev.Nin -Force
    # future: Move to /ninmonkey/console
}

Describe 'New-HashtableFromObject' {
    BeforeAll {
        $Now = Get-Date
    }

    It 'Default Properties are Equal' {
        $hashKeyNames = $Now | New-HashtableFromObject | ForEach-Object Keys | Sort-Object
        $objPropertyNames = $Now.psobject.properties.name | Sort-Object
        $hashKeyNames | Should -Be $objPropertyNames -Because 'otherwise properties are missing'
    }
    Describe 'Include Exclude Precedence Order' {
        # expected: IncludeRegex, ExcludeRegex, LiteralInlude
        BeforeAll {
            $now = Get-Date
            $DtExpectedProps = 'Date', 'DateTime', 'Day', 'DayOfWeek', 'DayOfYear', 'DisplayHint', 'Hour', 'Kind', 'Millisecond', 'Minute', 'Month', 'Second', 'Ticks', 'TimeOfDay', 'Year'
        }
        It 'Baseline Expected Names' {
            $now | New-HashtableFromObject | ForEach-Object keys
            | Should -BeIn $DtExpectedProps
        }
        It 'Step1: includeRegex' {
            $now | New-HashtableFromObject -RegexInclude 'time'
            | ForEach-Object keys
            | Should -BeExactly 'DateTime', 'TimeOfDay'
        }
        It 'Step2: filterRegex' {
            $now | New-HashtableFromObject -RegexInclude 'time' -ExcludeProperty '^date'
            | ForEach-Object keys
            | Should -BeExactly 'TimeOfDay'
        }
        It 'Step3: Include Literal' {
            $now | New-HashtableFromObject -RegexInclude 'time' -ExcludeProperty '^date' -LiteralInclude 'DateTime'
            | ForEach-Object keys
            | Should -BeExactly 'TimeOfDay', 'DateTime'
        }
    }
}
