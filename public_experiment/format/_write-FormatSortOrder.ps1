#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_write-FormatSortOrder'
    )
    $experimentToExport.alias += @(

    )
}


function _write-FormatSortOrder {
    <#
    .synopsis
        label on tables to show sorted order
    .example
        PS> _write-FormatSortOrder Modified Desc
            ▽ Sortby: Modified ▽

        PS> _write-FormatSortOrder Id
            △ Sortby: Newest △

    .example
        PS> With args
            _write-FormatSortOrder -Options @{FormatMode='simple'}
            _write-FormatSortOrder -Options @{FormatMode='HighlightName'}
    #>
    param(
        [String]$Label = 'Newest',

        [parameter()]
        [ValidateSet('Ascending', 'Descending', 'Bottom', 'Top', 'Asc', 'Desc')]
        [String]$Order = 'Ascending',

        # extra options
        [Parameter()][hashtable]$Options

        # [parameter()]
        # [object]$Fg,

        # [parameter()]
        # [object]$Bg
    )
    begin {

        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        [hashtable]$Config = @{
            FormatMode = 'HighlightName' # __doc__ HighlightName | Simple
        }
        $Rune = @{
            'Ascending'  = '△'
            'Asc'        = '△'
            'Top'        = '△'
            'Descending' = '▽'
            'Desc'       = '▽'
            'Bottom'     = '▽'
        }
        $DimGlow = @{bg = 'gray15'; fg = 'gray30' }

        $Config = Join-Hashtable $Config ($Options ?? @{})
    }
    process {

        switch ($Config.FormatMode) {
            'HighlightName' {
                # & {
                #     $cDim = $PSStyle.Foreground.FromRgb('#4D4D4D')
                #     "${cDim}{0} SortBy: ${cBold}{1}${cDim} {0}" -f @(
                #         $Rune[$Order]
                #         $Label
                #     )
                # }
                & {
                    # $fg = [rgbcolor]'gray45' | ForEach-Object tostring
                    # $bg = [rgbcolor]'gray15' | ForEach-Object tostring
                    $cBold = "${fg:\gray70}"
                    $cDim = "${fg:\gray15}"
                    $cDim = "${fg:\gray45}"
                    $cDim = $PSStyle.Foreground.FromRgb('#4D4D4D')

                    $Template = "${cDim}{0} SortBy:${cBold}{1}${cDim} {0}"
                    $Template = "${cBold}{0}${cDim} SortBy:${cBold}{1}${cDim}${cBold} {0}"

                    $Template -f @(
                        $Rune[$Order]
                        $Label
                    )
                }

            }
            'Simple' {
                '{0} Sortby: {1} {0}' -f @(
                    $Rune[$Order]
                    $Label
                ) | Write-Color @dimGlow

            }
        }
    }
}


if (! $experimentToExport) {
    # ...
}
