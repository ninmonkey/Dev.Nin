#Requires -Version 7
if ($experimentToExport) {
    $experimentToExport.function += @(
        'Lazy-ImportModule'
    )
    $experimentToExport.alias += @(        
        'Invoke-LazyImport🐢'
    )
}
# https://github.com/PowerShell/PSScriptAnalyzer#suppressing-rules

[hashtable]$__LazyImport ??= @{}
function Lazy-ImportModule {
    <#
    .synopsis
        Load modules, if certain files have been modified 
    .description
        personal profile adds verb: Lazy        
    .notes
        .
        future:
            Invoke-Conditional
    .example   
            PS> Verb-Noun -Options @{ Title='Other' }
        #>
    # [outputtype( [string[]] )]
    # [Alias('x')]
    
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '', Justification = 'Personal Profile may break')]
    [Alias('Invoke-LazyImport🐢')]
    [cmdletbinding()]
    param(
        # module[s] to import
        [Alias('ModuleName')]
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string[]]$InputObject, 
    
        # files to watch last modified time[s]
        [Parameter()]
        [string[]]$FileToWatch,

        # only test, output states. Not a true -Whatif
        [Alias('WhatIf')]
        [Parameter()]
        [switch]$TestRun
    )
    begin {
        $state = $script:__LazyImport
        $InputObject | ForEach-Object { 
            if (! $state.ContainsKey($_) ) {
                $state[ $_ ] = @{
                    LastImport = [datetime]0
                }
            }
        }

        $State | ConvertTo-Json -Depth 1 | Write-Debug 
        $json = $State | ConvertTo-Json -Depth 1

        # $json | bat -P -l json --color=always
        $json | out-bat -Language json 
        | wi
        #     Write-Debug 'already have a cache func or not?'
        #     Write-Error -CategoryActivity NotImplemented -m 'NYI: wip: LazyInvokeScriptBlock'
        #     [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})       
        #     [hashtable]$Config = @{
        #         AlignKeyValuePairs = $true
        #         Title              = 'Default'
        #         DisplayTypeName    = $true
        #     }
        #     $Config = Join-Hashtable $Config ($Options ?? @{})        
    
        $moduleNames = [list[object]]::new()
        if ($FileToWatch.count -eq 0) {
            $FileToWatch = @($PSCommandPath)
        }
    }
    process {        
        $InputObject | ForEach-Object { 
            $ModuleNames.Add( $_ )
        }    
    }
    end {
        $moduleNames | Str Csv -Sort | str Prefix 'ModuleNames =' | Write-Debug
        $FileToWatch
        | Get-Item | Format-RelativePath -BasePath $PSScriptRoot
        | Str Csv -Sort | str Prefix 'FileToWatch =' | Write-Debug

        $moduleNames | ForEach-Object {
            $curModuleName = $_ 
        
            [bool]$ShouldLoad = $false
        
            $metaDebug = @{
                Names      = $moduleNames | Str Csv -Sort
                Watch      = $FileToWatch | Str Csv -Sort
                WatchNames = $FileToWatch
                | Get-Item | Format-RelativePath -BasePath $PSScriptRoot
                | Str Csv -Sort
                    
                ShouldLoad = $ShouldLoad
            }
            $query = Get-ChildItem $FileToWatch
            $query_watched | ForEach-Object { 
                $lastUpdate = $state[$curModuleName].LastImport
                if ($lastUpdate -lt $_.LastWriteTime) {
                    $ShouldLoad = $true
                    Write-Information 'Cache is out of date'
                    return
                }
            }

            $metaDebug | format-dict | wi
            if ($ShouldLoad) {
                $now = [datetime]::Now
                if (! $TestRun ) {
                    Import-Module -Name $ModuleName -Force
                    $state[$curModuleName].LastImport = $now
                }
            }
        }
    }
}

if (!$experimentToExport) {
    # $PSCommandPath | Get-Item
    $lazyImportModuleSplat = @{
        # Debug             = $true
        InputObject       = 'Dev.Nin'
        FileToWatch       = @($PSCommandPath)
        TestRun           = $true
        InformationAction = 'Continue'
    }

    Lazy-ImportModule @lazyImportModuleSplat
    

}