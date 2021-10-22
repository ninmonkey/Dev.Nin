#requires -modules @{ModuleName='Pester';ModuleVersion='5.0.0'}
$SCRIPT:__PesterFunctionName = $myinvocation.MyCommand.Name.split('.')[0]
BeforeAll {
    Import-Module Dev.Nin -Force
    # $ErrorActionPreference = 'break'
}


Describe 'ConvertTo-PwshLiteral' {
    <#
     problem
        string compares are failing
        they will say

            '"Hi\tWorld"'

        strings are encased in quotes
        or don't interpolate like "u{hex}"

     #>
    It 'StaticInvoke With Ascii' {
        $Text = "Hi`u{9}World"
        $Expected = "Hi`vWorld"
        $ExpectedSymbols = 'Hi␉World'

        $Text | ConvertTo-PwshLiteral -PreserveAscii
        | Should -Be $Expected -Because 'It''s "correct", Pester isn''t evaluating string'

        $Text | ConvertTo-PwshLiteral -PreserveAscii
        | Format-ControlChar
        | Should -Be $ExpectedSymbols

        # | should -be "Hi`u{9}World"
    }
    It 'StaticInvoke With Ascii' {
        $Text = "Hi`u{9}World"
        $ExpectedSymbols = 'Hi␉World'

        $Text | ConvertTo-PwshLiteral -PreserveAscii
        | Format-ControlChar
        | Should -Be $ExpectedSymbols -Because 'It''s "correct", Pester isn''t evaluating string'
    }
    It '"<Text>" Returns "<Expected>"' -ForEach @(
        @{
            Text     = '🐱‍👤' ;
            Expected = '"`u{1f431}`u{200d}`u{1f464}"'
        }
        @{
            Text     = "Hi`u{9}World"
            Expected = ''
        }
        @{
            Text          = "Hi`u{9}World"
            Expected      = ''
            PreserveAscii = $true
        }
        @{
            Text     = "Hi`u{9}World"
            Expected = 'Hi	World'
        }

        # @{ SampleText = '🐒> ${‍} -eq ${‍‍}'
        #     Expected  = "`u{1f412}`u{3e}`u{20}`u{24}`u{7b}`u{200d}`u{7d}`u{20}`u{2d}`u{65}`u{71}`u{20}`u{24}`u{7b}`u{200d}`u{200d}`u{7d}"
        # }
    ) {
        $convertToPwshLiteralSplat = @{

            InputText     = $Text
            PreserveAscii = $null # should be error on null?
        }

        ConvertTo-PwshLiteral @convertToPwshLiteralSplat | Should -Be $Expected -Because 'Manually verified samples'
    }

    It 'Preserves Ascii non-control group chars' {
        $Sample = "Hi`tWorld"
        $Expected = "Hi`u{9}World"
        $Sample | ConvertTo-PwshLiteral
        | Should -Be $Expected -Because 'Non control chars are kept intact.'

        "Hi`tWorld" | ConvertTo-PwshLiteral -PreserveAscii
        | Should -Be 'Hi	World'

    }
    It 'stuff' {
        'a f23jaf23j' | ConvertTo-PwshLiteral -PreserveAscii
        | Join-String -op '-PreserveAscii: '
        'a f23jaf23j' | ConvertTo-PwshLiteral
        | Join-String -op 'default: '

    }
}
