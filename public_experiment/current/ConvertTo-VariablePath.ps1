#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'ConvertTo-VariablePath'
        # below?
    )
    $experimentToExport.alias += @(
        'To->VariablePath' # ConvertTo-VariablePath
    )
}

function ConvertTo-VariablePath {
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
    .notes
        do this first
    .example
        PS> ConvertTo-VariablePath 'C:\Users\cppmo_000\Documents\2021'
    .notes
        .
    #>
    [Alias('To->VariablePath')]
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

        $targetPath = Resolve-Path $LiteralPath -ea ignore
        Write-Debug "literal match: '$LiteralPath' => '$targetPath'"
        $targetPath ??= Get-Item $LiteralPath -ea ignore
        $targetPath ??= $LiteralPath

        Write-Debug "comparePath: $targetPath"

        $Pattern.GetEnumerator() | ForEach-Object {
            $curMap = $_
            $curPattern = $curMap.Value.Pattern
            $curReplace = $curMap.Value.Replacement
            Write-Debug "curPat: $($curPattern)"
            if ($targetPath -match $curPattern ) {
                Wait-Debugger
                $finalText = $targetPath -replace $Pattern, $Replacement
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

        #
        #
        #
        # temp hacks, hardcode the most
        $reTarget = (relit "$Env:UserProfile" )
        if ($targetPath -match $reTarget) {
            $finalText = $targetPath -replace $reTarget, '${Env:UserProfile}'
            return $finalText
        }

        Write-Debug "`${FinalText}  '$FinalText'"
        if ( Test-IsNotBlank $finalText ) {
            Write-Debug "`${FinalText} was not blank: '$FinalText'"
            return $finalText
        }

        Write-Error "No matches for '$LiteralPath'" -TargetObject $LiteralPath
        return $LiteralPath
    }
    end {
    }
}


if (! $experimentToExport) {
    # ...
}
