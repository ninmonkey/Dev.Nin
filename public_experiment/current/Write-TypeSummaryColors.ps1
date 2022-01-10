#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Write-TypeSummaryColors'
    )
    $experimentToExport.alias += @(
        'Fmt->TypeSummary🎨'
        # 'A'
    )
}

function Write-TypeSummaryColors {
    <#
    .synopsis
        double items in the pipeline
    #>
    [Alias('Fmt->TypeSummary🎨')]
    [CmdletBinding()] #
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )

    begin {
        $Config = @{
            WithColor = $true
        }
        $Color = @{
            FgDim  = 'gray70'
            Fg     = 'gray100'
            FgBold = 'orange'
        }
        function _resolveTypeInfo {
            # resolve as typeinfo
            param( $Type )
            $tinfo = if ($Type -is 'type') {
                $Type
            } else {
                    ($Type)?.GetType() ?? "`u{2400}"
            }
            return $tinfo
        }

        function _writeTypenameSummary {
            # FullName to string
            param(
                [alias('InputObject', 'Name')]
                [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
                [object]$TypeName,

                # colorize?
                [Parameter()]
                [switch]$WithColor
            )
            process {
                $tinfo = _resolveTypeInfo $TypeName

                @(
                    '[' | write-color $Color.FgBold
                    if ($Config.WithColor) {
                        $tinfo.namespace -join '.' | write-color $Color.FgDim
                        '.'
                    }

                    $tinfo.name | write-color $color.Fg
                    ']' | write-color $Color.FgBold

                ) | Join-String



            }
        }

    }
    process {
        $tinfo = _resolveTypeInfo $InputObject
        h1 'name'
        $tinfo | _writeTypenameSummary
        h1 'base'
        $tinfo.BaseType | _writeTypenameSummary
        h1 'implements:'
        $tinfo.ImplementedInterfaces | Sort-Object FullName | _writeTypenameSummary

    }
}



if (! $experimentToExport) {
    Get-Item . | Write-TypeSummaryColors

    hr -fg magenta
    Get-Date | Write-TypeSummaryColors
    # ...
}
