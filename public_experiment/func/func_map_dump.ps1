#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_mapStripNSPrefix'
        '_mapStripNSPrefix'
        '_mapUri'
        '_mapUriQueryDict'
        '_mapUrlDecode'
        '_mapUrlEncode'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}
function _mapStripNSPrefix {
    # from 1-liner func mapping examples
    process {
        $_ -replace 'System\.', ''
    }
}

function _mapUri {
    # from 1-liner func mapping examples
    process {
        ForEach-Object { [uri]$_ }
    }
}
function _mapUriQueryDict {
    <#
        .synopsis
            more than [uri], sugar for parsing  ([uri]$url).Query to a dict
    #>
    process {

        $uri = [uri]$_
        $hash = @{}

        $pairs = $uri.Query -replace '^\?', '' -split '&'

        $pairs | ForEach-Object {
            $k, $v = $_ -split '='
            $hash[$k] = $v
        }
        $hash

    }
}

function _mapUrlDecode {
    #  [en/de]code html urls
    process {
        [System.Web.HttpUtility]::UrlDecode( $_ )
    }
}
function _mapUrlEncode {
    #  [en/de]code html urls
    process {
        [System.Web.HttpUtility]::UrlEncode( $_ )
    }
}


if (! $experimentToExport) {
    # ...
    # 'https://docs.microsoft.com/en-us/search/?terms=cat&category=Documentation&expanded=%2Fdevrel%2Fe6f942e8-55a7-4c86-b8e3-7456508ea850&filter-products=power'
    # 'https://docs.microsoft.com/en-us/search/?terms=cat&category=Documentation&expanded=%2Fdevrel%2Fe6f942e8-55a7-4c86-b8e3-7456508ea850&products=%2Fdevrel%2Fe6f942e8-55a7-4c86-b8e3-7456508ea850'
    $samples = @(
        'https://docs.microsoft.com/en-us/search/?terms=cat&category=Documentation&expanded=%2Fdevrel%2Fe6f942e8-55a7-4c86-b8e3-7456508ea850&filter-products=power'
        'https://docs.microsoft.com/en-us/search/?terms=cat&category=Documentation&expanded=%2Fdevrel%2Fe6f942e8-55a7-4c866-b8e3-7456508ea850&products=%2Fdevrel%2Fe6f942e8-55a7-4c86-b8e3-7456508ea850'
    )


    h1 'map query to dict'
    $samples | _mapUriQueryDict

    h1 'misc'
    '%2Fdevrel%2Fe6f942e8-55a7-4c86-b8e3-7456508ea850' | _mapUrlDecode
    | label 'decode url'

    h1 'functions in script'
    lsFunc -Path 'C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin\public_experiment\func\func_map_dump.ps1' | ForEach-Object Name | Sort-Object -Unique

    h1 'functions in script (dynamic path)'
    lsfunc -Path $PSCommandPath
     | % Name | sort -Unique | str csv -SingleQuote
     #| cl
}
