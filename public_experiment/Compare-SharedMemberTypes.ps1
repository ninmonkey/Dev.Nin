using namespace System.Collections.Generic
if (! $DebugEnableInlineTest) {
    $experimentToExport.function += 'Compare-SharedMemberTypes'
    $experimentToExport.alias += 'findCommonMembers'
}



# | ForEach-Object {
#     $_ | Fm
# } | Group-Object Name | Sort-Object count -Descending


# [System.Management.Automation.ApplicationInfo], [System.Management.Automation.FunctionInfo], [System.Management.Automation.AliasInfo]
# | ForEach-Object {
#     $_ | Fm
# } | Group-Object Name | Sort-Object count -Descending


function Compare-SharedMemberTypes {
    <#
    .synopsis
        look properties or members that are shared, it doesn't compare the actual values
    .description
    .notes
        .todo
            - [ ] compare from FM
            - [ ] or compare from GM

        - different mode
            - [ ] shows final counts
            - [ ] other might compare datatype is equal too

        - additional options: Add params
            $splatFindMember
            $splatGetMember

       .
    .example
        $sample = [AliasInfo], [FunctionInfo], [ApplicationInfo].

    .outputs

    #>
    [Alias('findCommonMembers')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object[]]$InputObject,

        # Remove anything that is common to all of them
        [Parameter()][switch]$IgnoreShared,

        # remove anything that does not match
        [Parameter()][switch]$OnlyShared,

        # which mode
        [alias('Mode')]
        [ValidateSet('GetMember', 'FindMember', 'Properties')]
        [Parameter()][string]$CompareMode = 'FindMember'
    )

    begin {
        Write-Warning 'Still experimentingal'
        $ObjectList = [list[object]]::new()
    }
    process {
        $InputObject | ForEach-Object {
            $ObjectList.Add( $_ )
        }
    }
    end {
        $comparisonList = switch ($CompareMode) {
            'Properties' {
                $ObjectList | ForEach-Object {
                    $curObj = $_

                    $curObj.psobject.properties | ForEach-Object {
                        $Meta = @{
                            Name     = $_.Name
                            Value    = $_.Value
                            TypeName = ($_.Value)?.GetType() | Format-TypeName
                            # Instance = $_
                        }
                        # $sample[0].psobject.properties | ? Name -Match 'attrib' | %{ ($_.Value)?.GetType() | Format-TypeName }
                        # $sample[0].psobject.properties | ? Name -Match 'attrib' | %{ ($_.Value)?.GetType() | Format-TypeName }
                    }
                    [pscustomobject]$meta
                }
                break
            }
            'FindMember' {
                $ObjectList
                | Find-Member
                | Group-Object -Property {
                    Write-Warning 'check out, better system than this'
                    $_.Name
                }
                | Sort-Object Count -desc
                | ForEach-Object {
                    [pscustomobject]@{
                        ShareCount  = $_.Count
                        MemberName  = $_.Name
                        TypeName    = $_.Group.Name | Select-Object -First 1
                        Group       = $_.Group.ReflectedType.Name | Sort-Object
                        CompareMode = $CompareMode
                        # ReturnType = $_.Group.
                    }
                } | Sort-Object ShareCount -Desc

                break
            }
            'GetMember' {
                $ObjectList | ForEach-Object {
                    $_ | Get-Member
                }
                | Group-Object -Property {
                    $_.Name
                }
                | Sort-Object Count -desc
                | ForEach-Object {
                    throw 'wip hwere'
                    [pscustomobject]@{
                        ShareCount  = $_.Count
                        # Name        = $_.Group.Name | Select-Object -First 1
                        # Group       = $_.Group.ReflectedType.Name | Sort-Object
                        CompareMode = $CompareMode
                    }
                } | Sort-Object ShareCount -Desc

                break
            }
            default {
                throw "Unhandled mode '$CompareMode'"
            }

        }

        $TotalItems = $ObjectList.count

        # composable filters
        $filteredList = $comparisonList
        if ($IgnoreShared) {
            $filteredList = $filteredList | Where-Object ShareCount -NE $TotalItems
        }
        if ($OnlyShared) {
            $filteredList = $filteredList | Where-Object ShareCount -EQ $TotalItems
        }

        $filteredList
        return
    }
}

if ($DebugEnableInlineTest) {
    $sample = [System.Management.Automation.ApplicationInfo], [System.Management.Automation.FunctionInfo], [System.Management.Automation.AliasInfo]
    $sample2 = [int], [float]
    Compare-SharedMemberTypes -InputObject ([int], [float], [decimal])
    return

    $Sample | Compare-SharedMemberTypes -Mode FindMember
    # $Sample | Compare-SharedMemberTypes -Mode GetMember
    $Sample | Compare-SharedMemberTypes -IgnoreShared -Mode FindMember
    $Sample | Compare-SharedMemberTypes -Mode Properties

    # $Sample | Compare-SharedMemberTypes -IgnoreShared -Mode GetMember
}
