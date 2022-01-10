#requires -modules @{ModuleName='Pester';ModuleVersion='5.0.0'}
$SCRIPT:__PesterFunctionName = $myinvocation.MyCommand.Name.split('.')
$Error.Clear()

Describe 'Test-OneOrNone' {
    BeforeAll {
        Import-Module 'dev.nin' -Force
        $Error.Clear()
        $ErrorActionPreference = 'stop'
    }
    It 'Runs without error' {
        { 'a' | Test-OneOrNone } | Should -Not -Throw
    }
    It 'basic pipe compare' {
        Test-OneOrNone (Get-ChildItem .. | Select-Object -First 3) | Should -Be $False -Because 'need to rework expectations,l something is wrong.'
    }
    Describe 'Mode: default' {
        # $ErrorActionPreference = 'break'
        'a', 'b' | Test-OneOrNone | Should -Be $false
        'a' | Test-OneOrNone | Should -Be $true
        It '$nulls' {

            $null | Test-OneOrNone | Should -Be $false
            $null | Test-OneOrNone -DisallowNull | Should -Be $false

            , @($null) | Test-OneOrNone | Should -Be $true
        }
    }
    Describe 'Mode: -PassThru/AsFilter' {
        # { 'a', 'e' | Test-OneOrNone -PassThru }
        # | SHould -be $null

        # 'a' | Test-OneOrNone -PassThru
        'a', 'b' | Test-OneOrNone | Should -Be $false
        'a' | Test-OneOrNone | Should -Be $true

    }
    Describe 'ParameterBinding' {
        BeforeEach {
            $error.Clear()
        }
        It 'FromPipeline' {
            $error.clear()
            'a', 'b' | Test-OneOrNone
            | Should -Be $false

            { 'a', 'b' | Test-OneOrNone -PassThru -ea break }
            | Should -Throw
        }
        It 'FromPipeline -Assert' {
            'a', 'b'
            | Test-OneOrNone -ea stop
            | Should -Be $null
        }

    }
}


# function Dive {
#     process {
#         # or Get-ChildItem .
#         $filtered = 'foo', 'bar', 'cat' | SomeFilter

#         if($filtered.count -ne 1) {
#             return
#         }
#         $filtered | Set-Location
#     }
# }
