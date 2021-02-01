
# Warning: Moved to: <https://github.com/ninmonkey/Ninmonkey.Cheat-Sheets>

[Moved to: https://github.com/ninmonkey/Ninmonkey.Cheat-Sheets](https://github.com/ninmonkey/Ninmonkey.Cheat-Sheets)


# Windows paths and /w Env Vars

## Snippets:

### AutoExport Env Vars

```powershell
Get-ChildItem env: | select Key, value | ConvertTo-Json
```

### Get System 'ID' type info

```powershell
$PropList = 'CsCaption', 'CsDNSHostName', 'CsDomain', 'CsPrimaryOwnerName', 'LogonServer', 'Os*memory*', 'OsBootDevice', 'OsBuildNumber', 'OsCodeSet', 'OsType', 'OsVersion', 'WindowsBuild*', 'WindowsCurrentVersion', 'WindowsEditionId', 'WindowsProductName', 'WindowsRegisteredOwner', 'WindowsVersion'
Get-ComputerInfo | select -Property $PropList
```

## Users



## Misc.

| Name         | Path                                                                       |
| ------------ | -------------------------------------------------------------------------- |
| Taskbar Pins | `"%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"` |
| Quick Launch | `"%AppData%\Microsoft\Internet Explorer\Quick Launch"`                     |