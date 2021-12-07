# BeforeAll {
#     Import-Module Dev.Nin -Force -wa ignore
# }


# Describe 'temp_cur_test.tests.ps1' -Tag 'ANSI', 'Console' {
#     It 'test-write-host' {
#         ($PSVersionTable -as 'hashtable' ).GetEnumerator() | ForEach-Object {
#             #$_.key, $_.Value
#             $_.Value | Write-Color 'pink'
#             hr
#             $_.key | Write-Color 'seagreen2'
#             hr
#         } | Write-Host
#         Set-ItResult -Skipped -Because 'Ansi output'

#     }

#     # It 'stdout?' {
#     #  ($PSVersionTable -as 'hashtable' ).GetEnumerator() | ForEach-Object {
#     #         #$_.key, $_.Value
#     #         $_.Value | write-color 'pink'
#     #         hr
#     #         $_.key | write-color 'seagreen2'
#     #         # hr | Out-Host
#     #     }
#     #     hr | Write-Host -ForegroundColor red
#     # }
# }
