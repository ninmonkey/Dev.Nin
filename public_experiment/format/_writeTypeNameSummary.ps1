#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'F'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

if (! $badInlineDebug) {
    $experimentToExport.function += @(
        '_write-TypeNameSummary'
    )
}
# $experimentToExport.alias += @(
#     # 'GetFuncInfo'
# )

# $experimentToExport.update_typeDataScriptBlock += @(
#     {
#         Update-TypeData -TypeName 'Nin.iProp' -DefaultDisplayPropertySet 'TypeNameStr', 'Name', 'ValueStr' -Force
#     }
# )

function _write-TypeNameSummary {
    <#
    .synopsis
        output type summary as text (future: as type)
    .notes
        todo: try: <https://github.com/SeeminglyScience/ClassExplorer/blob/c63507299527ceb85fe2893771bf98ed7d47ea26/src/ClassExplorer/SignatureWriter.cs#L478-L513>
    .description
        .uses nullstring symbol

    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Object to inspect
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )
    begin {
        [hashtable]$Template = @{}
        $Template['Parent'] = @'
## Parent
Type        = {0}
PSTypeNames = {1}
'@

        $Template['Child'] = @'
FirstChild  = {1}
ChildTypes  = {0}
'@

        $nullStr = "[`u{2400}]"

    }

    process {
        $one = $InputObject
        $meta.ParentType = $one.GetType() | ?NotBlank
        | Format-TypeName -Brackets

        $meta.ParentTypeNames = $one.pstypenames | ForEach-Object { $_ -as 'type' }
        | Sort-Object | ?NotBlank
        | Format-TypeName -Brackets


        Write-Verbose 'this test should not fail, if it does, fix this code'
        $meta.Parent_Count = $one.count ?? $nullStr
        $meta.Parent_Length = $one.length ?? $nullStr
        $meta.FirstChild_Type = @($one)[0]?.GetType() | ?NotBlank
        | Format-TypeName -Brackets -NullStr
        $meta.FirstChild_Type = @($one)[0]?.PSTypeNames | ?NotBlank
        | Format-TypeName -Brackets -NullStr

        [pscustomobject]$meta

        return
        if ($false) {
            @($one)[0]?.GetType() | Format-TypeName -Brackets

            $curChild = @($one)?[0]


            $meta.FirstChildType = $one.GetType() | Format-TypeName -Brackets

            $meta.FirstChildTypeNames = $one.pstypenames | ForEach-Object { $_ -as 'type' }
            | Sort-Object | Format-TypeName -Brackets

            # $template.Parent -f @(
            $InputObject.GetType() | Format-TypeName -Brackets

            $curProp.PSTypeNames | ForEach-Object { $_ -as 'type' }
            | Format-TypeName -Brackets | Sort-Object -Unique | Join-String -sep ', '
        }
        # )

        # $childOut = foreach($x in $InputObject) {
        #         $x.GetType() | Format-TypeName -Brackets

        #     }

        #     $curProp.PSTypeNames | ForEach-Object { $_ -as 'type' }
        #     | Format-TypeName -Brackets | Sort-Object -Unique | Join-String -sep ', '


    }
}


if (! $experimentToExport) {
    # $null | Format-typename
    $now = Get-Date
    'first try: $now | _writeTypeNameSummary'
    $now | _write-TypeNameSummary
    'first try: _writeTypeNameSummary $now'
}


# ...
