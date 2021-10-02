$experimentToExport.function += @(
    'Write-Endcap'
)
$experimentToExport.alias += @(
    'Endcap🎨'    
)
# $experimentFuncMetadata += @{
#     # metadataRecord
#     Command = 'Format-Endcap'
#     Tags    = 'TextProcessing📚', 'Style🎨' # todo: build, from function docstrings
# }

function Write-Endcap {
    
    [Alias('Endcap🎨')]
    [cmdletbinding(PositionalBinding = $false)]
    param(
        # Text array/list
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$InputObject,

        # Label of region
        [Alias('Text')]
        [Parameter(Position = 0)]
        [string]$Label


    ) 
    begin {
        # $Theme = 'simple'
        # if ($Theme -eq 'simple') {
        #     $color_fg = gi fg:\green
        #     $color_bg = '#feab99'
        #     $color_bg = 'seafoam'
        #     $text_prefix = "<`n"
        #     $text_suffix = "`n>`n"               
        # }
        # elseif ($Theme -eq 'advanced') {
        #     $color_fg = gi fg:\green
        #     $color_bg = '#feab99'
        #     $color_bg = 'LightSeaGreen'
        #     $text_prefix = @(
        #         "<`n" | Write-color 'pink'
        #     ) -join ''
        #     $text_suffix = "`n>`n"               
        # }
    }
    process {
        $label = 'gc test'
        @(
            write-color -t "<----- Start: $Label" -fg green4 -bg lightgreen
            'stuff'
            write-color -t "<-----   End: $Label" -fg green4 -bg lightgreen
        )
    }
    end {
        #  "␤" "␀"        
        # except: "␣"
        # $joinStringSplat = @{
        #     # DoubleQuote = $true
        #     OutputPrefix = @(
        #         "`n"
        #         $text_prefix | Write-TextColor -fg $color_fg
        #         "`n"
        #     ) -join ''
        #     OutputSuffix = @(
        #         "`n"
        #         Write-TextColor -fg $color_fg -Text $text_suffix
        #         "`n"
        #     ) -join ''
        #     # $x = '#feab99'    
        # }

        # $InputObject | Join-String @joinStringSplat -ea break
    }
}



# #' ' | Format-ControlChar -PreserveWhitespace:$false
# #| Join-String -DoubleQuote -op '<' -os '>'

# ' adsf    fas' | Write-Endcap

# Write-Endcap -InputObject ' '

# 'do'

# 'done'