using namespace System.Management.Automation

$experimentToExport.function += @(
    '_formatErrorSummarySingleLine'
    '_formatErrorSummary'
)
$experimentToExport.alias += @(

)

function _formatErrorSummarySingleLine {
    <#
    .synopsis
        Summarize errors, one per line
    .notes
        .
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
        [alias('Error')]
        [Parameter(ValueFromPipeline, Position = 0)]
        [object]$InputObject
    )

    begin {
        $errorList = [list[object]]::new()
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
        if ($errorList.count -le 0) {
            # $errorList.AddRange( $global:error ) # Do I want global or script?
            $global:error | ForEach-Object { $errorList.Add( $_ ) }
        }
        $errorList | ForEach-Object {
            $_ | ShortenStringJoin -MaxLength ([console]::WindowWidth - 1 )
        } | Join-String -sep (Hr 1)

    }
}

function _formatErrorSummary {
    <#
    .synopsis
        attempt to summarize ErrorRecords
    .notes
        .
    .example
        PS> _formatErrorSummarySingleLine
    .example
        PS> $error[0..2] | _formatErrorSummarySingleLine
    .inputs
        [Exception] | [RuntimeException] | [ActionPreferenceStopException]
    .outputs
        [PSCustomObject]
    #>
    param(
        #
        [alias('Error')]
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
            throw 'left off here'
            $meta = @{
                PSTypeName = 'dev.nin.ErrorRecordSummary'


            }
            [pscustomobject]$meta
        }
    }
    process {
        if ($InputObject -is 'Exception') {
            _processException $InputObject
        }
        elseif ($InputObject -is [Management.Automation.ErrorRecord]) {
            _processErrorRecord $InputObject
        }
        else {
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
