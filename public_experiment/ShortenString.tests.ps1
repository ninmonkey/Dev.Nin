#requires -modules @{ModuleName='Pester';RequiredVersion='5.2.2'}
$SCRIPT:__PesterFunctionName = $myinvocation.MyCommand.Name.split('.')[0]

Describe "$__PesterFunctionName" -Tag Unit {
    BeforeAll {
        # . $(Get-ChildItem -Path $PSScriptRoot/.. -Recurse -Filter "$__PesterFunctionName.ps1")
        # $Mocks = Resolve-Path "$PSScriptRoot/Mocks"
        Import-Module dev.nin -Force
        $ErrorActionPreference = 'Stop'
    }
    # It 'Runs without error' {
    # . $__PesterFunctionName
    # }
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
