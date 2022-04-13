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
        '_fmt_FilepathForwardSlash'
        '_fmt_FilepathWithoutUsernamePrefix'
    )
    $experimentToExport.alias += @(

    )

    # # experiment: test whether functions are not matching
    # $funcNames = lsFunc -Path .\func_map_dump.ps1 | ForEach-Object Name
    # (lsFunc -Path .\func_map_dump.ps1 | ForEach-Object Name) | Where-Object {
    #     $z -notcontains $_
    # }
}

function _fmt_FilepathForwardSlash {
    <#
    .synopsis
        formats reverse slashes forward, if text, otherwise coerce
    .notes
        future: extend to fileinfo format type
        todo: move to functions
    .example

        PS> gi C:\nin_temp\.output\ | _fmt_FilepathForwardSlash

            C:/nin_temp/.output/

    #>
    param(
        # Object or path to map
        [Alias('PSPath', 'Path', 'FullName')]
        [Parameter(
            Mandatory, ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [object]$InputObject,

        # What to replace it with
        [Parameter(Position = 0)]
        [string]$ReplaceWith = '/'
    )
    process {
        $Render = $InputObject | ForEach-Object tostring
        $render -replace '\\', $ReplaceWith
    }
}
function _fmt_FilepathWithoutUsernamePrefix {
    <#
    .synopsis
        removes what is 'my document's  from filepath prefix
    .notes
        and skydrive, if possible
    .example

        PS> gi C:\nin_temp\.output\ | _fmt_FilepathForwardSlash

            C:/nin_temp/.output/

    #>
    param(
        # Object or path to map
        [Parameter(
            Mandatory, ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [object]$InputObject,

        # What to replace it with
        [Parameter(Position = 0)]
        [string]$ReplaceWith = '^'
    )
    process {
        # future: maybe Resolve-FileInfo, then It would
        # auto convert to Item if possible, or bad ?
        $renderPath = $InputObject | ForEach-Object Tostring
        $Re = @{}
        $Re['SkyDrive'] = [REgex]::Escape( (Join-Path $Env:UserProfile 'SkyDrive/documents/2021') )
        $re['UserProfile'] = [Regex]::Escape( $Env:UserProfile )

        $accum = $renderPath -replace $Re['SkyDrive'], $ReplaceWIth
        $accum = $accum -replace $Re['UserProfile'], $ReplaceWIth
        return $accum

        # $prefixUser =
        # # if ($fullPath -notmatch $prefixUser ) {
        # #     $prefixUser =
        # # }
        # $fullPath
        # $fullPath -replace $prefixUser, $ReplaceWIth
    }
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
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [Parameter(ValueFromPipeline, Position = 0, Mandatory)]
        $InputObject
    )
    process {
        if ($null -eq $InputObject) {
            return
        }

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
