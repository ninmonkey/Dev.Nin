using namespace System.Collections.Generic

function _maybePath {
    <#
    .synopsis
        without errors: tries to return Get-Item, otherwise original
    .outputs
        [System.IO.FileSystemInfo] else [System.String]
    #>
    param(
        # Parameter help description
        [Parameter(Mandatory, Position = 0)]
        [string]$Path
    )
    process {
        (Get-Item $Path -ea Ignore) ?? $Path
    }
}

function New-EverythingSearchTerm {
    <#
    .synopsis
        Generates single items for the full query 'Invoke-EverythingSearch'
    .description
        currently allows invalid filepaths on purpose
    .link
        Invoke-EverythingSearch

    #>
    [CmdletBinding()]
    param (
        # SearchType: Enum
        <#
            todo: create enum

        whenEnumType = datemodified|datecreated
        timeEnum = Enum = today/this/year/day/etc

        #>
        [Alias('Type')]
        [Parameter(Mandatory, Position = 0)]
        [ValidateSet('Path', 'Path:ww')] # tooltip 'path:ww:stuff'
        $TermType,

        # Value
        [Parameter()]
        [string]$Path
    )

    begin {
        $TermTemplate = @{
            'Path:ww' = @'
path:ww:"{0}"
'@
            'Path'    = @'
path:"{0}"
'@
        }
    }

    process {
        switch ($TermType) {
            'FullPath' {
                $TermTemplate.'Path:ww' -f (_maybePath $Path)
                break
            }
            Default {
                throw "UnhandledType: '$TermType'"
            }
        }
    }

    end {

    }
}

function Invoke-EverythingSearch {
    <#
    .synopsis
        Everything search: <https://www.voidtools.com/support/everything/searching/>
    .description
        - aliases try to line up with the official aliases
        - requires the 'es:' protocol to be enabled
    .example
        PS> SearchEvery -dm last3weeks
    .example
        SearchEvery -dm last3weeks path:ww:c:\
        PS> SearchEvery -WhatIf -InformationAction Continue -dm last3weeks -Extension 'ps1', 'md'
        PS> SearchEvery -dm last3weeks -Extension 'ps1', 'md'
    .link
        New-EverythingSearchTerm
    #>
    [alias('SearchEvery', 'eSearch')]
    [cmdletbinding(PositionalBinding = $false)]
    param(
        # Extension
        [Parameter()]
        [Alias('Ext')]
        [string[]]$Extension = @(
            'pbix'
            'pq'
            'ps1'
            'md'
            'png'
            'json'
        ),
        # WhatIf
        [Parameter()][switch]$WhatIf,

        # Today
        [Parameter()]
        [switch]$Today,

        # DateModified : Future: [object] so actual [datetime] can be passed, too
        [Parameter()]
        [Alias('dm')]
        [string]$DateModified,

        # Path
        [Parameter()]
        [Alias('Path')]
        [string]$WholePath,

        # RemainingArgs
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$RemainingArgs

    )
    begin {
        $Extension = $Extension | Sort-Object -Unique
        $Config = @{
            ImplicitlyWrapQueries = $false
            <#
            makes things safer, preventing accidental and/or mixups when dynamic and nested

            arg1
                = ext:ps1 | dm:today
            arg2
                = 'ext:pq'

            operator: OR

            wrapped:
                (ext:ps1 | dm:today) | ext:pq

            not:
                ext:ps1 | dm:today | ext:pq
            #>

        }

        $queryTerms = [list[string]]::new()

        $OperatorStr = @{
            Or  = ' | '
            And = ' '
        }
    }
    process {
        <#
        polyfill/fallback
        $extQuery = $Extension -join ';'
        $argExtensions = 'ext:{0}' -f $extQuery
        #>

        function _naiveWay {
            $queryExt = $Extension |  Join-String -sep ';' -op 'ext:'
            $queryDm = 'dm:{0}' -f 'today'
            Br | Write-Information
            $queryExt, $queryDm | Label 'term' -fg orange
            | Write-Information


            $joinedQuery = $queryExt, $queryDm | Join-String -sep ' ' -op 'es:'

            if ($Today) {
                $joinedQuery = $joinedQuery, 'dm:today' | Join-String -sep ' '
            }


        }

        if ($WholePath) {
            $query_path_ww = 'path:ww:"{0}"' -f (
                _maybePath $WholePath
            ) | ForEach-Object ToString
            $queryTerms.Add( $query_path_ww )
        }



        if ($DateModified) {
            $queryDm = 'dm:{0}' -f $DateModified
            $queryTerms.Add( $queryDm )
        }
        if ($Today) {
            $queryTerms.Add( 'dm:today' )
        }



        Label 'Final Query' -e Ignore $joinedQuery | Write-Information
        function _validateUri {
            param( [string]$Uri )
            if ($joinedQuery -notmatch '^es:') {
                'Failed syntax, prefix is not "es:"', $joinedQuery -join ' ' | Write-Error
                return
            }
        }

        if ( ! ([string]::IsNullOrWhiteSpace( $Extension ))) {
            $queryExtString = $Extension |  Join-String -sep ';' -op 'ext:'
            $queryTerms.Add( $queryExtString )
        }
        if ($RemainingArgs) {
            $queryTerms.Add( $RemainingArgs )
        }


        $splat_joinTerms = @{
            Separator    = $OperatorStr.And
            OutputPrefix = 'es:'
        }

        $joinedQuery = $queryTerms | Join-String @splat_joinTerms
        _validateUri $joinedQuery


        if ($WhatIf) {
            $joinedQuery
            return
        }

        Start-Process $joinedQuery

    }
}
#     process {
#     ) | Sort-Object -Unique
# }

# $argExtensions | Write-Debug


# Invoke-EverythingSearch -Debug -WhatIf -InformationAction Continue
# Invoke-EverythingSearch -Debug -InformationAction Continue
# {
#     H1 'or Everything.exe'
#     $query = 'es:dm:{0} ext:{1}' -f @(
#         'today'
#         'pbix'
#     )
#     # Start-Process 'es:dm:today ext:pbix'
#     Start-Process $query

#     $parents | Join-String -Separator ', ' -SingleQuote
#     | Label 'parents'

# }