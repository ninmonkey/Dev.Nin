
# if ($false) {
#     if (! $experimentToExport) {
#         h1 'module'
#         # ...


#         h1 'modulus determines breaks'
#         0..99 | ForEach-Object { $i = 0 } {
#             $i++
#             $paint = '▆' * 3 -join ''
#             if ($i % 10 -eq 0) {
#                 $paint += "`n"
#             }
#             $Paint | Join-String -sep '' | Write-Color -fg "gray${_}"

#         } | str str ' '

#         $items = 0..99 | ForEach-Object { $i = 0 } {
#             $paint = '▆' * 3 -join ''
#             $Paint | Join-String -sep '' | Write-Color -fg "gray${_}"

#         }
#         $Items
#         $items.count
#         Write-Warning 'todo: use explicitly set RGB values'

#         hr
#         h1 'Using Group-Object'
#         0..10 | Group-ObjectByCount -Count 3

#         h1 'to->json'
#         0..10 | Group-ObjectByCount -Count 3 | ConvertTo-Json

#         h1 'Join-String'
#         0..10 | Group-ObjectByCount -Count 5 | ForEach-Object {
#             $_ | Join-String -sep ', ' -op 'Group: '
#         }

#         h1 'inner to->json'
#         0..10 | Group-ObjectByCount -Count 5 | ForEach-Object {
#             $_ | ConvertTo-Json
#         }
#     }
# }
