BeforeAll {
    # . "$PSScriptRoot/Format-IndentText.ps1"
    Import-Module Dev.Nin -Force
}
Describe 'Format-IndentText' {
    Context 'Single Line' {        
        BeforeAll {
            $Prefix = '  '
            $Samples = @{
                Basic  = 'hi world'
                Basic2 = "hi world`n  with dent"
            }
            $Expected = @{
                Basic  = "${prefix}hi world" # ie: ('  ', $samples.Basic -join '')
                Basic2 = "${prefix}hi world`n${prefix}  with dent"
            }
        }

        It 'Depth 0' {
            '' | Format-IndentText -depth 0 | SHould -be ''
            'cat' | Format-IndentText -depth 0 | SHould -be 'cat' }
        It 'First' {
            $Samples.Basic | Format-IndentText -Depth 1
            | Should -be $Expected.Basic
        }

        It 'Basic' {
            $True | Should -Be $true
        }
        
    }
    Context 'Multiple Lines' {
        BeforeAll {
            $SampleComplicated = @'
Describe 'Format-IndentText' {
    Context 'Single Line' {        
        BeforeAll {
            $Prefix = '  '
            $Samples = @{
                Basic  = 'hi world'
                Basic2 = "hi world`n  with dent"
            }
            $Expected = @{
                Basic  = "${prefix}hi world" # ie: ('  ', $samples.Basic -join '')
                Basic2 = "${prefix}hi world`n${prefix}  with dent"
            }
        }
    }
}
'@
            $ExpectedComplicated = @'
    Describe 'Format-IndentText' {
        Context 'Single Line' {        
            BeforeAll {
                $Prefix = '  '
                $Samples = @{
                    Basic  = 'hi world'
                    Basic2 = "hi world`n  with dent"
                }
                $Expected = @{
                    Basic  = "${prefix}hi world" # ie: ('  ', $samples.Basic -join '')
                    Basic2 = "${prefix}hi world`n${prefix}  with dent"
                }
            }
        }
    }
'@            
        }

        It 'ComplicatedIndent' {
            $SampleComplicated | Format-IndentText -Depth 1 | Should -be $ExpectedComplicated

        }
    }
}