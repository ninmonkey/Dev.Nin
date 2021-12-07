$experimentToExport.function += @(
    _watchWhoAmI
)
$experimentToExport.alias += @(
    # 'All' # breaks pester
    # 'Any'
)

function _watchWhoAmI {
    <#
    .synopsis
        show my command invokation info name if existing
    .description
        minimal funcs as vscode watch expression
    #>

    # $PSCmdlet.MyInvocation.MyCommand.Name

    $my_invoke = ($PSCmdlet)?.MyInvocation
    $my_cmd = ($my_invoke)?.MyCommand
    $my_name = ($my_cmd)?.Name ?? '[￼]'
    $my_name

}
