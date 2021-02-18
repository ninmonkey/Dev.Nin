Import-Module Dev.Nin -Force -wa SilentlyContinue
$ConfigTest = @{
    'first_test'           = $false
    'Interactive_NoRender' = $false
    'Interactive'          = $true
}

if ($ConfigTest.first_test) {
    Dev-PrintTableTemplate
    Dev-PrintTableTemplate -MinColWidth 5 -FillRemainingWidth -Debug

    h1 'start'

    hr
    Table -NumColumns 15
    Table -FillRemainingWidth -MinColWidth 10
    Table -MinColWidth 30 -FillRemainingWidth

}



# $items = Get-ChildItem . | Select-Object name, Length, LastWriteTime


function Interactive_NoRender {
    [CmdletBinding()]
    param ()

    $MinCellWidth = 1

    $rowData = Get-ChildItem -Path 'c:\'  | Select-Object -First 4| ForEach-Object {
        $Extension = [string]::IsNullOrWhiteSpace( $_.Extension ) ? 'N/A' : $_.Extension
        $Vals = $_.Name, $Extension, $_.LastWriteTimeString
        $Vals
        $rowMax = $Vals | Measure-Object -Macximum -Property Length | ForEach-Object Maximum
        $Vals -join ', ' | Write-Debug
        Write-Debug "Row max: $rowMax"
        $MinCellWidth = $MinCellWidth, $rowMax | Measure-Object -Maximum | ForEach-Object Maximum
        Write-Debug "minCell: $MinCellWidth"
    }
    # so try it
    , $rowData
}

if ($ConfigTest.Interactive_NoRender) {
    h1 'test:Interactive_NoRender'
    $rowData = Interactive_NoRender -Debug
    $rowData | ConvertTo-Json | pygmentize -l json
}

function Interactive {
    [CmdletBinding()]
    param ()

    process {
        $rowData = Get-ChildItem -Path 'c:\'  | Select-Object -First 9 | ForEach-Object {
            $MinCellWidth = 1
            $Extension = [string]::IsNullOrWhiteSpace( $_.Extension ) ? 'N/A' : $_.Extension
            $CurRow = $_.Name, $Extension, $_.LastWriteTimeString

            $rowMax = $CurRow | Measure-Object -Maximum -Property Length | ForEach-Object Maximum

            $MinCellWidth = $MinCellWidth, $rowMax | Measure-Object -Maximum | ForEach-Object Maximum

            # Table -MinColWidth $MinCellWidth -NumColumns ($CurRow.Count)
            Label "`nTable"
            Table -MinColWidth $MinCellWidth -NumColumns ($CurRow.Count)

            Label "`nMinimized Widths"
            $inner = $CurRow -join '|'
            '|', $inner, '|' -join ''

            Label "`nForcedEqual"

            function printEqualWidth {
                <#
                .example
                    PS>
                        'nin', 'N/A',  '9/1/2019  2:49 PM'

                    #output
                        |                nin|                N/A|  9/1/2019  2:49 PM|
                #>
                [CmdletBinding()]
                param (
                    [Parameter(HelpMessage = "Align text left or right?")][switch]$AlignLeft
                )

                $NumAsStr = ('{0}' -f $MinCellWidth)

                $AlignmentStr = $AlignLeft ? '-' : ''

                $Template = '{{0,{1}{0}}}' -f $MinCellWidth, $AlignmentStr
                Write-Debug "Template = '$Template'"

                $Row = $CurRow | ForEach-Object {
                    $record = $_
                    $Template -f $record
                }

                $Inner = $row -join '|'
                '|', $inner, '|' -join ''
            }
            printEqualWidth -Debug

        }
        $rowData
        # so try it
    }

}

if ($ConfigTest.Interactive) {
    h1 'test:Interactive'
    Interactive
}