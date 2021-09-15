#requires -modules @{ModuleName='Pester';ModuleVersion='5.0.0'}
$SCRIPT:__PesterFunctionName = $myinvocation.MyCommand.Name.split('.')[0]
BeforeAll {
    Import-Module Dev.Nin -Force
    # $ErrorActionPreference = 'break'
}

Describe "$__PesterFunctionName" {
    It '"<SampleText>" Returns "<expected>"' -ForEach @(
        @{ SampleText = '🐱‍👤' ; Expected = '"`u{1f431}`u{200d}`u{1f464}"' }
        # @{ SampleText = '🐒> ${‍} -eq ${‍‍}'
        #     Expected  = "`u{1f412}`u{3e}`u{20}`u{24}`u{7b}`u{200d}`u{7d}`u{20}`u{2d}`u{65}`u{71}`u{20}`u{24}`u{7b}`u{200d}`u{200d}`u{7d}"
        # }
    ) {
        ConvertTo-PwshLiteral -InputText $SampleText | Should -Be $Expected -Because 'Manually verified samples'
    }

    It 'Preserves Ascii non-control group chars' {
        $Sample = "Hi`tWorld"
        $Expected = "Hi`u{9}World"
        $Sample | ConvertTo-PwshLiteral
        | Should -Be $Expected -Because 'Non control chars are kept intact.'
    }
}
