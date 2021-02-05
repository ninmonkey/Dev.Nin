function Dev-GetPropSelected {
    [Alias('_propListFzf')]
    <#
    .notes
        todo: validate changes with: 'Test-Json -Schema foo'
    #>
    param (
        # List Name
        [Parameter(Mandatory, Position = 0)]
        [String]$ListName

        # # Value
        # [Parameter(Mandatory, Position = 1)]
        # [object]$ParameterName
    )

    # $_SavedListMetadata
    # throw "nyi: Add-SavedList"
}

# if ($true) {
#     $source = Get-ChildItem . | Select-Object -First 1
#     # $selected = $Null
#     if ($true) {
#         # if (! $selected ) {
#         $propList = $source | ForEach-Object { $_.psobject.properties.name }
#         $selected = $propList | Out-Fzf -MultiSelect
#         $selected -join ', '
#     }

#     $source | Select-Object -prop $selected

#     H1 'show selected'
#     foreach ($p in $selected) {
#         $maybeValue = $source.$p ?? ( "`u{0}" | Format-ControlChar )
#         $valIsNull = $null -eq $maybeValue

#         [pscustomobject]@{
#             Name  = $P
#             Value = $maybeValue
#             Type  = ($valIsNull) ? $valIsNull : $maybeValue.GetType().FullName
#         }
#         hr
#     }
# }