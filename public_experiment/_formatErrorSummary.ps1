#Requires -Version 7
using namespace System.Management.Automation

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_formatErrorSummarySingleLine'
        '_processErrorRecord'
    )
    $experimentToExport.alias += @(
        # ''
    )
}
function _formatErrorSummarySingleLine {
    <#
    .synopsis
        formats Summarize errors, one per line
    .notes
        .Format outputs text, see _processErrorRecord for inspection
    .example
        PS> _formatErrorSummarySingleLine
    .example
        PS> $error[0..2] | _formatErrorSummarySingleLine
    .inputs
        [Exception] | [RuntimeException] | [ActionPreferenceStopException]
    .outputs
        [string]
    #>
    param(
        #
        [alias(
            # 'Error' # 'default resolves as get-error' 
        )]
        [Parameter(ValueFromPipeline, Position = 0)]
        [object]$InputObject,

        # alter style
        [Parameter()]
        [validateset('2Line', 'Single')]
        [string]$OutputFormat,

        # MaxWidth / columns
        [Alias('Width')]
        [Parameter()]
        [uint]$MaxLineLength
    )

    begin {        
        $errorList = [list[object]]::new()
        $colors = @{
            ErrorDim    = [PoshCode.Pansies.RgbColor]'#8B0000' # darkred'
            ErrorBright = [PoshCode.Pansies.RgbColor]'#FF82AB'
            ErrorPale   = [PoshCode.Pansies.RgbColor]'#CD5C5C'
            Error       = [PoshCode.Pansies.RgbColor]'#CD3700'
            FgVeryDim   = [PoshCode.Pansies.RgbColor]'gray40'
            FgDim       = [PoshCode.Pansies.RgbColor]'gray60'
            Fg          = [PoshCode.Pansies.RgbColor]'gray80'
            FgBright    = [PoshCode.Pansies.RgbColor]'gray90'
            FgBright2   = [PoshCode.Pansies.RgbColor]'gray100'
            
        }
        
    }
    process {
        
        # if (!$InputObject) {
        #     $InputObject = $global:error # Do I want global or script?
        # }

        if ($InputObject) {
            $errorList.Add( $InputObject )
        }
        # $errorList.Add( $InputObject )

    }
    end {

        function __outputFormat_2Line {
            # minimal space taken
            $MaxLineLength ??= [console]::WindowWidth - 1

            if ($errorList.count -le 0) {
                # $errorList.AddRange( $global:error ) # Do I want global or script?
                $global:error | ForEach-Object { $errorList.Add( $_ ) }
            }
            $errorList | ForEach-Object -Begin { $i = 0 } {
                'e -> {0}' -f $i
                $_ | ShortenStringJoin -MaxLength $MaxLineLength
                $i++
            } | Join-String -sep (Hr 1)
        }
        function __outputFormat_SingleLine {
            <#
            .synopsis
                minimal space taken
            .notes
                the error [Automation.ParseException]
                    has these members
                        - [Language.ParseError[]]: Errors
                        - [ErrorRecord]: ErrorRecord

                type: [Automation.ParseException]
                    members: 
                        - [Language.ParseError[]]: Errors
                        - [ErrorRecord]: ErrorRecord
                        
                type: [Automation.ErrorRecord]
                    members:
                        - [Automation.ErrorRecord]: ErrorDetails

                    
            #>
            $MaxLineLength ??= [console]::WindowWidth - 1

            if ($errorList.count -le 0) {
                # $errorList.AddRange( $global:error ) # Do I want global or script?
                $global:error | ForEach-Object { $errorList.Add( $_ ) }
            }
            $errorList | ForEach-Object -Begin { $i = 0 } {
                $curError = $_
                $hasSubErrors = $null -ne $curError.Errors
                $cDef = $colors.fg
                $cStatus = [rgbcolor]'red'
                @(                  
                    if ($hasSubErrors) { 
                        "+ subs`n" | Write-Color gray80
                    }                    
                    'errΔ [' | Write-Color $cDef
                    '{0}' -f @(
                        $i | Write-Color $cStatus
                    )
                    ']' | Write-Color $cDef
                    ' of ['
                    '{0}' -f @(
                        $errorList.count | Write-Color $cStatus
                    )
                    ']'

                ) | Join-String 

                @(
                    'e[{0}]' -f $i
                    $curError | ShortenStringJoin -MaxLength $MaxLineLength | Write-Color 'gray80'
                ) | Join-String
                | ShortenStringJoin -MaxLength $MaxLineLength # because header changes len

                $i++
            } | Join-String -sep (Hr 1)
        }


        # -------
        

        switch ($OutputFormat) {
            '2Line' { 
                __outputFormat_2Line
                break
            }
            'Single' {
                __outputFormat_SingleLine
            }
            default {
                __outputFormat_SingleLine
                break
            }
        }

    }
}




