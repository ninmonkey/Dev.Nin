# requires -modules @{ModuleName='Pester';ModuleVersion='5.0.0'}
# $SCRIPT:__PesterFunctionName = $myinvocation.MyCommand.Name.split('.')[0]

Describe 'Match-String' -Tag Unit {
    BeforeAll {
        Import-Module Dev.Nin -Force
        # . $(Get-ChildItem -Path $PSScriptRoot/.. -Recurse -Filter "$__PesterFunctionName.ps1")
        # $Mocks = Resolve-Path "$PSScriptRoot/Mocks"
        $ErrorActionPreference = 'stop'
    }
    It 'Runs without error' {
        { 'foo' | Match-String -Regex 'o' }
        | Should -Not -Throw
    }
    Describe 'Basic Static' {
        BeforeAll {
            $Sample1 = 'a', '3', 'eaf'
        }
        Describe 'Supports Null' {
            <#
                - Should It allow null without opt-ing in?
                    for dealing with piped in raw text, yes, allow should not throw
                - if compared to an object, then, null should require an opt-in
            #>
            # It 'Null Param From Pipe' {
            #     # $null | Match-String '.*'
            #     # $null | Should -Be $Null
            #     # $null | Where-Object { $_ -match '' }
            # }
        }
        It 'Basic Static' {
            $Res1 = $Sample1 | Where-Object { $_ -match '\d+' }
            $Res1 = $Sample1 | Match-String { '\d+' }
            # 'a', 'd', '3' | Match-String
            $res1 = 'a', '3', 'eaf' | Where-Object { $_ -match '\d+' }
            $res2 = 2
        }

    }
    Describe 'NotMatching' {
        It 'default' {
            'a', '3' | Match-String '\d+'  -ea break
            | Should -Be '3'

        }
        It '-Not' {
            'a', '3' | Match-String -Not '\d+'   -ea break
            | Should -Be 'a'
        }
    }
}
