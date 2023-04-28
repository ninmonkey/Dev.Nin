#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Find-DefinedTypeData'
    )
    $experimentToExport.alias += @(
        'Dev->FindTypeData' # 'Find-DefinedTypeData'


    )
}
function Find-DefinedTypeData {
    <#
        .synopsis
            .
        .notes
            .
        .example
            PS> Verb-Noun -Options @{ Title='Other' }
        #>
    # [outputtype( [string[]] )]
    [Alias('Dev->FindTypeData')]
    [cmdletbinding()]
    param(
        # docs
        # [Alias('y')]
        # [parameter()]
        # Mandatory, Position = 0, ValueFromPipeline)]
        # [object]$InputObject

        # # extra options
        [Parameter()][hashtable]$Options
    )
    begin {
        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        $ignoreSplat = @{ 'ErrorAction' = 'Ignore' }
        [hashtable]$Config = @{
            IncludePath = @(
                Get-Item @ignoreSplat $PSHOME
                Get-Item @ignoreSplat 'G:\2021-github-downloads\dotfiles\SeeminglyScience'
                Get-Item @ignoreSplat "${Env:UserProfile}\skydrive\Documents\PowerShell\Modules"
            )
                    #todo: try
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})

        $Config | Write-Debug
    }
    process {
        foreach ($path in $Config.IncludePath) {
            Get-ChildItem -Path $path -Recurse -Force *.ps1xml
        }
    }
    end {
    }
}

if (! $experimentToExport) {
    # ...
}
