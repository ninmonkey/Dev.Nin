# using namespace System.Collections.Generic
# # using namespace Management.Automation

$experimentToExport.function += @(
    'Test-OneOrNone'
)
$experimentToExport.alias += @(
    'OneOrNone', 'Assert-OneOrNone'
)
# $experimentToExport.update_typeDataScriptBlock += @(
#     {
#         Update-TypeData -TypeName 'Nin.NumericTypeInfo'  -DefaultDisplayPropertySet @(
#             'Name', 'Type', 'MaxValue', 'MinValue'
#         ) -Force
#     }
# )


function Test-OneOrNone {
    <#
    .synopsis
        If the pipeline consumes exactly 1 item, continue, else stop
        Test if there's exactly one or zero matches, optionally pipeline if valid
    .description
        returns bool

        if -PassThru is used, it instead is used as a filter
            outputting the $null or one $item

       .Should assert behavior be default, or the exception?
       Maybe it depends on whether you pipe or not
    .notes
        Conflicted on whether Test- or Assert-
        and whether
    .example
          .
    .outputs
          [string | None]

    #>
    [OutputType([bool], [object])]
    [Alias('OneOrNone', 'Assert-OneOrNone')]
    [CmdletBinding(PositionalBinding = $false)]
    param(

        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # Now even empty will error
        [Alias('OneOnly')]

        [switch]
        $DisallowNull,

        [Alias('AsFilter')]
        [switch]
        $PassThru
    )

    begin {
        $InputItem = [System.Collections.Generic.List[object]]::new()
    }
    process {
        try {
            $InputItem.Add( $InputObject )
        }
        catch {
            # // any uncaught exceptions bubble up
            $PSCmdlet.WriteError( $_ ) # with some information
        }
        # $InputObject | ForEach-Object {
        # $InputItem.Add( $_ )
        # }
    }
    end {
        # if not passthru, [bool] only mode
        [bool]$isValid_OneOrNone = [bool](@(0, 1) -contains $InputItem.count)
        [bool]$isValid_One = [bool]($InputItem.count -eq 1)
        [bool]$isValid = $DisallowNull ? $isValid_One : $isValid_OneOrNone

        # No PassThru means only return [bool]
        if (! $PassThru) {
            [bool]$isValid
            return
        }

        # PassThru: Item, otherwise
        if ($IsValid) {
            $InputItem
            return
        }
        $errMessage = "
            InputItem faile on: ... | OneOrNone -DisallowNull:${DisallowNull}
            NumItems: $($InputItem.count)
            Summary: {0}
        " -f @(
            $InputItem | Dev.Join-StringStyle -JoinStyle QuotedList | Join-String
        )
        # $PSCmdlet.ThrowTerminatingError
        $writeErrorSplat = @{
            # ErrorAction = 'stop'
            Category = 'InvalidArgument'
            Message  = $errMessage
        }

        Write-Error @writeErrorSplat


        # $PSCmdlet.ThrowTerminatingError(
        #     [ErrorRecord]::new(
        #         [InvalidOperationException]::new('More than 1 Input from the pipeline', $_.Exception),
        #         'OneOrNone',
        #         'InvalidData',
        #         $InputItem))

    }
}
