function __collectVSCodeLogs {
    param(
        $Query = 'devel'
    )
    $DestRoot = Get-Item "$Env:UserProfile\SkyDrive\2022-fam-share\logs\bug-report-vscode\auto-collect"
    $SourceRoot = Get-Item "$Env:AppData\Code\logs"
    $files = rg $query --files-with-matches | StripAnsi | Get-Item
    #$wroteLogs ??= [list[object]]::new()
    $files | ForEach-Object {
        $NewName = $_.FullName -replace (ReLit "$Env:AppData\Code\logs\"), '' -replace '\\', '⁞' -replace ' ', '_'
        $Dest = Join-Path $DestRoot $NewName
        Get-Content $_
        | Set-Content -Path $Dest
        "wrote: '$Dest'"
        #  $wroteLogs.Add( (gi $Dest))
        #  $wroteLogs = $wroteLogs | Sort -Unique

    }
    Get-ChildItem $DestRoot | Sort-Object lastWriteTIme
}

# Export-ModuleMember -Function '__collectVSCodeLogs'
