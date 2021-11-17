#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'cmdToFilepath'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}


function cmdToFilepath {
    <#
    .synopsis
        a quick convert: commandName to filepath, with without extra logic
    .example
        🐒> cmdToFilepath editfunc

        C:\Users\nin\powershell\...public\Edit-FunctionSource.ps1
    .link
        Dev.Nin\Resolve-CommandName
    #>
    param(
        [parameter(Mandatory, Position = 0 , ValueFromPipeline)]
        $FunctionName
    )
    process {
        Get-Command $FunctionName | editfunc -PassThru | ForEach-Object file
    }
}

if (! $experimentToExport) {
    # ...
}
