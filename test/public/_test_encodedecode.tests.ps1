BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}


Describe "testEncode" {
    Context 'Encode/Decode Monkey' {
        BeforeAll {
            $Sample = @{
                Name      = 'Monkey'
                Text      = '🐒'
                Bytes     = [byte[]]@(0xf0, 0x9f, 0x90, 0x92)
                Codepoint = '🐒' | ForEach-Object EnumerateRunes | ForEach-Object Value
            }
            # Import-Module Dev.Nin -Force

        }

        It 'DecodeMonkey' {
            $bStr = [byte[]]@(0xf0, 0x9f, 0x90, 0x92)
            testDecode -EncodingName 'utf-8' -InputBytes $bStr | Should -Be '🐒'
        }
    }

}