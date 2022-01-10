#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Invoke-Hexyl'
    )
    $experimentToExport.alias += @(
        'Out-Hexyl'
    )
}

function Invoke-Hexly {
    <#
    .synopsis
        minimal wrapper, does almost motji
    .description
       .
    .example
          .
    .outputs
          [string | None]

    #>

    <#
        format unicode strings, making them safe.
            Null is allowed for the user's conveinence.
            allowing null makes it easier for the user to pipe, like:
            'gc' without -raw or '-split' on newlines
        #>
    [Alias('Out-Hexyl')]
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 0, ValueFromPipeline)]
        # [AllowNull()]
        # [AllowEmptyCollection()]
        [AllowEmptyString()]
        [Parameter(
            # Mandatory,
            Position = 0, ValueFromPipeline)]
        [string]$InputText,


        [switch]$Help
    )
    begin {
        Write-Warning "Wip: $PSCommandPath"
    }
    process {


        if ($Help) {
            Invoke-NativeCommand 'hexyl' -Args @('--help')
            return
        }

    }
    end {
    }
}

if (! $experimentToExport) {
    # ...
    # Out-Hexyl -Help

}
