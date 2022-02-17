#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Get-JObjectProperty'
    )
    $experimentToExport.alias += @(
        'jProp' # 'Get-JObjectProperty'
    )
}

function Get-JObjectProperty {
    <#
    .synopsis
        quickly view property values, and types on an object
    .example
        ls . | select -first 1 | PropList
    .example
        ls . | select -first 1 | PropList | ft Type, TypeOfValue, Name, Value
    .notes
        future:
            - [ ] normal props
                render dark

        very soon, pull advanced functionality to Get-NinOBject
        more broad, reusable, simple logic here

            - [ ] formating.ps1xml
            - [ ] automatically filter by " | Get-Unique -OnType"
            - [ ] left--align "value" column
            - [ ] max widths on columns

        # future: argument completions to control talbe order
            <#
            $Props = 'Name', 'Value', 'Type', 'TypeOfValue'



    to align column:
    - <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_format.ps1xml?view=powershell-7.1>
    - <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_types.ps1xml?view=powershell-7.1>

    #>
    [Alias('jProp')]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject,

        # custom object
        [Parameter()][switch]$PassThru,

        [Parameter(Position = 0)]
        [ArgumentCompletions(
            "'Value', 'Name'",
            "'Name', 'Value'"

        )]
        [string[]]$SortBy,



        [Parameter()][switch]$IgnoreBasic,
        [Parameter()][switch]$IgnoreLongTypes,
        # [Parameter()][switch]$IgnoreNull,
        # [Parameter()][switch]$IgnoreWhite,

        # extra options
        [Parameter()][hashtable]$Options
    )
    begin {
        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        [hashtable]$Config = @{
            NullStr         = "`u{2400}"
            UniqueType      = $True
            IncludeProperty = @(
                'Name'
                'Value'
                'TypeNameOfValue'
                # 'MemberType'
            ) # | Sort-Object -Unique
        }
        [list[object]]$items = [list[object]]::new()
        $Config = Join-Hashtable $Config ($Options ?? @{})

        KeyList = @{
            'Type_Order' = @(
                'MemberType'
                'Value'
                'IsSettable'
                'IsGettable'
                'TypeNameOfValue'
                'Name'
                'IsInstance'
            ) # | Sort-Object -Unique

        }



    }

    process {
        $objectList.Add( $InputObject )
    }
    end {
        if ($Config.UniqueType) {
            $Target = $curObject | Get-Unique -OnType
        } else {
            $Target = $curObject
        }
        if ($PassThru) {
            $target.psobject.properties | ForEach-Object {
                $_ | Select-Object $KeyList.IncludeProperty
            }
            return
        }

        $objectList | ForEach-Object {
            $curObject = $_
        }


        # $_.GetType() | Format-TypeName -Brackets | Write-Host
        $target.psobject.properties | ForEach-Object {
            $Value = $_.Value
            $ValueStr = $Value ?? $Config.NullStr
            $Type = if ($null -eq $Value) {
                '[{0}]' -f $Config.NullStr
            } else {
                $Value.GetType() | Format-TypeName -Brackets
            }



            $meta = @{
                PsTypeName  = 'JmPropList'
                Name        = $_.Name
                Value       = $ValueStr
                Type        = $Type
                TypeOfValue = $_.TypeNameOfValue | Format-TypeName -WithBrackets
            }


            [pscustomobject]$meta
        } | Sort-Object -p $Config.SortBy

    }
}

$experimentToExport.update_typeDataScriptBlock += @(
    {
        #  future: cleanup -force flags internally, a single
        # config var and the caller of update_typeDataScriptBlock will
        # decide whether or not to pass /w on or off force
        # left on for new, easier to test

        $TypeData = @{
            TypeName                  = 'JmPropList'
            DefaultDisplayPropertySet = 'Name', 'Type', 'Value' # FL
            DefaultDisplayProperty    = 'Name' # FW
            DefaultKeyPropertySet     = 'Name', 'Type' # sort and group
        }
        Update-TypeData @TypeData -Force
    }
)


# t.update_typeDataScriptBlock

if (! $experimentToExport) {
    if ($false -or $false) {
        # test FormatData
        Get-Item . | PropList
        Get-Item . | PropList | Select-Object -First 2 | Format-List
        Get-Item . | PropList | Format-Wide
    }

    if ($false -or $PrettyPrint) {
        10 / 0
        $error | Select-Object -First 1 | ForEach-Object {
            $_.GetType() | Format-TypeName -Brackets
            | Label 'type' | Write-Host
            $_ | PropList; hr;
        }
    }

    # ...
}
