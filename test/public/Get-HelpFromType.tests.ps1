<#
    ref: https://jakubjares.com/2020/04/11/pester5-importing-ps-files/

     Tags like
        It "acceptance test 3" -Tag "WindowsOnly" {
            1 | Should -Be 1
        }

        It "acceptance test 4" -Tag "Slow", "LinuxOnly" {
            1 | Should -Be 1
        }

#>

BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe "Get-HelpFromType" {
    It 'should fail' {
        $false | Should -Be $false
    }

    It 'Module Help from Type Name' {
        $sample = 'PoshCode.Pansies.Text'
        $result = $sample | HelpFromType -PassThru
        $expected = 'https://github.com/PoshCode/Pansies'
        $result | Should -Be $expected
        # 'https://docs.microsoft.com/en-us/dotnet/api/PoshCode.Pansies.Text'
    }

    It 'Show help for System.String' {

        $expected = 'https://docs.microsoft.com/en-us/dotnet/api/System.String'
        $result = [system.string] | HelpFromType -PassThru
        | Should -Be $expected

        $result = 'system.string' | HelpFromType -PassThru
        | Should -Be $expected
    }

    It 'Multiple Default types: rewrite array to allow any sort order' {
        $sample = @(
            [RuntimeTypeHandle]
            [Reflection.Module]
            [Reflection.Assembly]
            [FullyQualifiedName]
            [ModuleHandle]
            [Reflection.Module]
        )
        $expected = @(
            'https://docs.microsoft.com/en-us/dotnet/api/System.RuntimeTypeHandle'
            'https://docs.microsoft.com/en-us/dotnet/api/System.Reflection.Module'
            'https://docs.microsoft.com/en-us/dotnet/api/System.Reflection.Assembly'
            'https://docs.microsoft.com/en-us/dotnet/api/System.ModuleHandle'
            'https://docs.microsoft.com/en-us/dotnet/api/System.Reflection.Module'
        )
        $sample | HelpFromType -PassThru
        | Should -be $expected
    }
    # next tests:

    # It 'Convert Null' {
    #     [char]::ConvertFromUtf32(0) | Format-ControlChar
    #     | Should -Be '␀'
    # }
    # It 'Test First 50 codepoints' {
    #     $sampleRunes = 0..50 | ForEach-Object {
    #         [char]::ConvertFromUtf32( $_ )
    #     }
    #     $expected = '␀␁␂␃␄␅␆␇␈␉␊␋␌␍␎␏␐␑␒␓␔␕␖␗␘␙␚␛␜␝␞␟ !"#$%&''()*+,-./012'

    #     $result = $sampleRunes | Format-ControlChar
    #     $result | Should -Be $Expected
    # }
}