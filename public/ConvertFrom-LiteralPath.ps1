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
    param (
        # input LiteralPath to convert
        [Alias('Text')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$LiteralPath

    )
    begin {
        $Pattern = @{}
        $Pattern.UserProfilePrefix = @{
            Description = 'Only match on starts with'
            Pattern     = '^' + [regex]::Escape( $Env:UserProfile )
            Replacement = '$Env:UserProfile'
        }

    }
    process {

        $comparePath = Resolve-Path $LiteralPath -ea ignore
        $comparePath ??= $LiteralPath

        # repeat eval for simplicity
        if ($comparePath -match $Pattern.UserProfilePrefix.Pattern ) {
            $finalText = $comparePath -replace $Pattern.UserProfilePrefix.Pattern, $Pattern.UserProfilePrefix.Replacement
            $finalText

            Write-Debug "try: $($Pattern.UserProfilePrefix.Pattern)"
            return
        }
        $finalText
        Write-Error 'No matches'
        return
    }
    end {}
}
