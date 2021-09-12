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

function Get-Foo {
    <#
    .synopsis
        Stuff
    .description
       .
    .example
          .
    .outputs
          [string | None]

    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Name
    )

    begin {

    }
    process {
        $Name | ForEach-Object {
            $NameList.Add( $_ )
        }
    }
    end {
        $NameList
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
            throw 'left off here'
        }
        function _processErrorRecord {
            throw 'left off here'
        }
    }
    process {
        if ($InputObject -is 'Exception') {
            _processException $InputObject
        }
        elseif ($InputObject -is 'ErrorRecord') {
            _processErrorRecord $InputObject
        }
        else {
            Write-Error -ea stop 'Input is not an Exception?' -Category InvalidType -ErrorId 'NotAnExceptionType' -TargetObject ($InputObject.GetType())
        }

        # if (!($InputObject -is 'Exception')) {

        $meta.Name = $_.GetType() | Format-TypeName -bra # future: logic in FormatData


        # Ensure it's a single line
        $Meta.String = $_.ToString() -split '\r?\n'
        | Join-String -sep $str.JoinNewline | ShortenString -MaxLength 120

        # refactor func

        $Meta.HasChildRecord = $false

        [pscustomobject]$meta

    }
}
