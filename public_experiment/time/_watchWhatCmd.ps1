if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_watchWhoAmI'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}


function _watchWhoAmI {
    <#
    .synopsis
        show my command invokation info name if existing
    .description
        minimal funcs as vscode watch expression
    .example
        PS>
        $x = _watchWhoAmI -PassThru
        $x.MyInvoke | Select-Object PSScriptRoot, ScriptName, CommandOrigin, MyCommand | Format-List
        $x.MyInvoke.MyCommand | jProp | Sort-Object type
    #>
    [CmdletBinding()]
    param(
        [switch]$PassThru
    )

    # $PSCmdlet.MyInvocation.MyCommand.Name

    $my_invoke = ($PSCmdlet)?.MyInvocation
    $my_cmd = ($my_invoke)?.MyCommand
    $my_name = ($my_cmd)?.Name
    $finalName = $my_name ?? '[￼]'

    if (! $PassThru) {
        $finalName
        return
    }

    [pscustomobject]@{
        PSTypeName = 'devNin.whoAmIInfo'
        MyInvoke   = $PSCmdlet.MyInvocation
        # MyCmd = $
    }
}
