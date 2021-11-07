BeforeAll {
    Import-Module Dev.Nin -Force
}

Describe 'What-TypeInfo' {
    It 'first' -Tag 'visual' {
        # $ErrorActionPreference = 'break'
        @(
            $res = What-TypeInfo (Get-Item . ) -infa Continue    
            $res | Format-List 
            hr
            $sample = ((Get-Command ls).Parameters)
            $tinfo = $sample.GetType()
            $tinfo | HelpFromType -PassThru
            $tinfo.Namespace, $tinfo.name -join '.'

            What-TypeInfo $tinfo | Format-List *
            What-TypeInfo $sample | Format-List *
        ) | Write-Host
        $true | Should -Be $true
    }
    AfterAll {
        $ErrorActionPreference = 'continue'
    }
}