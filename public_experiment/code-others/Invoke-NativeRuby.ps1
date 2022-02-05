#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Invoke-NativeRubyCommand'
        'Invoke-NativeRubyRepl'
    )
    $experimentToExport.alias += @(
        # 'A'
        'Repl->Ruby'
    )
}

function Invoke-NativeRubyRepl {
    <#
        .synopsis
            minimal wrapper to run Ruby's REPL irb
        .notes
        #6 WIP
        .example
            PS> Invoke-NativeRubyRepl -Options @{ Title='Other' }
        #>
    [outputtype( [string] )]
    [Alias('Repl->Ruby')]
    [cmdletbinding()]
    param(
        # show help
        [switch]$Help,

        # docs
        # [Alias('y')]
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # extra options
        [Parameter()][hashtable]$Options
    )
    begin {

        [hashtable]$Config = @{
            # AlignKeyValuePairs = $true
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})
    }
    process {
        if ($Help) {
            @'
        print docs
        see: [1] ruby --help
             [2]  irb --help
'@
        }

    }
    end {
    }
}
function Invoke-NativeRubyCommand {
    <#
        .synopsis
            minimal wrapper to run Ruby
        .notes
            .
        .example
            PS> Invoke-NativeRubyCommand -Options @{ Title='Other' }
        #>
    [outputtype( [string] )]
    # [Alias('x')]
    [cmdletbinding()]
    param(
        # show help
        [switch]$Help,
        # docs
        # [Alias('y')]
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # extra options
        [Parameter()][hashtable]$Options
    )
    begin {
        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        [hashtable]$Config = @{
            # Title              = 'Default'
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})
    }
    process {
        if ($Help) {
            @'
        print docs
        see: [1] ruby --help
             [2]  irb --help
'@
        }
    }
    end {
    }
}

if (! $experimentToExport) {
    # ...
}
