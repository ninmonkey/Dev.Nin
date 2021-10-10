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
    .description
       .Should assert behavior be default, or the exception?
       Maybe it depends on whether you pipe or not
    .example
          .
    .outputs
          [string | None]

    #>
    [Alias('OneOrNone', 'Assert-OneOrNone')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )

    begin {
        $InputItem = [System.Collections.Generic.List[object]]::new()
    }
    process {
        try {
            $InputItem.Add( $InputObject )
        }
        catch {
            // any uncaught exceptions bubble up
            $PSCmdlet.WriteError( $_ ) # with some information
        }
        # $InputObject | ForEach-Object {
        # $InputItem.Add( $_ )
        # }
    }
    end {
        if ($InputItem.count -eq 1) {
            $InputItem
            return
        }
        $errMessage = @"
InputItem Was not 1
NumItems: $($InputItem.count)
Summary: {0}
"@ -f @(
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
        return
    }
}
