#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Help->Topics'
        'Help->JsonSchema'
    )
    $experimentToExport.alias += @(
    )
}




# ${function:Help->Topic}
# New-Item -Name Help->JsonSchema -Value {
function Help->JsonSchema {
    <#
    future: create 'help <topic> instead of individual commands (at least user facing.)
    #>
    [alias('Help->JsonSchema')]
    [cmdletbinding()]
    param()

    @(
        'https://json-schema.org/learn/'
        'https://code.visualstudio.com/docs/languages/json'
        'https://json-schema.org/learn/getting-started-step-by-step'
        'https://json-schema.org/understanding-json-schema/'
    )
}

enum helpSourceKind {
    About
    Reference
    Example
    Cheatsheet
}

function Help->Topics {
    <#
    .synopsis
        Stuff
    .description
        .

    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # What kind?
        [Parameter(Position = 0)]
        [ValidateSet([helpSourceKind])]
        [string]$SourceKind
    )

    begin {
        function _findExamples {
            $cmds = @(
                'Example🔖-ModuleManifest'
                'Find-ExampleModuleManifest'
                '*example*' | Resolve-CommandName | Sort-Object -Unique Name
            )
            $Meta = @{
                CommandName = $cmds
            }
        }

    }
    process {
        switch ($SourceKind) {
            ([helpSourceKind]::Example) {
                $meta = _findExamples
                $meta; Return;

            }
            ([helpSourceKind]::Reference) {

            }
            ([helpSourceKind]::Cheatsheet) {

            }

            Default {
                throw "[HelpSourceKind] handler not found for '$SourceKind'"
            }
        }

    }
    end {
    }
}


if (! $experimentToExport) {
    # pester here
    [helpSourceKind] | Get-EnumInfo | ForEach-Object Name {
        Help->Topics -Kind ($_)

    }
    # Help->Topics ([helpSourceKind]::Example)
    # Help->Topics ([helpSourceKind]::Reference)
    # Help->Topics ([helpSourceKind]::Cheatsheet)


}