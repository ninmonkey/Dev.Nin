#Requires -Version 7.0
#Requires -Module Pester
BeforeAll {
    Import-Module Dev.Nin -Force
}

Describe 'String-NinReplace' {
    Describe 'Templates' {
        BeforeAll {
            $Message = 'hi world   .md'
        }
        It 'Markdown: hi world' {
            $expect = 'hi_world___.md'
            $Message
            | Dev.Nin\StrReplace -Template Markdown_Underscore
            | Should -BeExactly $Expect

        }
        It 'Narkdown: Invert' {
            $Message
            | Dev.Nin\StrReplace -Template Markdown_Underscore
            | Dev.Nin\StrReplace -Template Markdown_InvertEscapeSpace
            | Should -BeExactly $Message
        }
        It '"<Name>" Returns "<expected>"' -ForEach @(
            # hi world
            @{
                Name =
                Expected = y

                'Markdown_InvertUnderscore',
                'Markdown_EscapeSpace'
                'Markdown_InvertEscapeSpace'
            }
            @{
                Name      = 'Markdown_Underscore'
                InputText =
            }
        ) {
            # . $__PesterFunctionName $Name | Should -Be $Expected
            $src | StrReplace -Template Markdown_Underscore -Verbose -Debug | Should -Be 'dsf'
        }
    }
}
