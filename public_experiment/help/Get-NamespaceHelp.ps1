#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Get-NamespaceHelp'
    )
    $experimentToExport.alias += @(
        'Help->Namespace'
    )
}

function Get-NamespaceHelp {
    [alias('Help->Namespace')]
    param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [string]$Namespace = 'system',

        [Parameter()][int]$RelativeDepth = 2
    )

    # $namespace = 'system.management.automation'
    function _renderName {
        [string]$Item
        if ($NoColor) {
            ($Item)?.Name ?? $Item
            return
        }
        $Item.Name
    }
    @(

        $namespace | ForEach-Object { $_ -replace '^system\.', '' }
        | str ul
        Find-Type -Namespace $Namespace | ForEach-Object {

            # _renderName $_.Name
            @(

                '{1} {2}[ {0} ]' -f @(
                    ($_.BaseType ?? '') -replace '^System\.'
                    $_.Name
                    Write-Color -fg gray50 -LeaveColor -Text ''
                )
                "${fg:clear}"
                # $_.DeclaringType
            ) | str nl 0
        }
        | str ul -sort -Unique | Format-IndentText -Depth $RelativeDepth
    ) | str nl 0
}

if (! $experimentToExport) {
    # ...
    Help->Namespace system
    Help->Namespace system.text
}
function _disabled__refactor-Get-NamespaceHelp {
    <#
    .synopsis
        quickly dump files in namespace, with some formatting

    #>
    [alias('Help->Namespace')]
    param(
        [Alias('Name')]
        [Parameter(Position = 0, ValueFromPipeline)]
        [string]$Namespace = 'system',

        [Parameter()][int]$RelativeDepth = 2,

        [Parameter()][switch]$NoColor
    )

    # $namespace = 'system.management.automation'
    function _renderName {
        [string]$Item
        if ($NoColor) {
            $Item.Name; return
        }
        $Item.Name
    }

    @(

        $namespace | ForEach-Object { $_ -replace '^system\.', '' }
        | str ul

        Find-Type -Namespace $Namespace | ForEach-Object { _renderName -name $_ }
        | str ul -sort -Unique | Format-IndentText -Depth $RelativeDepth
    ) | str nl 0
}

