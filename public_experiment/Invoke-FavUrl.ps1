$experimentToExport.function += 'Invoke-FavUrlQuery'
$experimentToExport.alias += @('favWebSearch', 'favUrl')


function Get-FavWebItem {
    # Used to complete param1 of 'Invoke-FavUrlQuery'
    [CmdletBinding()]
    param()
    Get-ModuleMetadatata -Key 'FavUrl'
}

function Get-ValidFavWebItemName {
    Get-ModuleMetadatata -Key 'FavUrl' | ForEach-Object Label
}

function Invoke-FavUrlQuery {
    <#
    .synopsis
        convert [string] to a paste-able Pwsh 7 text literal
    .description
        Desc
    .example
        PS> $sample = '🐒‍Business'
            "`u{1f412}`u{200d}`u{42}`u{75}`u{73}`u{69}`u{6e}`u{65}`u{73}`u{73}"

            Notice the ZWJ char between Monkey and "B"
    .outputs
        [string]

    #>
    [alias('favUrl', 'favWebSearch')]
    [CmdletBinding(PositionalBinding = $false, DefaultParameterSetName = 'WebQuery')]
    param(
        # Label name to use
        [Parameter(Mandatory, ParameterSetName = 'WebQuery', Position = 0)]
        [String]$Name,

        # Input as a string
        [Parameter(Position = 1, ValueFromPipeline)]
        [String[]]$QueryString,


        # PassThru
        [Parameter()][switch]$PassThru,
        # List Keys
        [Parameter(
            ParameterSetName = 'ListOnly'
        )][switch]$List
    )

    begin {
        $SavedList = $script:__savedListStore
        Write-Warning '
Not finished. Cleanup: <C:\Users\cppmo_000\Documents\2021\Powershell\buffer\2021-08\Invoke-FavUrl-prototype.ps1>'
    }
    process {
        function _logIt {
            param([Parameter(Mandatory)][hashtable]$InputObject)
            $InputObject | Format-HashTable | Write-Information
        }
        $debugInfo = @{
            ParameterSetName = $PSCmdlet.ParameterSetName
        }
        # $PSCMle
        if ($PSCmdlet.ParameterSetName -eq 'ListOnly') {
            Get-FavWebItem
            _logIt $debugInfo
            return
        }
        $urimeta = $SavedList | Where-Object Label -EQ $Name | Select-Object -First 1

        $debugInfo = @{
            ParameterSetName = $PSCmdlet.ParameterSetName

        }

        if (
            ($urimeta.count -eq 0) -or
            [string]::IsNullOrWhiteSpace($Name) -or
            [string]::IsNullOrWhiteSpace($QueryString)
        ) {

            $SavedList.Label
            | Join-String -op 'No matches found. Valid keys: ' -sep ', '
            _logIt $debugInfo
            return
        }


        $FinalUrl = $urimeta.UrlTemplate -replace '<<q1>>', @($QueryString)[0]
        $debugMeta = $FinalUrl
        Write-Information "Url: '$FinalUrl'"
        _logIt $debugInfo
        if ($PassThru) {
            $FinalUrl
        } else {
            Start-Process $FinalUrl
        }
    }
    end {}
}
