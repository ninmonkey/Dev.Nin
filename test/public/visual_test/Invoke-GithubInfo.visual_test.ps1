Import-Module dev.nin -Force
# if ($false) {


return
# }
# if (! $CacheFileList) {
#     [hashtable]$CacheFileList = @{}
#     # $CacheFileList = @{}
#     Get-ChildItem -Path 'C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin' '*.ps1' -Recurse | ForEach-Object {
#         $Meta = @{
#             FullName      = $_.FullName
#             LastWriteTime = $_.LastWriteTime
#         }
#         $f = [pscustomobject]$Meta
#         $CacheFileList[$f.FullName] = $f
#     }
# }

# $__cacheReset = $__cacheReset ?? $true
# function stale {
#     $script:__cacheReset = $true
# }

# if ($__cacheReset) {
#     Import-Module dev.nin -Force
#     $__cacheReset = $false
# }

Invoke-InspectGithubRepo -OwnerName 'dfinke'
