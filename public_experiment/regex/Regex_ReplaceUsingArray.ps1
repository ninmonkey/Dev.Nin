#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(

    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

function RegexReplaceArray {
    <#
    .synopsis
        transforms using a list of (key -> value) pairs
    .description
        ..
    .notes
        future:
            use a struct type record instead
    .example
        $Replacements = @(
            , ('-', '─')
            , ('\', '└')
            , ('-', '─')
            , ('|', '│')
            , ('+', '├')
        )
    .outputs

    #>
    [Alias('RegexReplaceArray')]
    [CmdletBinding(PositionalBinding = $false)]
    param(

    )

    begin {
    }
    process {
        Write-Error -Category NotImplemented 'wip: nyi'

        # todo: always wrap CmdletExceptionWrapper: From Sci
    }
    end {
    }
}

if ($false) {

    # $newItemSplat = @{
    #     ItemType = 'Directory'
    #     Path     = $PSScriptRoot
    #     Name     = '.output'

    #     # Force    = $true
    # }

    # New-Item @newItemSplat -ea Ignore

    # & {
    # a list of literals, not patterns, to replace

    <#
        Volume serial nu
    G:\2021-GITHUB-D
    ├───gist
    │   ├───Indented
    │   │   ├───Conv
    │   │   ├───Conv
    │   │   ├───Conv
    │   │   ├───Expo
    │   │   ├───Get-
    │   │   ├───Get-
    │   │   ├───Get-
    │   │   ├───Get-
    │   │   ├───Invo
    │   │   ├───Meas
    │   │   └───Wind
    │   ├───Jaykul
    │   │   ├───Abou
    │   │   ├───Abou

    G:\2021-github-downloads\PowerShell\section  ┐ Web
    #>
    $CachedOutput = @'
    +--AngleSharp
    |  \--AngleSharp
    |     +--.github
    |     |  +--ISSUE_TEMPLATE
    |     |  \--workflows
    |     +--docs
    |     |  +--general
    |     |  \--tutorials
    |     +--src
    |     |  +--AngleSharp
    |     |  +--AngleSharp.Benchmarks
    |     |  +--AngleSharp.Core.Docs
    |     |  +--AngleSharp.Core.Tests
    |     |  \--TestGeneration
    |     \--tools
    \--kamome283
       \--AngleParse
          +--AngleParse
          |  +--Resource
          |  \--Selector
          +--AngleParse.Test
          |  +--Resource
          |  \--Selector
          \--build
'@
    <#
    +--AngleSharp
    |  \--AngleSharp
    |     +--.github
    |     |  +--ISSUE_TEMPLATE
    |     |  \--workflows
    |     +--docs
    |     |  +--general
    |     |  \--tutorials
    |     +--src
    |     |  +--AngleSharp
    |     |  +--AngleSharp.Benchmarks
    |     |  +--AngleSharp.Core.Docs
    |     |  +--AngleSharp.Core.Tests
    |     |  \--TestGeneration
    |     \--tools
    \--kamome283
       \--AngleParse
          +--AngleParse
          |  +--Resource
          |  \--Selector
          +--AngleParse.Test
          |  +--Resource
          |  \--Selector
          \--build

    #>

    if ($true) {

        $Replacements | ConvertTo-Json


        PSScriptTools\Show-Tree c:\programs -Depth 3
        | Join-String -sep "`n" | ForEach-Object {
            $accum = $_
            foreach ($pair in $Replacements) {
                $pattern = [regex]::Escape( $pair[0] )
                $replace = $pair[1]
                $accum = $accum -replace $pattern, $replace
            }
            $accum
        }


        h1 'Replacement mapping'
        , $Replacements | Join-String -sep "`n" {
            '{0} ⇒ {1}' -f @(
                $_[0] | New-Text -fg red | ForEach-Object tostring
                $_[1] | New-Text -fg green | ForEach-Object tostring
            )
        }

    }


}


if (! $experimentToExport) {
    # ...
}