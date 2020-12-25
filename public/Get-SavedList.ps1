$_Config_SavedList = @{
    BasePath = Join-Path $Env:USERPROFILE -ChildPath '.dev-nin' 'SavedList'
    | Get-Item -ea Continue
}

# $_SavedList = @{}
# 'code-workspace' = Join-Path $_Config_SavedList -chi '.dev-nin' 'code-workspace.json'
# 'code-workspace' = Join-Path $_Config_SavedList -chi '.dev-nin' 'code-workspace.json'

function get_savedListPaths {
    # enumerate saved files
    Get-ChildItem $_Config_SavedList.BasePath -File *.json
    | ForEach-Object {
        $curItem = $_
        @{
            Label    = $curItem.Name
            FullName = $curItem
            Tags     = @()
        }
    }
}

[hashtable[]]$_SavedListPaths = get_savedListPaths

function Get-SavedList {
    <# a quick way to save a flat list of values #>
    param (
        # List Name
        [Parameter(Position = 0)]
        [String]$ListName
    )

    # $listNames = $_SavedListPaths | %{ $_.Name } .Keys | Sort-Object
    $AllNamesList = $_SavedListPaths.Name | Sort-Object
    if ($ListName -notin $AllNamesList) {
        H1 'SavedLists' #-fg grey40
        $AllNamesList
        return
    }

    H1 "selected: $ListName"
    $itemMetadata = $_SavedListPaths | Where-Object { $_.Name -Match $ListName }
    H1 'left off here:'
    $itemMetadata

    # $content = Get-Item $itemMetadata.Path -ea stop | Get-Content -Encoding utf8
    # $content
}


Get-SavedList
# Get-SavedList 'colors'

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
}
