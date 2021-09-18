function ConvertFrom-LiteralPath {
    <#
    .synopsis
        attempt to transform literal paths into an EnvironmentVariable path
    .description
        .go from:
            input
                c:\users\bob\stuff
            output
                $Env:UserProfile\stuff

        by testing against 'Env:'
    .example
        PS> ConvertFrom-LiteralPath 'C:\Users\cppmo_000\Documents\2021'
    .notes
        .
    #>
    [Alias('PathToVars')]
    [cmdletbinding()]
    param (
        # input LiteralPath to convert
        [Alias('Text')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$LiteralPath

    )
    begin {

        # function __evaluatePath {
        #     param(
        #         [string]$PathAsLiteral
        #     )

        #     $p = ($x -split ':', 2)[1]
        #     ls env:$p

        # }

        $Pattern = [ordered]@{}
        $Pattern.AppData = @{
            Description = 'Roaming data'
            Pattern     = '^' + [regex]::Escape( $Env:AppData )
            Replacement = '$Env:AppData'
        }
        $Pattern.UserProfilePrefix = @{
            Description       = 'Only match on starts with'
            Pattern           = '^' + [regex]::Escape( $Env:UserProfile )
            Replacement       = '$Env:UserProfile'
            ReplacementString = '$Env:UserProfile' -replace '^\$', '' | Get-Item -ea continue
        }

        # Find Env-var paths that are a directory.
        # sort by length, to get the best env var possible
        $PossibleVars = Get-ChildItem env: | Sort-Object { $_.Value.length } -Descending | Where-Object { Test-Path $_.value -PathType Container }
        $PossibleVars | Format-Table | Out-String | Write-Debug
        $Pattern.GetEnumerator() | ForEach-Object { $_.Value } | Format-Table | Out-String | Write-Debug

    }
    process {

        $comparePath = Resolve-Path $LiteralPath -ea ignore
        $comparePath ??= $LiteralPath
        Write-Debug "comparePath: $comparePath"

        $Pattern.GetEnumerator() | ForEach-Object {
            $curMap = $_
            $curPattern = $curMap.Value.Pattern
            $curReplace = $curMap.Value.Replacement
            Write-Debug "curPat: $($curPattern)"
            if ($comparePath -match $curPattern ) {
                $finalText = $comparePath -replace $Pattern, $Replacement
                $finalText
                return
            }
        }

        # repeat eval for simplicity
        # if ($comparePath -match $Pattern.UserProfilePrefix.Pattern ) {
        #     $finalText = $comparePath -replace $Pattern.UserProfilePrefix.Pattern, $Pattern.UserProfilePrefix.Replacement
        #     $finalText

        #     Write-Debug "try: $($Pattern.UserProfilePrefix.Pattern)"
        #     return
        # }
        $finalText
        Write-Error 'No matches'
        return
    }
    end {}
}
