#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_mapFormatProcessName'
        '_mapFormatShortName'
        '_mapStripNSPrefix'
        '_mapUri'
        '_mapUriQueryDict'
        '_mapUrlDecode'
        '_mapUrlEncode'
    )
    $experimentToExport.alias += @(

    )
}
function _mapStripNSPrefix {
    # strip namespace system  : 1-liner
    process {
        $_ -replace 'System\.', ''
    }
}

function _mapUri {
    # $obj => [uri] func mapping examples : 1-liner
    process {
        ForEach-Object { [uri]$_ }
    }
}
function _mapFormatShortName {
    <#
    .synopsis
        get type, and strip common prefixes. nothing else. nothing
    .example
        PS> (gi . ) | _mapFormatShortName
            'Hashtable' | _mapFormatShortName
    .link
        Ninmonkey.Console\Format-TypeName
    #>
    [outputType('System.String')]
    param(
        # pass any of these: [1] objects, [2] type instance, [3] typename as string
        [parameter(ValueFromPipeline, Position = 0, Mandatory)]$InputObject
    )
    process {
        # only use GetType() as the final test, otherwise types as string ex: 'hashtable' => string
        $tinfo = $InputObject -is 'type' ? $InputObject : $InputObject -as 'type'
        $tinfo ??= $InputObject.GetType()
        ($tinfo)?.FullName -replace 'System.Collections\.', '' -replace '^System\.', ''
    }
}

function _mapUriQueryDict {
    <#
        .synopsis
            inspect query string params as dict. It's more than [uri], sugar for parsing  ([uri]$url).Query to a dict
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
    # Decode html urls : 1-liner
    process {
        [System.Web.HttpUtility]::UrlDecode( $_ )
    }

}
function _mapUrlEncode {
    # encode html urls : 1-liner
    process {
        [System.Web.HttpUtility]::UrlEncode( $_ )
    }
}

function _mapFormatProcessName {
    <#
    .synopsis
        cleanup the [system.Diagnostics.Process]'s formatting for ToString()
    .description
        "System.Diagnostics.Process (explorer)" => "explorer"
    #>
    process {
        ForEach-Object {
            $_ -replace '^System.Diagnostics.Process ', '' -replace '[()]', ''
        }
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
    | ForEach-Object Name | Sort-Object -Unique | str csv -SingleQuote
    #| cl
}
