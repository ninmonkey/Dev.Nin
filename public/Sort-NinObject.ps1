$exampleList = @(
    [pscustomobject]@{
        Name = 'Bob'
        Id   = 0
        Guid = 0
    }
    [pscustomobject]@{
        Name = 'Bob'
        Id   = 10
        Guid = 1
    }
    [pscustomobject]@{
        Name = 'Ben'
        Id   = 10
        Guid = 2
    }
)

$Manual = @{}
$Manual.Name_DESC_Id_DESC = @(
    @{ expression = 'Name'; Descending = $true }
    @{ expression = 'Id'; Descending = $true }
)
$Manual.Name_ASC_Id_DESC = @(
    @{ expression = 'Name'; Descending = $false }
    @{ expression = 'Id'; Descending = $true }
)
$Manual.Name_DESC = @(
    @{ expression = 'Name'; Descending = $false }
)



function _runSortTest {
    # Format results from testing
    param(
        # Sort-Object property list
        [Parameter(Mandatory, Position = 0)]
        [hashtable[]]$PropList
    )
    # $PropList.GetEnumerator() | Join-String { $_.Key } -Separator ' '
    # $PropList | Format-HashTable
    H1 'Sort Test:'
    $PropList.GetEnumerator() | ForEach-Object {
        @{ $_.expression = ($_.Descending) ? 'Desc' : 'Asc' }
    } | Format-HashTable
    $exampleList | Sort-Object -Property $PropList | Format-Table
    # hr

}


function Sort-NinObject {
    <#
    .synopsis
        wrapper for Sort-Object. sort objects using properties in-order of selection in 'Out-Fzf'
    #>
    param(
        # Object
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [object]$InputObject,

        # properties to sort by, in-order
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('Property')]
        [string[]]$SortByProperty,

        # properties that sort as -Descending
        [Parameter(Position = 1)]
        [string[]]$DescendingProperty
    )

    begin {
        $NameList = $SortByProperty
        $meta = [ordered]@{
            SortBy    = $SortByProperty | Join-String -Separator ', ' -SingleQuote
            UsingDesc = $DescendingProperty | Join-String -sep ', ' -SingleQuote
        }


        [object[]]$FinalSortList = $NameList | ForEach-Object {
            @{
                Expression = $_
                Descending = $false
            }
        }

        $meta.FinalSortList = $FinalSortList

        $meta | Format-HashTable -Title 'Args' | Write-Information

        # $SortByProperty | Join-String -sep ', ' -DoubleQuote -outpre 'SortBy' | Write-Information
        # $DescendingProperty | Join-String -sep ', ' -DoubleQuote -outpre 'AsDescending' | Write-Information
        # $SortByProperty -join ', ' | Write-Debug
        # $DescendingProperty -join ', ' | Write-Debug
        'todo: validate sort prop names in first list'

    }
    process {
        $InputObject | Sort-Object -Prop $FinalSortList
    }
    end {

    }
}


if ($DebugTestMode) {
    H1 'Sort-NinObject' -fg red

    $sortSplat = @{
        InformationAction = 'Continue'
        Debug             = $false
        SortByProperty    = @(
            'Cat'
        )
    }
    # $exampleList | Sort-NinObject -InformationAction Continue -SortByProperty Name -Debug
    $exampleList | Sort-NinObject @sortSplat
    hr
    $exampleList | Sort-NinObject @sortSplat -SortByProperty Name
}
# $t.GetEnumerator() | ForEach-Object {
#     @{ $_.expression = $_.Descending }
# } | Format-HashTable
# | Join-string -sep ', ' -DoubleQuote {
#     $_.Expression, $_.Descending -join ''
# }

# $t.GetEnumerator() | ForEach-Object {
#     @{a = $_.key; b = $_.Value }
#     $x = 3
# }
#| Join-String { $_.Key, $_.Value -join ':' } -Separator ' '


if ($DebugTestMode) {
    hr
    H1 'Manual Sort' -fg red
    $exampleList
    _runSortTest $Manual.Name_DESC_Id_DESC
    _runSortTest $Manual.Name_DESC
    _runSortTest $Manual.Name_ASC_Id_DESC
}

if ($false) {
    $files = Get-ChildItem | Sort-Object Name

    $files
    | Format-Table Name, Length, LastWriteTime

    $files
    | Sort-Object Length
    | Format-Table Name, Length, LastWriteTime
}
