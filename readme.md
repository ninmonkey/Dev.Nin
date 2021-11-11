# Dev.Nin

## Commands to try


```ps1
$gcmCache ??= Get-Command * -m (_enumerateMyModule)
@(
    '*peek*'
    '*type*'
    , @('*iter*prop*', '*prop*', '*iter*')
    , @('iterProp', 'What-ParameterInfo', 'What-Param'   )
)
| ForEach-Object { 
    $gcmCache
    | resCmd -QualifiedName -IncludeAlias
    | len
}
gcm to* -m (_enumerateMyModule)
```

```ps1
🐒> MyGcm🐒 *from* -PassThru | ft -AutoSize


CommandType Name                     Version Source
----------- ----                     ------- ------
Function    ConvertFrom-GistList     0.0.8   Dev.Nin
Function    ConvertFrom-LiteralPath  0.0.8   Dev.Nin
Function    ConvertFrom-ScriptExtent 0.0.8   Dev.Nin
Function    Dev-GetNameFrom          0.0.8   Dev.Nin
Function    Get-DownloadFromGit      0.0.8   Dev.Nin
```
