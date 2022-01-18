#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Invoke-NativeDocFxCommand'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}


function Invoke-NativeDocFxCommand {
    <#
    .synopsis
        Stuff
    .description
        .

    #>
    [CmdletBinding()]
    param(
        # default commands
        [parameter(Position = 0)]
        [ArgumentCompletions('Build', 'Serve', 'ListProjects')]
        [string]$InputCommand,

        [parameter(Position = 1)]
        [string]$Arg1,



        # show some docs
        [switch]$Help

    )
    begin {
        $HelpText = @'
1] Build Docs:

    docfx init -q

2] Serve Docs

    docfx .\docfx_project\docfx.json --serve

3] View: http://localhost:8080

See More:
    - https://dotnet.github.io/docfx/tutorial/docfx_getting_started.html
    - https://github.com/dotnet/docfx

tools: DocLinkChecker, TocDocFxCreation, etc.
    - https://dotnet.github.io/docfx/templates-and-plugins/tools-dashboard.html
'@

    }
    process {
        # docfx "G:\2021-github-downloads\MicrosoftDocs📚\powerquery-docs📚\docfx_project\docfx.json" --serve
        function _enumerateProjects {
            # list nested projects
            param($Root = '.')

            $getChildItemSplat = @{
                Path    = $Root
                Recurse = $true
                Filter  = 'docfx.json'
            }
            Get-ChildItem @getChildItemSplat | To->RelativePath
        }
    }
    end {
        if ($Help) {
            return $helpText
        }

        switch ($InputCommand) {
            'Build' {
                Invoke-NativeCommand 'docfx' -args @(
                    'init',
                    '-q'
                )

            }
            'Serve' {
                $validNames = _enumerateProjects
                if ($validNames.count -eq 1) {
                    $Arg1 = Get-Item $ValidNames
                }

                $Arg1 | Label 'Project'

                if (!(Test-Path $Arg1)) {
                    write-color -f orange -t 'Select Project:'
                    _enumerateProjects
                    return
                }

                Start-Process 'http://localhost:8080'
                Write-Color -fg magenta -t 'http://localhost:8080'
                Invoke-NativeCommand 'docfx' -args @(
                    '.\docfx_project\docfx.json'
                    '--serve'
                )
                Write-Color -fg magenta -t 'http://localhost:8080'
            }
            'ListProjects' {
                _enumerateProjects
            }
            default {
                Write-Error "UnhandledCommand: '$InputCommand'" -ea stop
                return
            }
        }
    }

}

if (! $experimentToExport) {
    # ...
}
