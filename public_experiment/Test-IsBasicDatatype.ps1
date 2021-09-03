

function Test-IsBasicDatatype {
    <#
    .synopsis
        try to guess whether type is basically a base datattpe
    .description
       .
    .example
          .
    .example
        PS> [int].pstypenames | HelpFromType -PassThru

        https://docs.microsoft.com/en-us/dotnet/api/System.String
        https://docs.microsoft.com/en-us/dotnet/api/System.Reflection.TypeInfo
        https://docs.microsoft.com/en-us/dotnet/api/System.Type
        https://docs.microsoft.com/en-us/dotnet/api/System.Reflection.MemberInfohttps://docs.microsoft.com/en-us/dotnet/api/System.Object
    .notes
        future:
            - [ ] [pscustomobject]::AdaptedMemberSetName
    .outputs
        [pscustomobject]

    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Alias('Data')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )

    begin {
        $NullStr = "`u{2400}"
        $NumericTypes = [int], [double], [float]


        function _formatHumanize {
            <#
                    .synopsis
                        format nicers
                    .description
                        converts nulls to [␀]
                        types to Format-TypeName
                    .example
                    #>
            [cmdletbinding()]
            param(
                #
                [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
                [hashtable]$InputHash
                # [object]$InputObject
            )
            process {
                try {


                    $InputHash.GetEnumerator() | ForEach-Object {
                        $Key = $_.Key
                        $Value = $_.Value
                        if ($null -eq $Value) {
                            $InputHash[$Key] = $NullStr
                        }

                        $Value | ForEach-Object {
                            $curVal = $_
                            if ($curVal -is [type]) {
                                $curVal | Format-TypeName -Brackets
                            }
                            else {
                                $curVal
                            }
                        }
                    }
                }
                catch {
                    $PSCmdlet.WriteError( $_ )
                }
            }

        }
    }
    process {
        # original: $curObj.GetType().IsPrimitive -or $curObj.GetType() -eq [string]
        try {
            $InputObject = ForEach-Object {
                $curObj = $_

                $isNull = $null -eq $curObj
                $type = ($curObj)?.GetType()
                $isType = $curObj -is [type]
                $typeData = $isType ? ($curObj)?.GetTypeData() : $null

                $isPrimitive = ($type)?.IsPrimitive
                $IsNumeric = $type -in $NumericTypes

                [bool]$isBasic = $curObj.GetType().IsPrimitive -or $curObj.GetType() -eq [string]
                $summary = @{
                    IsBasic       = $isBasic
                    IsNull        = $isNull
                    IsNumeric_WIP = $IsNumeric
                    IsValueType   = $curObj -is [valuetype] # means ValueType is in .pstypenames, which means what?
                    IsIsPrimitive = $isPrimitive
                    IsType        = $IsType
                    Type          = $type
                    TypeData      = $typeData
                    PSTypeNames   = $curObj.PSTypeNames
                    HasPsBase     = $null -ne $curObj.psbase
                    Count         = $curObj.Count
                    Length        = ($curObj)?.Length
                    # PSCustomObject = [pscustomobject]
                }

                [pscustomobject]$summary



            }
        }
        catch {
            $PSCmdlet.WriteError( $_ )
        }

        ## now replace any null strs

    }
    end {}
}

# todo: next:
# if (! $__ninConfig.IsFirstLoad) {
#     'sdf'


#     324, 3.14, '324' | Test-IsBasicDatatype -ea break
#     Hr
#     @(
#         $cat = [pscustomobject]@{ name = 'Fred' }
#         $cat
#         [ordered]@{a = 4 }
#         @{ species = 'ant' }
#         , @(324, 3.14)
#     ) | Test-IsBasicDatatype -Verbose -Debug -ea break
# }
