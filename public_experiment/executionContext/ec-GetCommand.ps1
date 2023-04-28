#Requires -Version 7
using namespace Management.Automation

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Ec-GetCommand'
    )
    $experimentToExport.alias += @(
        'Ec->GetCommand' # 'Ec-GetCommand'

    )
}

function Ec-GetCommand {
    <#
    .synopsis
        GetCommands from ExecutionContext sugar, mostly as a reference
    .description
        examples using ExecutionContext
        (sugar for ExecutionContext, mostly as a reference)
    .notes

    .example
        🐒>
    .outputs
          [string | None]

    #>
    [Alias(
        'ec->GetCommand'
    )]
    [CmdletBinding(PositionalBinding = $false)]
    param(

        # related info from  members or docs
        [Alias('RelatedInfo')]
        [Parameter()]
        [switch]$Help

    )

    begin {
        if ($Help) {
            h1 'enums'
            [CommandTypes] | Get-EnumInfo
            h1 'family'
            return $ExecutionContext.InvokeCommand | Fm *get*comm*
        }

    }
    process {

    }
    end {
    }
}