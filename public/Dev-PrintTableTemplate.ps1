1, 127, 128, 255, 256 | hex | Join-String -sep ' '

hr
1, 127, 128, 255, 256 | hex | Join-String { '{0,10}' -f $_ }
1, 127, 128, 255, 256 | hex | Join-String { '{0,-10}' -f $_ }


function Dev-PrintTableTemplate {
    <#
    .synopsis
        debug printing to compare other function against
    .example
        PS>
        Table -NumColumns 15
        Table -FillRemainingWidth -MinColWidth 10
        Table -MinColWidth 30 -FillRemainingWidth

        #output
        |xxxx|xxxx|xxxx|xxxx|xxxx|xxxx|xxxx|xxxx|xxxx|xxxx|xxxx|xxxx|xxxx|xxxx|xxxx|
        |xxxxxxxxxx|xxxxxxxxxx|xxxxxxxxxx|xxxxxxxxxx|xxxxxxxxxx|xxxxxxxxxx|
        |xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx|
    #>
    [alias('Table')]
    param(
        [Parameter(
            # Position = 0,
            HelpMessage = 'Min width for all columns')]
        [uint]$MinColWidth = 4,

        [Parameter(
            # Position = 0,
            HelpMessage = 'Total number of columns per row')]
        [uint]$NumColumns = 1,

        [Parameter(
            # Position = 0,
            HelpMessage = 'limit width of table')]
        [uint]$MaxConsoleWidth = [console]::WindowWidth,

        [Parameter(HelpMessage = "Fill remaining width with columns, rather than maximize cells with a static number of columns, ex: format-wide verses format-table")][switch]$FillRemainingWidth,

        [Parameter(HelpMessage = 'character to join on')][string]$ColumnsSeparator = '|',
        [Parameter(HelpMessage = 'character to join on')][string]$TablePrefix = '|',
        [Parameter(HelpMessage = 'character to join on')][string]$TableSuffix = '|'



    )
    # [uint]$MinColWidth = 4
    # [uint]$NumColumns = 3
    # [uint]$MaxConsoleWidth = [console]::WindowWidth

    $Template = @{}
    $Template.RowPrefix = $TablePrefix
    $Template.RowSuffix = $TableSuffix
    $Template.ColumnChar = 'x'
    $Template.ColumnSeperator = $ColumnsSeparator

    $splat_TableJoinString = @{
        Separator    = $Template.ColumnSeperator
        OutputSuffix = $Template.RowSuffix
        OutputPrefix = $Template.RowPrefix
    }

    if (! $FillRemainingWidth ) {

        1..$NumColumns | ForEach-Object {
            $Template.ColumnChar * $MinColWidth -join ''
        } | Join-String @splat_TableJoinString
        return
    }

    # calc dynamic number of columns
    $ColPaddingCount = 2
    $PotentialColumnCount = 0 + [math]::Floor( $MaxConsoleWidth / $MinColWidth )
    Write-Debug "Potential: $PotentialColumnCount"
    # $TotalCharWidth = $MaxConsoleWidth
    do {
        # refactor: It could attempt to generate a string then test the .Length
        $ActualColumnCount = $PotentialColumnCount
        $TotalCharWidth = 2 # prefix/suffix
        $TotalCharWidth += 1 * $PotentialColumnCount # joiners
        $TotalCharWidth += $MinColWidth * 1 * $PotentialColumnCount # inners
        $PotentialColumnCount -= 1
        Write-Debug "Total: $TotalCharWidth"
    } while ( $TotalCharWidth -ge $MaxConsoleWidth )
    Write-Debug "Total: $TotalCharWidth /w $PotentialColumnCount"

    Dev-PrintTableTemplate -MinColWidth $MinColWidth -NumColumns $ActualColumnCount
}
