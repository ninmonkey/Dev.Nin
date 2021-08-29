if (! $DebugInlineToggle ) {
    $experimentToExport.function += 'Find-ExampleModuleManifest'
    $experimentToExport.alias += 'ModuleMetadata', 'CheatSheet-ModuleManifest'
}

function Find-ExampleModuleManifest {
    <#
    .synopsis
        boilerplate module creation
    .description
        .
    .example
        PS> Find-ExampleModuleManifest
    .example
        PS> Find-ExampleModuleManifest -PassThru | ft -AutoSize

    .notes
    .outputs

    #>
    [alias('ModuleMetadata', 'CheatSheet-ModuleManifest')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # # Text to convert to a literal
        [Alias('Name')]
        [Parameter(Position = 0, ValueFromPipeline)]
        [string[]]$ModuleName = '*',


        [Alias('Mode')]
        [ValidateSet('All', 'Tags')]
        [Parameter()][string]$OutputMode = 'All',

        [Parameter()][switch]$PassThru
    )

    begin {
        function _modeAll {
            # get module metadata
            [cmdletbinding(PositionalBinding = $false)]
            param()
            Get-Module -Name $ModuleName | ForEach-Object {
                $wantedProps = 'tags', 'name', 'description', 'ProjectUri', 'IconUri', 'LicenseUri', 'RepositorySourceLocation', 'Version', 'CompanyName', 'Copyright', @{
                    'l' = 'TagsText' ; 'e' = {
                        $_.Tags | Sort-Object -Unique | Join-String -sep ', ' -SingleQuote -op 'Tags: '
                    }
                }
                $cur = $_
                if ( $PassThru) {
                    $cur
                    return
                }
                if (! $PassThru ) {
                    # $cur.Tags | Sort-Object -Unique | Join-String -sep ', ' -SingleQuote -op 'Tags: '

                    # $cur | Join-String Tags -op 'tags: ' -sep ', '
                    # hr
                }
                if (! $PassThru ) {
                    $cur | Select-Object -Prop $wantedProps | Format-List
                    Hr
                }
            }
        }
        function _modeTags {
            # get module metadata
            [cmdletbinding(PositionalBinding = $false)]
            param()
            Write-Warning 'nyi; tag'
        }

    }
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            'Tags' {
                _modeTags
                break
            }

            'All' {
                _modeAll
                break
            }
            '__AllParameterSets' {
                _modeAll
                break
            }

            default {
                throw "Unhandled ParameterSet: $($PSCmdlet.ParameterSetName)"
            }
        }
    }
    end {

    }
}

if ($DebugInlineToggle) {
    Find-ExampleModuleManifest pansies, classexplorer
}
