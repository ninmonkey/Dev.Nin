using namespace System.Collections.Generic

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
        JProp v0.1
        future:
            - [ ] normal props
                render dark

        very soon, pull advanced functionality to Get-NinOBject
        more broad, reusable, simple logic here
        - [ ] bug beacuse mid-refactor:
            - [ ] jProp -PassThru: doesn't display abbreviated names

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

    .example
        PS>

            (Get-Process)[0]
            | jProp -FilterType IgnoreNullValue
h1 'auto'
$someP | jProp -FilterType IgnoreBasicType
 | sort type
    #>
    [Alias('jProp')]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputObject,

        # custom object
        [Parameter()][switch]$PassThru,

        [Parameter(Position = 0)]
        [ArgumentCompletions(
            "'Value', 'Name'", # future: maybe 7.2 attr would let me build strings off of a list
            "'Name', 'Value'"

        )]
        [string[]]$SortBy,



        [Parameter()][switch]$IgnoreBasic,
        [Parameter()][switch]$IgnoreLongTypes,
        # [Parameter()][switch]$IgnoreNull,
        # [Parameter()][switch]$IgnoreWhite,

        # extra options
        [Parameter()][hashtable]$Options,


        # extra non-hashtable options, makes parameset collisions easier
        [ValidateSet(
            'IgnoreNullValue', 'OnlyNullValue',
            'IgnoreBasicType', 'OnlyBasicType'
        )]
        [Parameter()][string[]]$FilterType
    )
    begin {
        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        [hashtable]$Config = @{
            NullStr          = "`u{2400}"


            # half working
            UniqueType       = $True

            # == NYI == #6
            IncludeProperty  = @(
                'Name'
                'Value'
                'TypeNameOfValue'
                # 'MemberType'
            ) # | Sort-Object -Unique

            # == NYI ==
            # limit long names instead of removing them.
            MaxTypenameWidth = 50 # [$null | 0 | 50]
            IgnoreBasicTypes = @(
                'String', 'Int'
            )

            # == NYI == $KeyList
        }
        [List[object]]$objectList = [list[object]]::new()
        $Config = Join-Hashtable $Config ($Options ?? @{})

        $KeyList = @{
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
        $objectList.AddRange( $InputObject )
    }
    end {
        if ($Config.UniqueType) {
            $Target = $objectList | Get-Unique -OnType
        } else {
            $Target = $objectList
        }
        if ($PassThru) {
            # | ?{
            #     if(! $IgnoreBasic) {
            #         return $true;
            #     }

            #     foreach($t_name in $Config.IgnoreBasicTypes){
            #         if($_ -is $t_name) {
            #             return $false;
            #         }
            #     }
            #     return $true;

            # }
            $target.psobject.properties
            | ForEach-Object {
                $_ | Select-Object $Config.IncludeProperty
            }
            return
        }


        $objectList | ForEach-Object {
            $curObject = $_
            # $_.GetType() | Format-TypeName -Brackets | Write-Host
            $curObject.psobject.properties | ForEach-Object {
                $prop = $_
                # Wait-Debugger

                # early exist if wrong type
                switch ($FilterType) {
                    'IgnoreNullValue' {
                        if ($null -eq $prop.value) {
                            return
                        }
                        break
                    }
                    'OnlyNullValue' {
                        if ($null -eq $prop.value) {
                            # ..
                        } else {
                            return
                        }
                        break
                    }
                    default {
                        # throw "UnhandledFilterType: '$FilterType'"
                    }
                }


                # this segment was sleep deprived
                $Value = $prop.Value
                $ValueStr = $Value ?? $Config.NullStr
                $Type = if ($null -eq $Value) {
                    '[{0}]' -f $Config.NullStr
                } else {
                    try {
                        try {
                            $Value.GetType() | Format-TypeName -Brackets
                        } catch {
                            $Value | ShortName
                        }
                    } catch {
                        if ($null -eq $Value) {
                            '<bad>'
                        } else {
                            $Value.GetType()
                        }
                    }
                }

                $ValueStr = switch ($Value) {
                    {
                        $prop -is 'string' -and $prop -eq [string]::Empty
                    } {
                        '␠'
                    }
                    { $null -eq $prop } {
                        '[{0}]' -f $Config.NullStr
                    }
                    default {
                        $Value
                        # $Value ## no longer wanted, refactor into the format display
                        # $Value.GetType() | Format-TypeName -WithBrackets
                    }
                }



                $meta = @{
                    PsTypeName = 'JmPropList'
                    Name       = $prop.Name
                    Value      = $prop.Value # Valueformatted
                    ValueStr   = $ValueStr # todo: return value if not being formatted
                    Type       = $Type
                    # TypeOfValue = $prop.TypeNameOfValue | Format-TypeName -WithBrackets
                }
                [pscustomobject]$meta
            } | Sort-Object -p $Config.SortBy
        }

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
