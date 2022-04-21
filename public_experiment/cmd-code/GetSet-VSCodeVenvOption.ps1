#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Set-VSCodeVenvOption'
        'Get-VSCodeVenvOption'
    )
    $experimentToExport.alias += @(

    )
}
#  #1 : refactor to update-hashtable
$script:__code_venvState = @{
    ConfigRoot = '~/.dev-nin/'
}


# $__code_venvState = Ninmonkey.Console\Join-Hashtable $__code_venvState @{
#     ConfigDirPrefix = Join-Path $__code_venvState['ConfigRoot'] 'vscode'
# }

$script:__code_venvState['ConfigDirPrefix'] = Join-Path $__code_venvState['ConfigRoot'] 'vscode'

# mkdir ~/.dev-nin/vscode/ -Force | Out-Null
try {
    mkdir $__code_venvState.ConfigDirPrefix -Force # | Out-Null
} catch {
    Write-Warning "error creating path: '$_' from '$PSCommandPath'"
}

$__code_venvState = Ninmonkey.Console\Join-Hashtable $__code_venvState @{
    ConfigVenvOption = Join-Path $__code_venvState.ConfigDirPrefix 'code-venv-option.json'
}

class VSCodeVenvOption {
    [string]$DefaultBinPath
    [string]$DefaultDataDir
    [string]$DefaultExtensionDir
}
# code.cmd --user-data-dir 'J:\vscode_datadir\code-dev\'  --extensions-dir 'J:\vscode_datadir\code-dev-addons\' -m '.' #-n -g -

#  | To->Json | From->Json

function Set-VSCodeVenvOption {
    <#
    .synopsis
        quick hack: save metadat . #6
    .notes
        future could be one command
            venv-config <set|get> [key] [value]
    .example
        Set-VSCodeVenvOption @{DefaultBinPath='code-insiders.cmd'}
    .example
        # bypass hashtable requirement
        $h = $newConf | New-HashtableFromObject
        Set-VSCodeVenvOption $h

    #>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        # [hashtable]$ConfigOption
        [object]$ConfigOption
    )

    <# #6
    $ConfigOption -is 'VSCodeVenvOption'
        may fail cause type doesn't exist, in the global scope
    #>
    if ($ConfigOption.GetType().FullName -eq 'VSCodeVenvOption') {
        $UpdateMode = 'Direct'
    }

    if ($ConfigOption -is 'hashtable') {
        $UpdateMode = 'PartialMerge'
    } elseif ( $ConfigOption -is 'VSCodeVenvOption') {
        $UpdateMode = 'Direct'
    } else {
        throw "UnhandledType: $($ConfigOption.GetType().Name)"
    }

    function __directUpdate {
        <#
        .synopsis
            update from an [VSCodeVenvOption]
        #>
        if ($ConfigOption -isnot 'VSCodeVenvOption') {
            Write-Warning "ExpectedType: '[VSCodeVenvOption]'"
        }
        $curConfig = $ConfigOption
        $curConfig
    }
    function __partialOptionsUpdate {
        <#
        .synopsis
            update from a hashtable of valid options
        #>
        [VSCodeVenvOption]$curConfig = Get-VSCodeVenvOption
        $curConfig | Format-Table | Out-String
        # | str prefix 'prev config'
        | Write-Debug

        $validKeys = @('DefaultBinPath', 'DefaultDataDir', 'DefaultExtensionDir')
        # or
        # $ValidKeys = $curConfig | Iter->PropName
        #Refactor: update-hashtable or update-object
        $ConfigOption.GetEnumerator() | ForEach-Object {
            $Key = $_.Key ; $Value = $_.Value
            if ($Key -notin $validKeys ) {
                Write-Error "Invalid KeyName: '$Key'. Expected: $($validKeys -join ', ' )"
                return
            }
            $curConfig.$Key = $Value
        }


        $curConfig | Format-Table | Out-String
        # | str prefix 'new config'
        | Write-Debug
        $curConfig

    }

    switch ($UpdateMode) {
        'PartialMerge' {
            __partialOptionsUpdate
        }
        'Direct' {
            __directUpdate
        }
        default {
            throw "unhandled mode: '$UpdateMode'"
        }
    }

    'Writing to: "{0}"' -f @($__code_venvState.ConfigVenvOption) | Write-Verbose
    $curConfig | To->Json -EnumsAsStrings -ea stop | Sc -path $__code_venvState.ConfigVenvOption

    Get-Content $__code_venvState.ConfigVenvOption | bat -l json | Write-Host
}

function Get-VSCodeVenvOption {
    <#
    .synopsis
        quick hack: save metadat
    #>
    [OutputType([VSCodeVenvOption])]
    [cmdletbinding()]
    param(
        # force defaults
        [switch]$Reset
    )

    $defaultConfig = [VSCodeVenvOption]@{
        DefaultBinPath      = 'code.cmd'
        DefaultDataDir      = 'J:\vscode_datadir\code-dev\'
        DefaultExtensionDir = 'J:\vscode_datadir\code-dev-addons\'
    }

    if ($reset ) {
        return $defaultConfig
    }

    'Config file: "{0}"' -f @($__code_venvState.ConfigVenvOption) | Write-Verbose
    try {

        $curConfig = Get-Content (Get-Item $__code_venvState.ConfigVenvOption)
        | From->Json

    } catch {
        Write-Error -ea continue $_
        $curConfig = $defaultConfig
    }
    $curCOnfig
}

# Write-Warning 'need: abstract, minimal, nested config class for arbitrary data to json store'

if (! $experimentToExport) {
    # ...

    # ls .
}
