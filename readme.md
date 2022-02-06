# Dev.Nin

<!-- reference: bat's header 
<p align="center">
  <img src="doc/logo-header.svg" alt="bat - a cat clone with wings"><br>
  <a href="https://github.com/sharkdp/bat/actions?query=workflow%3ACICD"><img src="https://github.com/sharkdp/bat/workflows/CICD/badge.svg" alt="Build Status"></a>
  <img src="https://img.shields.io/crates/l/bat.svg" alt="license">
  <a href="https://crates.io/crates/bat"><img src="https://img.shields.io/crates/v/bat.svg?colorB=319e8c" alt="Version info"></a><br>
  A <i>cat(1)</i> clone with syntax highlighting and Git integration.
</p>

<p align="center">
  <a href="#syntax-highlighting">Key Features</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="#installation">Installation</a> •
  <a href="#customization">Customization</a> •
  <a href="#project-goals-and-alternatives">Project goals, alternatives</a><br>
  [English]
  [<a href="doc/README-zh.md">中文</a>]
  [<a href="doc/README-ja.md">日本語</a>]
  [<a href="doc/README-ko.md">한국어</a>]
  [<a href="doc/README-ru.md">Русский</a>]
</p>
-->

### Commands to try


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

## Code style/rules

### Splatting Kwargs

Functions accept arbitrary `hashtable` args as `-Options`
Internal code always uses `$Config` - except on the initial `Update-Hashtable`
This has the side effect of making use of new arguments without needing to modify code.

This is useful on something as experimental as this library. 

summary:

- Internal state/config uses `$Config`
- Functions accept a `[hashtable]$Options`
- Internally uses a `[hashtable]$Config`
- You `Update/Join-Hashtable`, so you never reference `$Options` in the body. Always use `$Config`
- `$Options` hashtable has a special key named `Color`


### Custom Verbs

Normally you want to align with the standard verbs. For personal profile, you can bend the rules and experiment

| Name                                                                                                                                                 | Desc                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| Term Name: `Completions`<br/>function: `Get-FooCompletionsName()`<br/>    like `Get-PropertyNameCompletionsName()`<br/>alias: `Completions->FooName` | List of valid values, Not a custom completer function.<br/>more similar to: `[ArgumentCompletions]` |


**Summary**

    Find->          [ Get-<noun>Item ]
        search for items,
    Filter->        [ where-<condition> ]
        remove using conditions,
        pipe already exists

    Peek->
        (is bat using preview mode)

        acts on the end of input, then may
        [1] quit without any return value, or
        [2] choose items in 'fzf' while previewing using peek
            ( it's 'fzf -m' with preview on)

### Document Current Verbs

```ps1
gcm -Module (_enumerateMyModule)  | % verb | sort -Unique
```