function _processErrorRecord {
    <#
    .synopsis
        attempt to summarize ErrorRecords, and exceptions (maybe split into two)
    .notes
        .
    .example
        PS> _processErrorRecord
    .example
        PS> $error[0..2] | _processErrorRecord
    .inputs
        [Exception] | [RuntimeException] | [ActionPreferenceStopException]
    .outputs
        [PSCustomObject]
    #>
    param(
        #
        [alias(
            'Error',
            'Format->Error'
        )]
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [object]$InputObject
    )

    begin {
        $Meta = @{}
        $Str = @{
            JoinNewline = ' ◁ ' | New-Text -fg 'gray60' | ForEach-Object tostring            # '… …◁'
        }
        function _processException {
            <#
            .synopsis
                convert Exception to [dev.nin.ExceptionSummary]
            #>
            param(
                # errorRecord instance
                [Parameter(Mandatory, Position = 0)]
                [object]$Exception
            )

            $cur = $Exception

            $tinfo = $cur.GetType()
            $meta = @{
                PSTypeName         = 'dev.nin.ExceptionSummary'
                # TypeName   = $cur.GetType().FullName | New-TypeInfo | Format-TypeName -Brackets
                TypeNameStr        = $tinfo | Format-TypeName -Brackets
                BaseTypeNameStr    = $tinfo.BaseType | Format-TypeName -brack
                ToStr              = $cur | ShortenStringJoin -MaxLength 220 -CollapseWhiteSpace # this shoudl be formatter's logic
                Errors_ErrorId     = $cur.Errors.ErrorId
                Errors_Extent      = $cur.Errors.Extent
                Errors_Message     = $cur.Errors.Message
                'Errors[]_ErrorId' = $cur.Errors.ErrorId
                'Errors[]_Extent'  = $cur.Errors.Extent
                'Errors[]_Message' = $cur.Errors.Message

            }
            [pscustomobject]$meta
        }
        function _processErrorRecord {
            <#
            .synopsis
                convert ErrorRecord to [dev.nin.ErrorRecordSummary]
            #>
            param(
                # errorRecord instance
                [Parameter(Mandatory, Position = 0)]
                [object]$ErrorRecord
            )
            $cur = $ErrorRecord
            # Write-Warning 'left off here'
            $meta = @{
                PSTypeName = 'dev.nin.ErrorRecordSummary'


            }
            [pscustomobject]$meta
             
        }
    }
    process {
        # Wait-Debugger
        if ($InputObject -is 'Exception') {
            _processException $InputObject
        } elseif ($InputObject -is [Management.Automation.ErrorRecord]) {
            _processErrorRecord $InputObject
        } else {
            Write-Error -ea stop 'Input is not an Exception?' -Category InvalidType -ErrorId 'NotAnExceptionType' -TargetObject ($InputObject.GetType())
        }

        # if (!($InputObject -is 'Exception')) {

        $meta.Name = $_.GetType() | Format-TypeName -bra # future: logic in FormatData


        # Ensure it's a single line
        # $Meta.String = $_.ToString() -split '\r?\n' | Join-String -sep $str.JoinNewline | ShortenString -MaxLength 120
        $Meta.String = $_ | ShortenString | Join-String -sep $str.JoinNewline | ShortenString -MaxLength 120

        # refactor func

        $Meta.HasChildRecord = $false

        [pscustomobject]$meta

    }
    end {
        Write-Warning "finish me: $PSCommandPath"
    }
}


if (! $experimentToExport) {
    # ...
}