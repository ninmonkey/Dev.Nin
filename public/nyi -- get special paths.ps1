
function Get-SpecialEnv {
    [Environment+SpecialFolder] | Get-EnumInfo | ForEach-Object {
        [pscustomobject]@{
            Name = $_.Name
            [specialfold]
        }
    }

}

[Environment+SpecialFolder] | Get-EnumInfo | ForEach-Object …
Find-Type *special*folder*
Get-ParameterInfo -Parameter [Environment+SpecialFolder]
