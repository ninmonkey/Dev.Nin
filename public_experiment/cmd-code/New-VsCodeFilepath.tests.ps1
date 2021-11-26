BeforeAll {
    Import-Module dev.nin -Force

    # actual use: --goto <file:line[:character]>


}

Describe 'New-VsCodeFilepath' {
    BeforeAll {
        $t1 = 'file.json', 20, 30
        $SomeScript = Get-ChildItem . -File *.ps1 | Select-Object -First 1
        $Samples = @{}
        $Samples.Valid = @(
            'ormat_color.ps1:3:1',
            'ormat_color.ps1:33245:133',
            'foobar.ps1:3:5',
            'c:\foo  a\foobar.ps1:3',
            'c:\foo  a\foobar.ps1',
            'bar.t',
            'foo:3',
            '3:fo.ps:3:1'
        ) | Sort -Unique | %{
            @{ SamplePath = $_ ; Expected = $True}
        }
        $Samples.Invalid = @(
            'c:\foo  \foobar.ps1:a:3:',
            'c:\foo  \foobar.ps1:3:',
            'c:\foo  \foobar.ps1:',
            'bar:4:6:',
            'bar:4: 6',
            'bar:4:6:',
            ':2:3:'
        )| Sort -Unique | %{
            @{ SamplePath = $_ ; Expected = $False}
        }


        # 10 / 0

        <#
        Possible input types;


            gi .\Invoke-BuildGenerateAll.ps1 | % gettype | Fullname
            [System.IO.FileInfo]
        #>
    }
    It '"<SamplePath>" Returns "<expected>"' -ForEach @(
        $samples.Valid
    ) {
            # #     $Samples.valid.'SamplePath' | ForEach-Object {
            # # $_ | Write-Color pink
            # $_ -match $re | Should -Be $True

}
        # New-VSCodeFilepath -SamplePath $SamplePath | Should -Be $Expected
    }

    }
}