$experimentToExport.function += 'Format-UniqueStringListPipeline'
$experimentToExport.alias += 'strDistinctFromPipe'
$experimentToExport.meta += @{
    Enable                            = $false
    Tags                              = 'WIP', 'Todo'
    'Format-UniqueStringListPipeline' = 'WIP'
    Filename                          = $myinvocation.MyCommand.Name.split('.')[0]
    Obj                               = $myinvocation
}

# $SCRIPT:__PesterFunctionName = $myinvocation.MyCommand.Name.split('.')[0]

function Format-UniqueStringListPipeline {
    <#
    .synopsis
        reads clipboard, distinct sort, writes to clipboard
    .description
        When you have a list of text, you need to make sure it's sorted and distinct
    .example
        PS>

        copyh:
        Format-UniqueStringListPipeline
    .notes
        .
    #>
    [Alias('StrDistinct')]
    [CmdletBinding(
        PositionalBinding = $false
    )]
    # DefaultParameterSetName='Source_Clipboard')]
    param (
        <#
        Diagnostics.CodeAnalysis.AllowNullAttribute
        Diagnostics.CodeAnalysis.DisallowNullAttribute
        Management.Automation.AllowEmptyCollectionAttribute
        Management.Automation.AllowEmptyStringAttribute
        Management.Automation.AllowNullAttribute
        Runtime.InteropServices.AllowReversePInvokeCallsAttribute
        Security.AllowPartiallyTrustedCallersAttribute
        Windows.Foundation.Metadata.AllowForWebAttribute
        Windows.Foundation.Metadata.AllowMultipleAttribute
#>
        # I don't know if I need all of these. mainly it prevents errors
        # when the user pipes text with empty lines
        # [AllowEmptyCollectionAttribute()]

        # [AllowEmptyStringAttribute()]
        # [AllowNullAttribute()]
        [alias('Text')]
        [Parameter(
            Mandatory, ParameterSetName = 'Source_Pipe',
            Position = 0, ValueFromPipeline)]
        [string[]]$InputText,

        # PassThru: Writes to console instead
        [Parameter()][switch]$PassThru
    )
    begin {
        $TextFromParam = [list[string]]::new()
        Write-Warning 'NYI'
    }
    process {
        switch ($PSCmdlet.ParameterSetName) {
            'Source_Pipe' {
                $TextFromParam.add($InputText)
                break
            }

            default {
                throw "Unhandled ParameterSet: $($PSCmdlet.ParameterSetName)"
            }
        }


    }
    end {
        switch ($PSCmdlet.ParameterSetName) {
            'Source_Pipe' {
                $Source = $TextFromParam
                break
            }
            default {
                $Source = (Get-Clipboard)
                Write-Debug 'Using Clipboard: '
                $Source | Write-Debug
                break
            }
        }

        $InputLines = $Source -split '\r?\n'
        $distinctList = $InputLines | Sort-Object -Unique
        Write-Debug "Input: $($InputLines.count) lines"
        Write-Debug "Output: $($distinctList.count) lines"

        if ($PassThru) {
            $distinctList | Join-String "`n"
            return
        }
        Write-Information 'Wrote to Clipboard'
        $distinctList | Join-String -sep "`n" | Set-Clipboard

    }
}
