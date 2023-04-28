
$experimentToExport.function += @(
    'Show-CommandUsed'
)
$experimentToExport.alias += @(
    'ShowCmdsUsed'
)


function Show-CommandUsed {
    <#
    .synopsis
        summarize commands, used for gifs
    .description
        jumps to module's source, or its directory
    .notes
        future: search last N commands in history, parse AST for command names
    .link
        Dev.Nin\Show-CommandUsed
    .outputs
        [string] or none
    .example
    🐒> Show-CommandUsed 'ls', 'fm', 'gm', 'goto'

        Name CommandName
        ---- -----------
        fm   ClassExplorer\Find-Member
        ls   Microsoft.PowerShell.Management\Get-ChildItem
        gm   Microsoft.PowerShell.Utility\Get-Member
        goto Ninmonkey.Console\Set-NinLocation


    #>
    [Alias('ShowCmdsUsed')]
    [cmdletbinding()]
    param(
        # commands as a list
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string[]]$CommandName
    )
    begin {
        $nameList = [list[string]]::new()
    }
    process {
        $CommandName | ForEach-Object {
            $nameList.Add( $_ )
        }
        Write-Warning @'
todo
- [ ] use AST of prev command to find all types
- [ ] then filter as mine or not

'@
    }
    end {


        $result = $nameList | ForEach-Object {
            $curName = $_
            $meta = [ordered]@{
                PSTypeName  = 'nin.CommandMappingInfo'
                Name        = $curName
                CommandName = $curName | Resolve-CommandName -QualifiedName
            }
            [pscustomobject]$meta
        }

        $result | Sort-Object CommandName
    }

}
