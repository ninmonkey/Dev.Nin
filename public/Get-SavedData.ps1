$_Config_SavedData = @{
    BasePath = Join-Path $Env:USERPROFILE -ChildPath '.dev-nin' 'SavedData'
    | Get-Item -ea Continue
}

# $_SavedList = @{}
# 'code-workspace' = Join-Path $_Config_SavedData -chi '.dev-nin' 'code-workspace.json'
# 'code-workspace' = Join-Path $_Config_SavedData -chi '.dev-nin' 'code-workspace.json'

function get_savedDataMetadata {
    # internal, enumerate saved files
    Get-ChildItem $_Config_SavedData.BasePath -File *.json
    | ForEach-Object {
        $curItem = $_
        @{
            Label    = $curItem.BaseName
            FullName = $curItem
            Tags     = @()
        }
    }
}

[hashtable[]]$_SavedDataMetadata = get_savedDataMetadata

function Get-SavedData {
    <#
    .synopsis
    a quick way to save a flat list of values / consistent JSON
    .notes
        todo: auto-complete -ListName using actual filenames /w a completer attribute

        This saves json unlike 'Get-SavedItemList' which saves an actual flat list
    .example
        # list all
        PS> Get-SavedData
    .example
        # select a specific list 1
        PS> Get-SavedData 'colors'
    .example
        # output types
        PS> Get-SavedData -PassThru 'colors'
        PS> Get-SavedData -AsObject 'colors'
    .example
        # Gui select using 'Fzf'
        PS> Get-SavedData | Out-Fzf | Get-SavedData
    .example
        # Gui select name using 'Fzf', then directly opening the file
        PS> $Fzf = Get-SavedData -Verbose -Debug | Out-Fzf
        PS> Get-SavedData $Fzf
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

    # $listNames = $_SavedDataMetadata | %{ $_.Name } .Keys | Sort-Object
    $AllNamesList = $_SavedDataMetadata.Label | Sort-Object
    if ($ListName -notin $AllNamesList) {
        Write-Verbose "Name not found: '$ListName'"
        $AllNamesList
        return
    }

    "Selected: $ListName" | Write-Verbose

    $itemMetadata = $_SavedDataMetadata | Where-Object { $_.Label -Match $ListName }

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




function Add-SavedData {
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

    throw "nyi: Add-SavedData"
}
