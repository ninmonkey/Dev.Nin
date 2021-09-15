#requires -modules @{ModuleName='Pester';ModuleVersion='5.0.0'}
$SCRIPT:__PesterFunctionName = $myinvocation.MyCommand.Name.split('.')[0]
BeforeAll {
    Import-Module dev.nin -Force
    # . $(Get-ChildItem -Path $PSScriptRoot/.. -Recurse -Filter "$__PesterFunctionName.ps1")
    # $Mocks = Resolve-Path "$PSScriptRoot/Mocks"
    $ErrorActionPreference = 'Stop'
}

Describe "$__PesterFunctionName" -Tag Unit {
    Describe 'Basic Hardcoded' {
        It 'As Pipeline' {
            'abc' | ShortenString 2 | Should -Be 'ab'
        }
        It 'As Param' {
            ShortenString 'abc' 2 | Should -Be 'ab'
        }
    }
    Describe 'Runs Without Error' {
        # $ErrorActionPreference = 'break;'
        It 'Single Null and Empty Strings' {

            # $ErrorActionPreference = 'break;'

            $splatNotThrow = @{
                Not     = $true
                Throw   = $True
                Because = 'It should silently allow nulls or empty strings to pass'
            }
            { '' | ShortenString } | Should -Not -Throw
            { $null | ShortenString } | Should @splatNotThrow
            { $null, $Null | ShortenString } | Should @splatNotThrow
            { ShortenString '' } | Should @splatNotThrow
            { ShortenString $null } | Should @splatNotThrow

        }
        It 'Lists with  Null and Empty Strings' {
            $splatNotThrow = @{
                Not     = $true
                Throw   = $True
                Because = 'It should silently allow nulls or empty strings to pass'
            }
            # position 0 is not an array type, so 'mandatory' wait for user input
            { ShortenString '', '' } | Should @splatNotThrow
            { ShortenString $null, $null } | Should @splatNotThrow
            { '', '' | ShortenString } | Should @splatNotThrow
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
