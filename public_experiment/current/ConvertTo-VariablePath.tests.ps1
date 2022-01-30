BeforeAll {
    Import-Module Dev.Nin -Force
    # $ErrorActionPreference = 'break'
}

Describe 'ConvertTo-VariablePath' {
    BeforeAll {
    }
    It 'UserProfile' {
        $Sample = 'C:\Users\cppmo_000\Documents\2021'
        $Expected = '$Env:UserProfile\Documents\2021'

        $Sample | ConvertTo-VariablePath -Debug
        | Should -Be $Expected
    }

    It 'RandomInput' {
        { 'sfa3vqfsdf23' | ConvertTo-VariablePath -ea stop }
        | Should -Throw -Because 'Invalid Path'
    }

    Describe 'Static Paths' {
        BeforeAll {
            [object[]]$samples ??= Get-Item "$Env:USERPROFILE"
            $samples += Get-Item $Env:LOCALAPPDATA
            $samples += Get-Item ~
        }
        It 'UserProfile <as item>' {
            Get-Item $Env:UserProfile
            | To->VariablePath
            | Should -Be '$Env:UserProfile'
        }
        It 'UserProfile <as text>' {
            Get-Item $Env:USERPROFILE
            | ForEach-Object tostring
            | To->VariablePath
            | Should -Be '$Env:UserProfile'
        }
    }

    It '"<LiteralPath>" Returns "<Expected>"' -ForEach @(
        @{
            LiteralPath = "$Env:UserProfile\Users\cppmo_000\AppData\Roaming"
            Expected    = '$Env:APPDATA'
        }
        @{
            LiteralPath = 'C:\Users\cppmo_000\Documents\2021'
            Expected    = '$Env:UserProfile\Documents\2021'
        }
    ) {
        $LiteralPath | ConvertTo-VariablePath | Should -Be $Expected
        # . $__PesterFunctionName $LiteralPath | Should -Be $Expected
    }


}
