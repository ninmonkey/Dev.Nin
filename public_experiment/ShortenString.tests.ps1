#requires -modules @{ModuleName='Pester';ModuleVersion='5.0.0'}
$SCRIPT:__PesterFunctionName = $myinvocation.MyCommand.Name.split('.')[0]

Describe "$__PesterFunctionName" -Tag Unit {
    BeforeAll {
        Import-Module dev.nin -Force
        # . $(Get-ChildItem -Path $PSScriptRoot/.. -Recurse -Filter "$__PesterFunctionName.ps1")
        # $Mocks = Resolve-Path "$PSScriptRoot/Mocks"
        $ErrorActionPreference = 'Stop'
    }
    It 'Runs without error' {
        . $__PesterFunctionName 'test'
    }
    Describe 'Basic Hardcoded' {
        It 'As Pipeline' {
            'abc' | ShortenString 2 | Should -Be 'ab'
        }
        It 'As Param' {
            ShortenString 'abc' 2 | Should -Be 'ab'
        }
    }
    Describe 'Basic Ascii Strings' {
        It 'Sample: "<Sample>" Should Be: "<Expected>" When MaxLength <MaxLength>' -ForEach @(
            @{ Sample = 'asdfdsf'; Expected = 'asdf'; MaxLength = 4 }
            @{ Sample = 'asdfdsf'; Expected = 'asdfdsf'; MaxLength = 15 }
            @{ Sample = 'asdfdsf'; Expected = 'asdfdsf'; MaxLength = 'asdfdsf'.length }
        ) {

            # $Sample = 'asdfjaieajfsadfjffdsjajfjeafj'
            # $Expected = 'asdf'

            $short = ShortenString $Sample -MaxLength $MaxLength
            ($short.Length -le $MaxLength )
            | Should -Be $True
            $short | Should -Be $Expected
        }

    }
}
