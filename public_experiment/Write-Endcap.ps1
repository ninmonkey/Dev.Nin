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
        [string]$InputObject
    ) 
    begin {
        $Theme = 'advanced'
        if ($Theme -eq 'simple') {
            $color_fg = gi fg:\green
            $color_bg = '#feab99'
            $color_bg = 'seafoam'
            $text_prefix = "<`n"
            $text_suffix = "`n>`n"               
        }
        elseif ($Theme -eq 'advanced') {
            $color_fg = gi fg:\green
            $color_bg = '#feab99'
            $color_bg = 'seafoam'
            $text_prefix = @(
                "<`n" | Write-color 'pink'
            )
            $text_suffix = "`n>`n"               
        }
    }
    end {
        #  "␤" "␀"        
        # except: "␣"
        $joinStringSplat = @{
            # DoubleQuote = $true
            OutputPrefix = @(
                "`n"
                Write-TextColor -fg $color_fg -Text $text_prefix
                "`n"
            ) -join ''
            OutputSuffix = @(
                "`n"
                Write-TextColor -fg $color_fg -Text $text_suffix
                "`n"
            ) -join ''
            # $x = '#feab99'    
        }

        $InputObject | Join-String @joinStringSplat
    }
}



# #' ' | Format-ControlChar -PreserveWhitespace:$false
# #| Join-String -DoubleQuote -op '<' -os '>'

# ' adsf    fas' | Write-Endcap

# Write-Endcap -InputObject ' '

# 'do'

# 'done'