#requires -modules @{ModuleName='Pester';ModuleVersion='5.0.0'}
$SCRIPT:__PesterFunctionName = $myinvocation.MyCommand.Name.split('.')[0]
BeforeAll {
    Import-Module Dev.Nin -Force
    # . $(Get-ChildItem -Path $PSScriptRoot/.. -Recurse -Filter "$__PesterFunctionName.ps1")
    # $Mocks = Resolve-Path "$PSScriptRoot/Mocks"
    # $ErrorActionPreference = 'Stop'
}

Describe "$__PesterFunctionName" {
    It '"<TypeNameStr>" Returns "<expected>"' -ForEach @(
        @{
            TypeNameStr = 'PoshCode.Pansies.RgbColor'
            Expected    = [PoshCode.Pansies.RgbColor]
        }
        @{
            TypeNameStr = 'IO.FileInfo'
            Expected    = [IO.FileInfo]
        }
    ) {
        $tinfo = $TypeNameStr | New-TypeInfo
        $tinfo | Should -BeOfType 'type'
        $tinfo | Should -Be $Expected
    }
}
