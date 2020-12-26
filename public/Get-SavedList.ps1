$_Config_SavedList = @{
    BasePath = Join-Path $Env:USERPROFILE -ChildPath '.dev-nin' 'SavedList'
    | Get-Item -ea Continue
}

# $_SavedList = @{}
function Get-SavedList {
    <#
    .synopsis
        this returns pure lists, unlike <Get-SavedData> which returns json structed data
    .description
        .
    .example
        PS>
    .notes
        .
    #>
    param (

    )
    begin {}
    process {
        $Filepath = Join-Path $_Config_SavedList.BasePath -chil 'Recent-Files-List.json'
        Get-Content -ea stop $Filepath
        | ConvertFrom-Json
    }
    end {}
}

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


function Add-SavedList {
    <#
    .notes
        todo: validate changes with: 'Test-Json -Schema foo'
    #>
    param (
        # List Name
        [Parameter(Mandatory, Position = 0)]
        [String]$ListName

        # # Value
        # [Parameter(Mandatory, Position = 1)]
        # [object]$ParameterName
    )

    $_SavedListMetadata
    # throw "nyi: Add-SavedList"
}
