BeforeAll {
    Import-Module Dev.Nin -Force
    $color = @{
        SkyBlue      = '#85BDD8'
        FgDim        = 'gray60'
        PesterGreen  = '#3EBC77'
        PesterPurple = '#A35BAA'
    }
}

Describe 'Format-Dict: Visual Test' -Skip -Tag 'VisualTest', 'ANSIEscape', 'UsingWriteHost' {
    <#
    todo:
        does a custom rule fix this? currently test outputs first,
            then Pester test label prints after.
    #>

    It '"<Name>"' -ForEach @(
        @{
            Name        = 'stuff'
            InputObject = @{}
            # Config = @{}
        }
        @{
            Name        = 'Profile'
            InputObject = $Profile
            # Config = @{}
        }
    ) {
        @(

            hr
            Write-Color -t $Name $color.SkyBlue
            | str Prefix (Write-Color -t 'Name: ' $color.FgDim)


            $InputObject | Format-Dict

            # $profile | Format-Dict
        ) | Write-Host

    }

    It 'Default args' {
        $stdout = @(
            @{a = 3 }

        )
        $stdout | Write-Host
        # @{a = 3 } | Format-dict -Options @{'DisplayTypeName' = $false }
        # @{a = 3 } | Format-dict -Options @{'DisplayTypeName' = $true }
        # @{a = 3 } | Format-dict -Options @{'DisplayTypeName' = $true ;
        #     'PrefixLabel'                                    = 'true';
        # }
    }
    It 'Default Options: "<Name>"' -ForEach @(
        @{
            Name = 'stuff'
            'x'  = @{a = 1 ; b = @('a'..'f') }
        }
        @{
            Name = 'Profile'
            'x'  = $Profile
        }
    ) {
        @(
            $x | Format-Dict
        ) | Write-Host
    }
    It 'Solo' {
        @(
            $Profile | Format-Dict
        ) | Write-Host
    }

    It 'future' -Skip {

        if ($false) {
            @{a = 3 } | Format-dict -Options @{
                'DisplayTypeName' = $false
                'PrefixLabel'     = '<Label>'
            } -infa Continue -Debug -ea break

            if ($false) {
                @{a = 3 } | Format-dict -Options @{'DisplayTypeName' = $true ; 'PrefixLabel' = 'true'; } -ea break
                @{a = 3 } | Format-dict -Options @{'DisplayTypeName' = $false } -ea break
                @{a = 3 } | Format-dict -Options @{'DisplayTypeName' = $false } -infa Continue -Debug -ea break
            }
        }
    }
}