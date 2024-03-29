function __getDirectChildFolders_old {
    <#
    .synopsis
        obsolete -> Ninmonkey.Console\Get-DirectChildItem (not actually used) Find all folders at a single depth ( direct descendant)
    .description
        sugar for:
            Get-ChildItem -Directory
            | ForEach-Object{ Get-ChildItem $_ -Directory }
    #>
    [OutputType('System.IO.DirectoryInfo ')]
    [cmdletbinding()]
    param(
        # root dir to search. maybe allow paths pipeled
        [parameter(Mandatory)]
        [string]$Path
    )
    process {
        Get-ChildItem -Directory -Force
        | ForEach-Object { Get-ChildItem $_ -Directory -Force }
    }
}
$PSCommandPath, 'Delete me -> kill dead' -join ' ' | Write-Warning
function __getAutoloadChildItem_old {
    <#
    .synopsis
        (not actually used) find child scripts to run, with common filters
    .example
        __getAutoloadChildItem_old -path 'public_autoloader'
    #>
    [cmdletbinding()]
    param(
        # root dir to search. maybe allow paths pipeled
        [parameter(Mandatory)]
        [string]$Path,
        # names that will be converted to regex-literalsregex literals
        [parameter()]
        [string[]]$ignoreNamesLiteral = @(
            '.visual_tests.ps1', '.Interactive.ps1',
            '__init__.ps1', '.tests.ps1'
        )
        # [parameter()]
        # [string[]]$ignoreNamesRegex = @()

    )
    begin {
        $ignoreNamesLiteral = $ignoreNamesLiteral | ForEach-Object { [regex]::Escape($_) }
    }
    process {

        $curPath = $Path
        $findAutoLoader_Splat = @{
            File   = $true
            Path   = Get-Item -ea stop $curPath
            Filter = '*.ps1'
            # recurse = $false
        }

        $filesQuery = Get-ChildItem @findAutoLoader_Splat
        $filteredQuery = $filesQuery
        | Where-Object {
            #future: filter as not directory? -File catches that
            $curFile = $_
            $match_tests = $ignoreNamesLiteral | ForEach-Object {
                $pattern = $_
                Write-Debug "test: '($curFile.Name)' -match '$pattern'"
                $curFile.Name -match $pattern
            }
            -not [bool](Test-Any $match_tests)
        }
        $filteredQuery

    }
    end {

    }
}


#     '__getAutoloadChildItem_old'
#     '__getDirectChildFolders_old'
# )

# if ($false) {
#     # autoloader: init: depth 1
#     # func: autoload self, depth 1:
#     __getDirectChildFolders_old -path '.' | Where-Object {
#         $curPath = $_
#         h1 $curPath | Write-Host
#         $maybeInit = Get-Item -ea ignore -Path (Join-Path $curPath '__init__.ps1')
#         if ( $MaybeInit ) {
#             return $true
#         }
#         return $true
#     }
# }

# # yell "auto loader wrapper WIP: '$PSCommandPath' "
