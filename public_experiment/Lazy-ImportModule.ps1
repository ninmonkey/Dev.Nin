if ($experimentToExport) {
    $experimentToExport.function += @(
        'Lazy-ImportModule'
        'Dump'
        '_lazyImportIsStale'
    )
    $experimentToExport.alias += @(
        'LazyImport🐢'
        'jq_dump'
        '?LazyImport'
    )
    #     }

}
# https://github.com/PowerShell/PSScriptAnalyzer#suppressing-rules

[hashtable]$__LazyImport ??= @{}

<# original, working sketch: 
if( (gi $watchFile).LastWriteTime -gt $__lastImport ) { 
  'stale' | write-color 'orange'
  Import-Module Dev.Nin -Force ;
  $__lastImport = get-date
}#>
[hashtable]$script:__staleLazyImport ??= @{}

<#
    date round trip example
    $now | label now
$out = $now.ToString('o')
$out | label out

$round = [datetime]::ParseExact($out, 'o', $null)
#>
function _lazyImportIsStale {
    <#
    .synopsis
        minimal sketch test
    .example
        $target = gi 'c:\..\My_Github\Dev.Nin\public_experiment\_formatErrorSummary.ps1'
        if(?LazyImport -WatchFile $target) {
            Import-Module Dev.Nin -Force
        }
    #>
    [Alias(
        '?LazyImport'                
    )]
    [cmdletbinding()]
    param(
        # when this (single) file changes, consider it stale
        [Parameter(Mandatory, Position = 0)]
        $WatchFile

        # #Docstring
        # [Parameter()]
        # [validateset('Now', 'bySavedState')]
        # [string]$Mode,
    )
    begin {
        function __detectLazy_importState {
            # import to preserve state after reloading itself
            param()
            

            <#
                $now | label now  
                $out = $now.ToString('o')
                $out | label out

                $round = [datetime]::ParseExact($out, 'o', $null)
            #>
            
            
            Get-Content -Path 'temp:\lazy_state.json'
            | ConvertFrom-Json -AsHashtable
            | ForEach-Object getenumerator | ForEach-Object {
                [string]$KeyName = $_.Key ;
                $Value = $_.Value
                $state[ $KeyName ] = $Value
                # already is a datetime
                # $dateFromStr = [datetime]::ParseExact($Value, 'o', $null)
                # $state[ $KeyName ] = $dateFromStr
            }

            $state | format-dict | Out-String | wi 

            # foreach ($cur in $state.GetEnumerator()) {
            #     $dateStr = $cur.Value.tostring('o')
            #     $tempHash[ $cur.Key ] = $dateStr

            # }   
            # $tempHash | ConvertTo-Json | Set-Content -Path 'temp:\lazy_state.json'             
        }

        Write-Warning 'loses state on import, todo: save to json'
        $state = $script:__staleLazyImport
        $target = Get-Item -ea stop $WatchFile        
        [string]$KeyName = [string]$target.FullName
        if ($state.keys.count -eq 0) {
            __detectLazy_importState
        }
        $state[$KeyName] ??= 0
    }
    process {    
        function __detectLazy_exportState {
            # export to preserve state after reloading itself
            param()
            $tempHash = @{}
            foreach ($cur in $state.GetEnumerator()) {
                $dateStr = $cur.Value.tostring('o')
                $tempHash[ $cur.Key ] = $dateStr
            }   
            $tempHash | ConvertTo-Json | Set-Content -Path 'temp:\lazy_state.json'             
        }
        

        function __detectByState { 
            # works if it's watching a different module

            $lastLoadTime = $state[$KeyName]
            if ($target.LastWriteTime -gt $lastLoadTime) {                    
                @(
                    'stale: ' | write-color orange
                    $target.FullName | Join-String -SingleQuote  
                    ' ' 
                    @(
                    ($n2 - $n1).TotalSeconds.tostring('n0') 
                        ' secs ago'
                    ) | Write-Color gray80
                ) | Join-String
                | wi             
                $state[$KeyName] = Get-Date 
                
                __detectLazy_exportState
                $true; return
            }
        }

        



        
        __detectByState

        # # if(! $state.ContainsKey( $KeyName )) {
        # #     $state[ $KeyName ] = 0
        # # }
        # $lastImportTime
        # if ( (Get-Item $watchFile).LastWriteTime -gt $__lastImport ) { 
        #     'stale' | write-color 'orange' | wi 
        #     $__lastImport = Get-Date

        #     $true; return;
        # }
        $false; return;
    }
}

function Dump {
    <#
    .synopsis
        just dump an object, to get an idea of the shape
    #>
    [Alias('jq_dump')]
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
        [string[]]$FileToWatch,

        #don't actually run import-module
        [Parameter()]
        [switch]$TestOnly
    )
    begin {
        # next
        $state = $script:__LazyImport
        h1 'state'
        $state | format-dict
        $ModuleName | ForEach-Object {
            if (! $state.ContainsKey($_) ) {
                $state[ $_ ] = [datetime]0

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
            $query_watched = $query_watched
            $query_watched | ForEach-Object {
                $curFile = $_


                if ($lastUpdate -lt $curFile.LastWriteTime) {
                    $ShouldLoad = $true
                    Write-Debug "'Cache: '$curModuleName' is out of date'"

                    $now - $lastUpdate | ForEach-Object TotalMinutes | Join-String -FormatString 'TotalMinutes {0:n2} ago'
                    | Write-Information
                    return
                }
            }

            $importModuleSplat = @{
                Name  = $ModuleName
                Force = $true
                # Verbose = $true
            }
            $metaDebug += @{
                ShouldLoad_2 = $ShouldLoad
                TestOnly     = $ShouldLoad
                ModuleName   = $ModuleName
                now          = $now
                LastImport   = $state[$curModuleName].LastImport
            }
            $metaDebug | format-dict | wi
            if ($ShouldLoad) {
                if (! $TestOnly ) {

                    if ($false) {
                        Import-Module @importModuleSplat
                    }
                    $state[$curModuleName].LastImport = $now
                    $state | Format-Dict
                    $false; return # ei: $ShouldLoad
                }
            }
            $state | Format-Dict
            # $true
            $ShouldLoad; return;
        }
    }
}

if ($true -and !$experimentToExport) {
    # $PSCommandPath | Get-Item
    # $lazyImportModuleSplat = @{
    # Debug             = $true
    # ModuleName = 'Dev.Nin'
    # FileToWatch = $PSCommandPath
    # TestRun = $true
    # InformationAction = 'Continue'
    # $lazyImportModuleSplat | format-dict
    hr 5
    # h1 'before'
    # $isStale = Lazy-ImportModule -ModuleName dev.nin -infa Continue -Verbose -TestOnly -ea break
    # $isStale | str prefix 'stale?' | Write-Color white -bg cyan
    # $isStale = Lazy-ImportModule -ModuleName dev.nin -infa Continue -Verbose -TestOnly -ea break
    # $isStale | str prefix 'stale?' | Write-Color white -bg cyan
    # h1 'before'
    $isStale = Lazy-ImportModule -ModuleName dev.nin -infa Continue -Verbose -ea break
    $isStale | str prefix 'stale?' | Write-Color white -bg cyan
    $isStale = Lazy-ImportModule -ModuleName dev.nin -infa Continue -Verbose -ea break
    $isStale | str prefix 'stale?' | Write-Color white -bg cyan
    h1 'after'

}


# Lazy-ImportModule @lazyImportModuleSplat
# hr

# Lazy-ImportModule -Debug -Verbose -infa Continue -FileToWatch @($PSCommandPath) -ModuleName 'dev.nin'
