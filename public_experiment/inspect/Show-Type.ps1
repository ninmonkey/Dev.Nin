#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Show-Type'
    )
    $experimentToExport.alias += @(
        'Show->Type', 'st'
    )
}

function Show-Type {
    <#
        .synopsis
            .visualize types?
        .description
            .visualize types?
        .notes
            .
        .example
            PS> Verb-Noun -Options @{ Title='Other' }
        #>
    # [outputtype( [string[]] )]
    [Alias(
        'Show->Type',
        'st'

    )]
    [cmdletbinding()]
    param(
        # docs
        # [Alias('y')]
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # extra options
        [Parameter()][hashtable]$Options,

        [Parameter()]
        [validateSet('List', 'Csv')]
        [string]$OutputFormat = 'List'
    )
    begin {
        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        $clist = '#6a9955', '#569cd6', '#666666', '#2472c8'
        [hashtable]$Config = @{
            'showMemberTypeName' = $true
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})
        $config = Join-Hashtable $Config @{
            'color.listHead' = $clist[0]
            'color.csvHead'  = $clist[1]
        }

    }
    process {
        $target = $InputObject

        $h1 = if ($target -is 'type') {
            $target.FullName
        } else {
            $target.GetType().FullName
        }

        $h1 = $h1 | Join-String -op '[' -os ']'
        h1 $h1 -After 1
        $props = $target | Fm -MemberType Property * -Force

        switch ($OutputFormat) {
            'Csv' {
                'Properties' | Write-Color -fg $config.'color.csvHead'
                $props | ForEach-Object Name | Str csv -sep ' ' -Sort -Unique
            }
            'List' {
                $props | ForEach-Object Name | Str ul -Sort -Unique
                | str prefix ('Properties' | Write-Color -fg $Config.'color.listHead')
            }
            default {
                throw "Unhandled OutputFormat; '$OutputFormat'"
            }
        }
    }
    end {
    }
}


if (! $experimentToExport) {
    # ...
}