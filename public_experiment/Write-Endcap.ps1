using namespace System.Management.Automation

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
    <#
    .synopsis
        Create "bookshelf endcaps" for visual separation
    .example
        🐒> "`n" -join '' | Format-ControlChar | Write-Endcap

            ->
            ␊
            <-
    #>
    [Alias('Endcap🎨')]
    [cmdletbinding(PositionalBinding = $false)]
    param(
        # Text array/list
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$InputObject,

        # Label of region
        # [Alias('Text')]
        [Parameter(Position = 1)]
        [string]$Label,

        # Optional Theme/mode
        [Alias('Style', 'Theme')]
        [Parameter(Position = 0)]
        [ArgumentCompletionsAttribute('Bold', 'Basic', 'Spartan')]
        [string]$OutputFormat = 'Spartan'


    )
    begin {
        $Template = @{
            StrPrefix   = '<----- Start: {0}'
            StrSuffix   = '<----- End: {0}'
            LinesBefore = 0
            LinesAfter  = 0
        }
        $writeColorSplat = @{
            'fg' = 'green4'
            'bg' = 'lightgreen'
        }
        switch ($OutputFormat) {
            'Bold' {
                $Template = @{
                    StrPrefix = '<----- Start: {0}'
                    StrSuffix = '<----- End: {0}'
                }
                $writeColorSplat = @{
                    'fg' = 'green4'
                    'bg' = 'lightgreen'
                }
                break
            }
            'Spartan' {
                $Template = @{
                    StrPrefix = '-> {0}'
                    StrSuffix = '<- {0}'
                }
                $writeColorSplat = @{
                    'fg' = 'green4'
                    # 'bg' = 'lightgreen'
                }
                break
            }
            default {
                # 'Basic or unknown'
                $Template = @{
                    StrPrefix   = '-> enter {0}'
                    StrSuffix   = '<- exit  {0}'
                    LinesBefore = 1
                    LinesAfter  = 1
                }
                $writeColorSplat = @{
                    'fg' = 'green4'
                    # 'bg' = 'lightgreen'
                }
                break
            }
        }
    }
    process {
        $Label ??= ''
        $InputObject ??= ''
        @(
            "`n" * $Template.LinesBefore -join ''
            write-color -t ($Template.StrPrefix -f @($Label)) @writeColorSplat
            # write-color -t "<----- Start: $Label" @writeColorSplat
            $InputObject
            # write-color -t "<-----   End: $Label" @writeColorSplat
            write-color -t ($Template.StrSuffix -f @($Label)) @writeColorSplat
            "`n" * $Template.LinesAfter -join ''
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