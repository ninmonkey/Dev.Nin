$experimentToExport.function += 'Get-FormatStringTemplate'
$experimentToExport.alias += 'TemplateDates'

function Get-FormatStringTemplate {
    <#
    .synopsis
        cheat sheet for date format strings
    .description
        nin cheat sheet for date format strings
    .example
        _Get-FormatStringTemplate
    #>
    [Alias('TemplateDates')]
    [CmdletBinding()]
    param()

    process {
        $dateList = [System.Collections.Generic.List[object]]::new()
        $now = Get-Date

        function _addItem {
            <#
        todo: fix: refactor: I already have a wrapper that maps property names
        to create a new [psco],
        #>
            param(
                # FormatString
                [Parameter(Mandatory, Position = 0)]
                [string]$FormatString,

                # Alias
                [Parameter(Position = 1)]
                [string]$Alias = $null, # [string]::Empty

                # culture
                [Parameter()]
                [object]$culture = (Get-Culture), # [string]::Empty

                # Detailed description, very logn
                [Parameter(Position = 2)]
                [string]$Description = $null # [string]::Empty

            )

            $maybeDate = try {
                $now.ToString($FormatString)
            }
            catch [System.FormatException] {
                'Error'
            }

            $meta = [PSCustomObject]@{
                FormatString = $FormatString
                Alias        = $Alias
                Description  = $Description
                String       = $maybeDate
            }
            $dateList.Add($meta)
        }
        _addItem 'g' '' ''
        _addItem 'hh:mm:ss' '' ''
        _addItem 'm' '' ''
        _addItem 'mm' '' ''
        _addItem 'MMMM' '' ''
        _addItem 'o' '' ''
        _addItem 'p' '' ''
        _addItem 'q' '' ''
        _addItem 's' '' ''
        _addItem 't' '' ''
        _addItem 'u ' '' ''
        _addItem 'u'  '' ''
        _addItem 'u' '' ''
        _addItem 'v' '' ''
        _addItem 'yyyy__dd' '' ''
        _addItem 'yyyy_m_d' '' ''
        _addItem 'yyyy_M_dd' '' ''
        _addItem 'yyyy_mm_dd' '' ''
        _addItem 'yyyy-MM-dd' '' ''
        _addItem 'yyyy-MM-ddThh:mm:ss' '' ''
        _addItem 'yyyy-MM-ddThh:mm:ssZ' '' ''
        _addItem 'yyyy-mm' '' ''
        _addItem 'YYYY' '' ''
        _addItem 'z' '' ''
        _addItem 'zm' '' ''
        _addItem 'g' '' ''

        $datelist
    }


}
