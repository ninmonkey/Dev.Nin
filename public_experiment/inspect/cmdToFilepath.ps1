#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'cmdToFilepath'
    )
    $experimentToExport.alias += @(

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
        # names as text/gcm/whatever
        # [Alias('FunctionPathName')]
        [AllowNull()]
        [AllowEmptyString()]
        [parameter(Mandatory, Position = 0 , ValueFromPipeline)]
        $InputObject
    )
    process {
        if ($Null -eq $inputScript) {
            return
        }
        $CleanNames = $InputObject | Remove-AnsiEscape
        Get-Command $CleanNames | editfunc -PassThru -ea continue | ForEach-Object file
    }
}

if (! $experimentToExport) {
    # ...
    '/w rescmd'
    Get-Command *fzf* -m (_enumerateMyModule)
    | rescmd -QualifiedName

    h1 '/w cmdToFilepath'
    Get-Command *fzf* -m (_enumerateMyModule)
    | cmdToFilepath
}
