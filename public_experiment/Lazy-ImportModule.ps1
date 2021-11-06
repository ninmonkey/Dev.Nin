if ($experimentToExport) {
    $experimentToExport.function += @(
        'Lazy-ImportModule'
        'Dump'
    )
    $experimentToExport.alias += @(        
        'LazyImport🐢'
    )
    #     }
         
}
# https://github.com/PowerShell/PSScriptAnalyzer#suppressing-rules

[hashtable]$__LazyImport ??= @{}

function Dump { 
    <#
    .synopsis
        just dump an object, to get an idea of the shape
    #>
    [cmdletbinding()]
    param(
        [Parameter(Position = 0, ValueFromPipeline, Mandatory)]
        $InputObject,

        [Parameter()]
        [uint]$depth = 3,

        [alias('jq')]
        [Parameter()]
        [switch]$WithJq
    )
    process {
        $converttoJsonSplat = @{
            Depth          = $depth
            EscapeHandling = 'EscapeHtml'
            AsArray        = $true
            EnumsAsStrings = $true
        }

        $json = $InputObject | ConvertTo-Json @converttoJsonSplat

        if (! $WithJq) {
            $json; return 
        }
            
        h1 '. | keys'
        
        $json
        | jq '. | keys'
        | Write-Color -fg gray80 -bg gray20
        
        h1 '.[0] | keys'        

        $json
        | jq '.[0] | keys'
        | Write-Color -fg gray80 -bg gray20    
    }
}
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
        todo:
            future
                - [ ] auto detect file locations based on this path:
                    Get-Module Dev.Nin | s RootModule, ModuleBase, Path | fl
    .example   
            PS> Verb-Noun -Options @{ Title='Other' }
        #>
    # [outputtype( [string[]] )]
    # [Alias('x')]
    
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '', Justification = 'Personal Profile may break')]
    [cmdletbinding()]
    param(
        # module[s] to import
        [Alias('InputObject')]
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string[]]$ModuleName, 
    
        # files to watch last modified time[s]
        [Parameter()]
        [string[]]$FileToWatch
    )
    begin {
        $state = $script:__LazyImport
        $ModuleName | ForEach-Object { 
            if (! $state.ContainsKey($_) ) {
                $state[ $_ ] = 0

            }
        }
    
        $moduleList = [list[object]]::new()
        $ModuleName | ForEach-Object {
            $moduleList.add( $_ )
        }
        # $moduleList.AddRange( $ModuleName )

        if ($FileToWatch.count -eq 0) {
            $FileToWatch = $PSCommandPath
        }
    }
    process {        
        # $InputObject | ForEach-Object { 
        #     $moduleList.Add( $_ )
        # }     
    }
    end {
        $moduleList | Str Csv -Sort
        | str Prefix 'ModuleNames =' | Write-Debug

        # $FileToWatch
        # | Get-Item | Format-RelativePath -BasePath $PSScriptRoot
        # | Str Csv -Sort | str Prefix 'FileToWatch =' | Write-Debug

        [bool]$ShouldLoad = $false
        $metaDebug = @{
            Names      = $moduleList | Str Csv -Sort
            Watch      = $FileToWatch | Str Csv -Sort
            WatchNames = $FileToWatch
            | Get-Item | Format-RelativePath -BasePath $PSScriptRoot
            | Str Csv -Sort
                
            ShouldLoad = $ShouldLoad 
        }
        $metaDebug | format-dict | wi

        $moduleList | Where-Object { $null -ne $_ } | ForEach-Object {
            $curModuleName = $_  
        
            $now = [datetime]::Now

            $root = Get-Module $curModuleName -ea Ignore | ForEach-Object ModuleBase
            | Get-Item -ea ignore

            Write-Color 'magenta' -t 'fast test?' | wi
            $fastTest = Get-ChildItem -File $root -d 3
            | Sort-Object LastModified -Descending -Top 2
            | wi

            $query = Get-ChildItem $FileToWatch
            $query_watched | ForEach-Object { 
                $curFile = $_
                

                if ($lastUpdate -lt $_.LastWriteTime) {
                    $ShouldLoad = $true
                    Write-Debug "'Cache: '$curModuleName' is out of date'"
                    
                    $now - $lastUpdate | ForEach-Object TotalMinutes | Join-String -FormatString 'TotalMinutes {0:n2} ago'
                    | Write-Information
                    return
                }
            }

            $metaDebug | format-dict | wi
            if ($ShouldLoad) {
                if (! $TestRun ) {
                    Import-Module -Name $ModuleName -Force -Verbose

                    $state[$curModuleName].LastImport = $now
                }
            }
        }
    }
}

if ($false -and !$experimentToExport) {
    # $PSCommandPath | Get-Item
    $lazyImportModuleSplat = @{
        # Debug             = $true
        ModuleName        = 'Dev.Nin'
        FileToWatch       = $PSCommandPath
        TestRun           = $true
        InformationAction = 'Continue'
    }

    # Lazy-ImportModule @lazyImportModuleSplat
    # hr
    
    # Lazy-ImportModule -Debug -Verbose -infa Continue -FileToWatch @($PSCommandPath) -ModuleName 'dev.nin'

}