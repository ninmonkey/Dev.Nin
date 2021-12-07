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
    #>
    param()

    # $PSCmdlet.MyInvocation.MyCommand.Name

    $my_invoke = ($PSCmdlet)?.MyInvocation
    $my_cmd = ($my_invoke)?.MyCommand
    $my_name = ($my_cmd)?.Name


    $finalName = $my_name ?? '[￼]'
    $finalName

}


if (! $experimentToExport) {
    # ...
}
