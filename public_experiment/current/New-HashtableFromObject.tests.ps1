BeforeAll {
    Import-Module Dev.Nin -Force
}

Describe 'New-HashtableFromObject' {
    BeforeAll {
        $Now = Get-Date
    }

    It 'DoesNotThrow' {
        { Get-Date | New-HashtableFromObject -RegexInclude  'day', '.*year', 'kind' -ExcludeProperty '.*of.*'
        } | Should -Not -Throw

    }
    It 'IncludeProp' -Pending {
        #  see : Dev.Nin\Assert-HashtableEqual
        # Also need func to validate propery names, and values
        # and the same on hashtables
    }
    It 'ExcludeProp' -Pending {

    }
    It 'Include + Exclude' -Pending {
        newHashSplat = @{
            # Debug           = $True
            RegexInclude    = 'day', '.*year', 'kind'
            ExcludeProperty = '.*of.*'
        }

        $h = Get-Date | New-HashtableFromObject @newHashSplat

    }
}
