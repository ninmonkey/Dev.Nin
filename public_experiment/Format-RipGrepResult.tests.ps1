BeforeAll {
    Import-Module Dev.Nin -Force
}

Describe 'Format-RipGrepResult' {
    BeforeAll {
        $Path = @{
            Self = Get-Item .
        }
        $Template = @{
            NumberPrefix = '{1}:{0}'
            NumberSuffix = '{0}:{1}' # man I need templates
        }
    }
    Context 'Parsing numeric Paths' {
        BeforeAll {
            $strBefore = $Template.NumberPrefix -f @(
                $Path.Self.FullName
                '4'
            )
            $strAfter = $Template.NumberPrefix -f @(
                $Path.Self.FullName
                '4'
            )
            h1 ($strBefore) | Write-Host
        }
        It 'Should Not Throw on: "<_>"' -ForEach @(
            # $strBefore
            # $Path.self.FullName
            # $strAfter
            '4:{0}' -f @( $PSCommandPath)
            '{0}:4' -f @( $PSCommandPath)
        ) {
            $curItem = $_ 
            { 
                $curItem | Format-RipGrepResult -AsText
            } | Should -Not -Throw
            # { $strBefore | Format-RipGrepResult -AsText }
            # | Should -Not -Throw
            # { $strAfter | Format-RipGrepResult -AsText }
            # | Should -Not -Throw
        }

    }
    It 'Numbers Before' -Pending {
        $parsedPath = 'trylaunch.ps1:5' | Format-RipGrepResult -AsText        

        { $parsedPath | Get-Item } | Should -Not -Throw
        Get-Item $parsedPath | ForEach-Object FullName | Should -Be 
    }
    It 'Numbers After' {
        'trylaunch.ps1:5'
        | Format-RipGrepResult -AsText | Get-Item
    }
}
# C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin\public_experiment\Format-RipGrepResult.tests.ps1