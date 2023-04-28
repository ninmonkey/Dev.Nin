- [custom completer attributes summary](#custom-completer-attributes-summary)
- [custom attributes summary](#custom-attributes-summary)
- [expanded, if needed](#expanded-if-needed)
  - [`[ninColorTransformationAttr()]`](#nincolortransformationattr)
  - [`[LogEntry]`](#logentry)
  - [`[EnsureFilepathExists]`](#ensurefilepathexists)

# custom completer attributes summary

    - tab complete RGB or Color names

# custom attributes summary

- [ ] `[ninColorTransformationAttr()]
- [ ] `[ninColorCompleter()]
- [ ]  records entry/exits of a `CmdLet`
- [ ] `[EnsureFilepathExists()]`
- [ ]  `[LogEntry]` or `[LogInvoke]` is better semantics
  - any reason that woulud differ from  `[ResolvedPath()]` ?
  - yes. Ensure creates the files. They could be merged like: 
  - `[EnsureFilepathExists( ItemType = 'file', CreateIfMissing )] $File`


# expanded, if needed

## `[ninColorTransformationAttr()]`

```ps1

[ninColorTransformation( ResolveOrder = PSStyle, Panses.Rgb  )]
$Color
```

- `ColorSpace` = ResolveOrder { RGB ,  CIEL ,  HSL } 
- `AllowedInputTypes` = { Rgbcolor, RGB_text, HSL_text, colorName_text, any? }
- `ResolveOrder` = Coercion type order ( or maybe the type does that part )
```ps1
ResolveOrder = { ColorNin, Pansies, PSStyle, Plaintext?, Any? }
```


## `[LogEntry]`

attribute logs when you

```
fn: FindColor ==> enter 
    when = [dt]

    fn: FindColor.InternalMethod ==> enter 
        when = [dt]

    fn: FindColor.InternalMethod <== exit

fn: FindColor <== exit
    when = [dt], duration = [delta]

```
```log
CmdletName ==> enter "2022-04-18T18:03:36.3733058-05:00",guid,parent
CmdletName <== exit "2022-04-16T18:03:36.3733058-05:00",guid,duration
```

## `[EnsureFilepathExists]`

```ps1
[EnsureFilepathExists( ItemType = 'file' )] $Path
[EnsureFilepathExists( ItemType = 'directory' )] $Path 
[EnsureFilepathExists( ItemType = 'both' | 'any' )] $FileInfo
[EnsureFilepathExists( ItemType = 'file', CreateIfMissing )] $File

# make it pwsh-onic? 
[EnsureItemExists( ItemType = 'file', CreateIfMissing )]
```

- CreateIfMissing: bool
  - creates folder[s] if missing
  - creates empty file if missing

