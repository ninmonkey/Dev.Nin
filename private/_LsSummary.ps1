

function LsSummary {
    [Alias('Lsd2')]
    [cmdletbinding(PositionalBinding = $false)]
    param(
        [parameter(Position = 0, ValueFromPipeline)]
        [string]$Path = '.',

        [parameter()]
        [switch]$NoForce


    )
    begin {
        $splat_lsDir = @{
            Force     = ! $NoForce
            Directory = $true
            Path      = $Path
        }
        $splat_sortDir = @{
            Property   = 'LastWriteTime'
            Descending = $true
        }
        $Indent = '  '
    }


    process {
        # $first = ls @splat_ls  -P $Path
        # | Sort-Object LastWriteTime -Descending

        $Parents = Get-ChildItem @splat_lsDir -Depth 0
        | Sort-Object @splat_sortDir -Descending

        $Parents | ForEach-Object {
            $curParent = $_

            # $Sub = Get-ChildItem -Path $curParent -Directory
            $Sub = Get-ChildItem @splat_lsDir -Depth 0 -Path $curParent
            | Sort-Object @splat_sortDir -Descending
            | Select-Object -First 5
            | Join-String -sep ' ' -op "`n  $Indent" { "/$($_.Name)" }

            #  📁 📂
            $final = @(
                "`n$Indent"
                " $($Sub.Count) 📁 1 💾 22   "
                $curParent.Name | New-Text -fg green
                $Sub
                "`n"
            ) -join ''
            $Final

            # $final

        }

    }
}

Lsd2 '../..'
