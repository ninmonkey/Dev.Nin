$_Config_SavedList = @{
    BasePath = Join-Path $Env:USERPROFILE -ChildPath '.dev-nin' 'SavedList'
    | Get-Item -ea Continue
}

# $_SavedList = @{}
# 'code-workspace' = Join-Path $_Config_SavedList -chi '.dev-nin' 'code-workspace.json'
# 'code-workspace' = Join-Path $_Config_SavedList -chi '.dev-nin' 'code-workspace.json'

function get_savedListMetadata {
    # internal, enumerate saved files
    Get-ChildItem $_Config_SavedList.BasePath -File *.json
    | ForEach-Object {
        $curItem = $_
        @{
            Label    = $curItem.BaseName
            FullName = $curItem
            Tags     = @()
        }
    }
}

[hashtable[]]$_SavedListMetadata = get_savedListMetadata

function Get-SavedList {
    <#
    .synopsis
    a quick way to save a flat list of values / consistent JSON
    .notes
        todo: auto-complete -ListName using actual filenames /w a completer attribute
    .example
        # list all
        PS> Get-SavedList
    .example
        # select a specific list 1
        PS> Get-SavedList 'colors'
    .example
        # output types
        PS> Get-SavedList -PassThru 'colors'
        PS> Get-SavedList -AsObject 'colors'
    .example
        # Gui select using 'Fzf'
        PS> Get-SavedList | Out-Fzf | Get-SavedList
    .example
        # Gui select name using 'Fzf', then directly opening the file
        PS> $Fzf = Get-SavedList -Verbose -Debug | Out-Fzf
        PS> Get-SavedList $Fzf
    #>
    param (
        # List Name
        [Parameter(Position = 0, ValueFromPipeline)]
        [String]$ListName,

        # Do not change data, just pipe the raw text
        [Parameter()][switch]$PassThru,

        # also call ConvertFrom-Json
        [Parameter()][switch]$AsObject
    )

    # $listNames = $_SavedListMetadata | %{ $_.Name } .Keys | Sort-Object
    $AllNamesList = $_SavedListMetadata.Label | Sort-Object
    if ($ListName -notin $AllNamesList) {
        Write-Verbose "Name not found: '$ListName'"
        $AllNamesList
        return
    }

    "Selected: $ListName" | Write-Verbose

    $itemMetadata = $_SavedListMetadata | Where-Object { $_.Label -Match $ListName }

    # print raw, else -AsObject , else colored Json
    if ($PassThru) {
        Write-Debug 'Mode: -PassThru: raw text'
        Get-Item -ea stop $itemMetadata.FullName
        | Get-Content -Encoding utf8 -Raw
        return
    }

    $content = Get-Item -ea stop $itemMetadata.FullName
    | Get-Content -Encoding utf8

    if ($AsObject) {
        Write-Debug 'Mode: -AsObject: From Json'
        $content | ConvertFrom-Json
        return
    }

    # syntax highlight
    Write-Debug 'Pretty print/syntax highlight'
    $content | pygmentize.exe -l json
}




function Add-SavedList {
    <#
    .notes
        todo: validate changes with: 'Test-Json -Schema foo'
    #>
    param (
        # List Name
        [Parameter(Mandatory, Position = 0)]
        [String]$ListName,

        # Value
        [Parameter(Mandatory, Position = 1)]
        [object]$ParameterName
    )

    throw "nyi: Add-SavedList"
}
