BeforeAll {
    Import-Module dev.nin -Force
}


Describe 'fmt-ShortenStringMiddle' {
    BeforeAll {
        $Sample1 = 'Gets the specified alternate NTFS file stream from the file. Enter the stream name. Wildcards are supported'
        $Sample2 = 'Gets the specified alternate NTFS file stream from the file'
        It 'Baseline test' {
            $expected = $s.Substring(0, 20)
            $Sample1 | ShortenString -MaxLength 20 -FromEnd:$false
            | Should -Be $expected
        }

        BeforeAll {

        }
        It 'static-test' {
            $true | Should -Be $true

        }
    }
}
