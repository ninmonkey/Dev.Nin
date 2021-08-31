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

    .example
        # manual example
        PS> $someDir.GetType() | Format-TypeName
            $maxLen = 80
            $someDir | iProp | sort name
            | ?{ $_.valueStr.tostring().length -lt $maxLen } | Ft -AutoSize

        [IO.DirectoryInfo]

        TypeNameStr         Name             ValueStr
        -----------         ----             --------
        [Boolean]           _isNormalized    True
        [String]            _name            buffer
        [IO.FileAttributes] Attributes       Directory
        [String]            BaseName         buffer
        [DateTime]          CreationTime     1/15/2021 11:27:54 AM
        [DateTimeOffset]    CreationTimeCore 1/15/2021 11:27:54 AM -06:00
        [DateTime]          CreationTimeUtc  1/15/2021 5:27:54 PM
        [Boolean]           Exists           True
        [Boolean]           ExistsCore       True

    .outputs
          [nin.iProp]

    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Object to inspect
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # TruncateHuge
        [Parameter()][switch]$TrimLongLines,

        # global max length of properies
        [Alias('MaxWidth', 'Width')]
        [Parameter()][uint]$MaxPropertyLength

    )
    begin {
        $nullStr = "[`u{2400}]"
        Write-Warning @'
    Todo: - [ ] When 'Value' itself is a [type], then 'ValueStr' should 'Format-Typename' to summarize it
    - [ ]  _formatTypeHeaderSummary'
    - [ ] 'prop.ValueStr' should 'left align'
'@


    }
    process {
        'todo: _formatTypeHeaderSummary' | New-Text -fg yellow | ForEach-Object tostring | Write-Information

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
