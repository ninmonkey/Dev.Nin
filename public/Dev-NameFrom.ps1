
function nameFrom {
    <#
    .synopsis
        temporary function to get full namespaces (to add missing imports in dev)
        saves to clipboard
    #>
    param (
        [Parameter(
            Mandatory, ValueFromPipeline,
            HelpMessage = 'List of type .Name''s')]
        [string[]]$TypeNames

        # 'ienumerable', 'commandast' | ForEach-Object {
        #     Find-Type   $_
        # } | ForEach-Object Namespace | Sort-Object |Set-Clipboard
    )

    process {
        $prefix = 'using namespace '
        $TypeNames | ForEach-Object {
            Find-Type $_
        } | ForEach-Object Namespace | Sort-Object -Unique -ov sorted
        | Join-String -Separator "`n$prefix" -OutputPrefix $prefix

        # wasn't copying everything
        # $sorted | Join-String -sep "`n" | Set-Clipboard

    }
}
