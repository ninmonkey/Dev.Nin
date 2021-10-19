BeforeAll {
    Import-Module Dev.Nin -Force -wa ignore
}


Describe 'temp_cur_test.tests.ps1' {
    It 'test-write-host' {
        @(
                ($PSVersionTable -as 'hashtable' ).GetEnumerator() | ForEach-Object {
                #$_.key, $_.Value
                $_.Value | write-color 'pink'
                hr
                $_.key | write-color 'seagreen2'
                hr
            }
            hr) | Write-Host

    }

    # It 'stdout?' {
    #  ($PSVersionTable -as 'hashtable' ).GetEnumerator() | ForEach-Object {
    #         #$_.key, $_.Value
    #         $_.Value | write-color 'pink'
    #         hr
    #         $_.key | write-color 'seagreen2'
    #         # hr | Out-Host
    #     }
    #     hr | Write-Host -ForegroundColor red
    # }
}