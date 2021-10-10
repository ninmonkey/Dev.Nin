#requires -modules @{ModuleName='Pester';ModuleVersion='5.0.0'}
$SCRIPT:__PesterFunctionName = $myinvocation.MyCommand.Name.split('.')

# Describe "$__PesterFunctionName" {
Describe 'Test-OneOrNone' {
    BeforeAll {
        # . $__PesterFunctionName # dotsource
        Import-Module 'dev.nin' -Force
        $ErrorActionPreference = 'Stop'
        $ErrorActionPreference = 'break'
    }
    It 'Runs without error' {
        { 'a' | Test-OneOrNone } | Should -Not -Throw
    }
    Describe 'ParameterBinding' {
        It 'FromPipeline' {
            'a', 'b' | Test-OneOrNone -ea ignore
            | Should -Be $null

            { 'a', 'b' | Test-OneOrNone -ea stop }
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