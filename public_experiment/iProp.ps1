$experimentToExport.function += @(
    'iProp'
)
$experimentToExport.alias += @(
    # 'GetFuncInfo'
)

$experimentToExport.update_typeDataScriptBlock += @(
    {
        Update-TypeData -TypeName 'Nin.iProp' -DefaultDisplayPropertySet 'TypeNameStr', 'Name', 'ValueStr' -Force
    }
)

function iProp {
    <#
    .synopsis
        summary type test
    .description
        .
    .notes
        - [ ] needs wider columns, 'ft' truncates even short ones.
        - [ ] move 'trimLonglines' to format-data
        - [ ] if object is a container, drop table header?
    .example
          🐒> ls . | iProp | ? ValueStr -Match "`u{2400}"

            Name     TypeNameStr ValueStr
            ----     ----------- --------
            Target   [␀]         [␀]
            LinkType [␀]         [␀]
            Target   [␀]         [␀]
            LinkType [␀]         [␀]

            🐒> ls . | iProp | ?{ $null -eq $_.Value } | ft *

             PSTypeNamesStr                                               TypeNameStr Value Name     ValueStr
             --------------                                               ----------- ----- ----     --------
            [Object], [PSCodeProperty], [PSMemberInfo], [PSPropertyInfo] [␀]               Target   [␀]
            [Object], [PSCodeProperty], [PSMemberInfo], [PSPropertyInfo] [␀]               LinkType [␀]


    .outputs
          [string]

    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Object to inspect
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # TruncateHuge
        [Parameter()][switch]$TrimLongLines
    )
    begin {
        $nullStr = "[`u{2400}]"



    }
    process {

        Write-Information
        $InputObject.Psobject.Properties | ForEach-Object {
            $curProp = $_
            $Type = ($curProp.value)?.GetType()
            $TypeNameStr = $Type | Format-TypeName -Brackets

            $ValueStr = ($curProp)?.Value ?? $nullStr
            $meta = @{
                PSTypeName          = 'Nin.iProp'
                OwnerTypeStr        = $inputObject.GetType() | Format-TypeName -WithBrackets
                OwnerPsTypeNamesStr = $inputObject.PSTypeNames | ForEach-Object { $_ -as 'type' }
                | Format-TypeName -Brackets | Sort-Object -Unique | Join-String -sep ', '
                # the '-as type' is a quick hack to work around format-typename not working in an edge case. it needs to be rewritten anyway
                PSTypeNamesStr      = $curProp.PSTypeNames | ForEach-Object { $_ -as 'type' } | Format-TypeName -Brackets | Sort-Object -Unique | Join-String -sep ', '
                ValuePSTypeNames    = $curProp.'Value'.'pstypenames' | ForEach-Object { $_ -as 'type' } | Format-TypeName -Brackets | Sort-Object -Unique | Join-String -sep ', '
                Name                = $curProp.Name
                Value               = $curProp.Value
                ValueStr            = $curProp.Value ?? $nullStr
                Type                = $Type
                TypeNameStr         = $typeNameStr ?? $nullStr
                # TypeName     = $Type ?? $nullStr
            }

            $maxWidth = 60
            if ($TrimLongLines ) {
                $SamStr = 'a fjea eifjj'

                $SamStr.SubString(0, (  [math]::Min( 60, $SamStr.Length - 1) ))
                $Meta.'ValueStr' = ($meta.'ValueStr'.ToString()).Substring(0, $maxWidth)
                # $meta.Value = $meta.Value.ToString()[0..$maxWidth] -join '' # this might break unicode
                # $meta.ValueStr = $meta.ValueStr.ToString()[0..$maxWidth] -join '' # this might break unicode
                # $meta.Type = $meta.Type.ToString()[0..$maxWidth] -join '' # this might break unicode
                # $meta.TypeStr = $meta.TypeStr.ToString()[0..$maxWidth] -join '' # this might break unicode
            }
            [pscustomobject]$meta


        }
        # $Ij.psobject.properties | ForEach-Object { "`n"; ($_.value)?.GetType() | Format-TypeName -Brackets }

    }
    end {

    }
}

# ((gcm ls).Parameters).psobject.properties | ft

# iProp (Get-Command ls).Parameters -infa Continue -ov 'x'
# $x = iProp (Get-Command ls).Parameters -infa Continue
# $x
