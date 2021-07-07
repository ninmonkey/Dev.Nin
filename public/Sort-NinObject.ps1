
function Sort-NinObject {
    <#
    .synopsis
        wrapper for Sort-Object. sort objects using properties in-order of selection in 'Out-Fzf'
    .notes
    to question:
        1] Do I *not* want a process block? (Then I don't have to collect?)
            $InputObject | Sort-Object @myArgs
        2]
            [list[object]]::new()
            or
            [list[psobject]]::new()

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
        $objectList = [list[object]]::new()


        [object[]]$GeneratedSortList = $NameList | ForEach-Object {
            @{
                Expression = $_
                Descending = $false
            }
        }

        $meta.FinalSortList = $GeneratedSortList
        Format-HashTableList $meta.FinalSortList | Label 'FinalSortList'

        $meta | Format-HashTable -Title 'Args' | Write-Information

        # $SortByProperty | Join-String -sep ', ' -DoubleQuote -outpre 'SortBy' | Write-Information
        # $DescendingProperty | Join-String -sep ', ' -DoubleQuote -outpre 'AsDescending' | Write-Information
        # $SortByProperty -join ', ' | Write-Debug
        # $DescendingProperty -join ', ' | Write-Debug
        'todo: validate sort prop names in first list'

    }
    process {
        $objectList.Add( $InputObject )
        # $InputObject | Sort-Object -Prop $GeneratedSortList
    }
    end {
        $objectList | Sort-Object -Property $GeneratedSortList
    }
}
