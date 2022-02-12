using namespace System.Collections.Generic

#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'pprint_array'
    )
    $experimentToExport.alias += @(
        # ''
    )
}

function pprint_array {
    <#
    .synopsis
        pretty print array, with colored to distinguish foldable region
    .description
        'low level' means  minimal dependencies
    .notes
        requires: Pansies
    #>
    param(
        [Alias('Items')]
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [object[]]$InputObject,

        [alias('Name')]
        [Parameter()]
        [string]$Label = '' # ex: 'items'

    )

    begin {
        [List[object]]$allItems = [list[object]]::new()
        $CStyle = @{}


        # too bright
        $CStyle.BrightBold = $prefixTextSplat = @{
            ForegroundColor = 'gray30'
            BackgroundColor = 'gray60'
            Object          = '    '
        }
        $CStyle.Other = $prefixTextSplat = @{
            ForegroundColor = 'gray30'
            BackgroundColor = 'gray60'
            Object          = '    '
        }

        $CStyle.Darkest = $prefixTextSplat = @{
            ForegroundColor = 'gray10'
            BackgroundColor = 'gray20'
            Object          = '    '
        }

        # nice inner dim
        $CStyle.dimText = $innerTextSplat = @{
            ForegroundColor = 'gray60'
            BackgroundColor = 'gray30'
        }
        #  = $innerTextSplat

        $strPrefixArray = New-Text @prefixTextSplat
        | ForEach-Object tostring
        # $strArrayHeader.Remove( ('object')

        $strArrayHeader = $strPrefixArray

        $joinStringSplat = @{
            Separator    = "`n${strPrefixArray}"
            # OutputPrefix = "${strPrefixArray}SortedImports = [`n"
            OutputPrefix = "${strPrefixArray}${bg:gray20}${Label}${bg:\gray30} = [`n${fg:clear}${bg:clear}"
            OutputSuffix = "`n]"
            Property     = {
                $_propName = $null
                $target = ($_propName) ? ($_.$_propName) : ($_)
                $_
                # $_.FullName
                # | To->RelativePath
                | New-Text @innerTextSplat | ForEach-Object tostring
            }
        }


        # $strPrefixArray
    }
    process {
        $allItems.AddRange($InputObject)
    }
    end {
        $allItems
      | Join-String @joinStringSplat

    }
}

$Error.clear()
$all_files = Get-ChildItem . -Depth 2
$selectedFiles = $all_files | Select-Object -First 14

pprint_array -Items $selectedFiles #-label '....'

$selectedFiles
| To->RelativePath
| pprint_array -label 'go 2'


if (! $experimentToExport) {
    # ...
}
