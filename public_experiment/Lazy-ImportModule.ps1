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

[hashtable]$__LazyImport = @{}
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
        [string[]]$FileToWatch
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
    }
    process {        
        $InputObject | ForEach-Object { 
            $ModuleNames.Add( $_ )
        }    
    }
    end {
        $moduleNames | Str Csv -Sort | str Prefix 'ModuleNames =' | Write-Debug
        $FileToWatch | Str Csv -Sort | str Prefix 'FileToWatch =' | Write-Debug

        $moduleNames | ForEach-Object {
            $curName = $_ 
        
            [bool]$ShouldLoad = $false
        
        
            if ($ShouldLoad) {
                
                $now = [datetime]::Now
                Import-Module -Name $ModuleName -Force
            }
        }

    }
}

if (!$experimentToExport) {
    # $PSCommandPath | Get-Item
    Lazy-ImportModule -Debug -ModuleName 'Dev.Nin' -FileToWatch @($PSCommandPath)
    

}