using namespace System.Collections.Generic

$experimentToExport.function += @(
    'iProp'
)
$experimentToExport.alias += @(
    'DevTool💻-iProp'
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
        future:
            - [ ] needs wider columns, 'ft' truncates even short ones.
            - [ ] move 'trimLonglines' to format-data
            - [ ] if object is a container, drop table header?
            - [ ] MemberInfo: <https://docs.microsoft.com/en-us/dotnet/api/system.reflection.methodinfo?view=net-5.0>

    .example
          🐒> gi . | iprop -IgnoreNull

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
    [Alias('DevTool💻-iProp')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Object to inspect
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object[]]$InputObject,

        # Only include matching names
        [Alias('IncludeProperty')]
        [Parameter()][string[]]$PropertyNamePattern,

        # Limit max inputs
        [Alias('MaxInputs')]
        [Parameter()]
        [int]$Limit = 3,

        # Limit using Get-Unique -OnType or position?
        [Alias('OnTypeName')]
        [Parameter()][switch]$UniqueOnType,

        # TruncateHuge
        [Parameter()][switch]$TrimLongLines,

        # filter null properties
        [Parameter()][switch]$IgnoreNull,

        # global max length of properies
        [Alias('MaxWidth', 'Width')]
        [Parameter()][uint]$MaxPropertyLength,

        #Exclude based on data type
        [parameter()]
        [string[]]$ExcludeType,

        # sort by
        [Parameter()]
        [ArgumentCompletions('TypeName', 'PropertyName')]
        [string]$SortBy



    )
    begin {
        $nullStr = "[`u{2400}]"
        Write-Debug @'
    Todo: - [ ] When 'Value' itself is a [type], then 'ValueStr' should 'Format-Typename' to summarize it
    - [ ]  _formatTypeHeaderSummary'
    - [ ] 'prop.ValueStr' should 'left align'
    - [ ] 'todo: _formatTypeHeaderSummary' | New-Text -fg yellow | ForEach-Object tostring | Write-Information
'@
        $InputList = [List[object]]::new()
        [hashtable]$SortByProp = @{
            'TypeName'     = @('TypeNameStr', 'Name')
            'PropertyName' = @('Name', 'TypeNameStr')
        }

    }
    process {

        $InputObject | ForEach-Object {
            $InputList.Add( $_ )
        }
    }

    end {
        $InputList.Count | Join-String -op 'Initial $InputList.count: ' | Write-Debug

        if ($UniqueOnType) {
            $filtered = $InputList | Get-Unique -OnType
            $filtered.Count | Join-String -op 'After filterby -OnType: $InputList.count: ' | Write-Debug
        }
        else {
            $filtered = $InputList
        }

        # filter counts before enumerating properties
        $filtered = $filtered | Select-Object -First $Limit

        $filtered
        | ForEach-Object {
            $curObject = $_
            # if it's a type itself
            # https://docs.microsoft.com/en-us/dotnet/api/System.Reflection.PropertyInfo?view=net-5.0#properties
            if ($curObject -is 'type') {
                Write-Error -ea stop 'Enumerate nonobject props'
                return
            }


            # if props exist
            <#
                .properties returns
                        type:System.Management.Automation.PSMemberInfoCollection`1
                        baseType: System.Management.Automation.PSMemberInfoIntegratingCollection`1

                    $_ is
                        type: [PSProperty]
                        pstypenames: [PSProperty], [PSPropertyInfo], [PSMemberInfo], [Object]
            #>
            $curObject.Psobject.Properties | ForEach-Object {
                $curProp = $_

                # filter nulls
                if ($IgnoreNull) {
                    if ($Null -eq $curProp.Value -or '' -eq $curProp.Value ) {
                        return
                    }
                    if ($curProp.TypeNameStr -match '[␀]' -or $curProp.ValueStr -match '[␀]') {
                        return
                    }
                }

                if ($PropertyNamePattern) {
                    'prop pattern NYI' | Write-Warning


                }
                $Type = ($curProp.value)?.GetType()
                $TypeNameStr = $Type | Format-TypeName -Brackets

                $ValueStr = ($curProp)?.Value ?? $nullStr
                $meta = @{
                    PSTypeName          = 'Nin.iProp'
                    OwnerTypeStr        = $curObject.GetType() | Format-TypeName -WithBrackets
                    OwnerPsTypeNamesStr = $curObject.PSTypeNames | ForEach-Object { $_ -as 'type' }
                    | Format-TypeName -Brackets | Sort-Object -Unique | Join-String -sep ', '
                    # the '-as type' is a quick hack to work around format-typename not working in an edge case. it needs to be rewritten anyway
                    PSTypeNamesStr      = $curProp.PSTypeNames | ForEach-Object { $_ -as 'type' } | Format-TypeName -Brackets | Sort-Object -Unique | Join-String -sep ', '
                    ValuePSTypeNames    = $curProp.'Value'.'pstypenames' | ForEach-Object { $_ -as 'type' } | Format-TypeName -Brackets | Sort-Object -Unique | Join-String -sep ', '
                    Name                = $curProp.Name
                    Value               = $curProp.Value
                    ValueStr            = $curProp.Value ?? $nullStr
                    ParentType          = $curObject.GetType()
                    Type                = $Type
                    TypeNameStr         = $typeNameStr ?? $nullStr
                    # TypeName     = $Type ?? $nullStr
                }
                [pscustomobject]$meta
            }
            # $Ij.psobject.properties | ForEach-Object { "`n"; ($_.value)?.GetType() | Format-TypeName -Brackets }
        } | Sort-Object -Property $SortByProp.$SortBy
        | Where-Object {
            $curProp = $_
            # step through debug filter logic
            $curProp.Name | Join-StringStyle Prefix 'filterByTypeName: ' | Write-Debug
            $curProp.Name | Prefix 'filterByTypeName: ' | Write-Debug


            # todo: validate this works
            if ($ExcludeType) {
                $ExcludeType | ForEach-Object {
                    $curExcludePattern = $_ # future: this could be a type instance too?
                    if ($curProp.Type.FullName -match $curExcludePattern) {
                        $false; return
                    }
                    if ($curProp.TypeNameStr -match $curExcludePattern) {
                        $false; return
                    }

                    $true
                }
            }
        }



    }
}

# ((gcm ls).Parameters).psobject.properties | ft

# iProp (Get-Command ls).Parameters -infa Continue -ov 'x'
# $x = iProp (Get-Command ls).Parameters -infa Continue
# $x
