
function Dev-GetNameFrom {
    [Alias('nameFrom')]
    <#
    .synopsis
        find the required imports for a list of type names
    .description
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

        $joinStringSplat = @{
            Separator    = ";`n$prefix"
            OutputPrefix = $prefix
        }

        $TypeNames | ForEach-Object {
            $typeList = Find-Type $_
            $typeList

            $typeList | Label 'Types' | Write-Debug
        } | ForEach-Object Namespace
        # | Where-Object { ! [string]::IsNullOrWhiteSpace( $_ ) }
        | Sort-Object -Unique #-ov sorted
        | Join-String @joinStringSplat

        # wasn't copying everything
        # $sorted | Join-String -sep "`n" | Set-Clipboard

    }
}

# 'string', 'list' | nameFrom -Debug