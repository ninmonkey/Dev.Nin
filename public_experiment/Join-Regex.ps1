$experimentToExport.function += 'Join-Regex'
# $experimentToExport.alias += ''

function Join-Regex {
    <#
    .synopsis
        Combine patterns, creating a new OR regex pattern
    .description
        It allows merging literals and patterns as an or, in one call

        Like when you use
            🐒>  Ls . | ?{ $_.FullName -match 'dotfiles|config' }
        or
            🐒> $Path = gi $Env:UserProfile
                $Regex = [regex]::escape( $Path )
                Ls . | ?{ $_.FullName -match $Regex }

    .notes
        future:
            - [ ] can I simplify a way to say regex anchor plus literal, easier?
                Like
                    $PathAsLiteral = [regex]::escape( $Path )
                    $Regex = '^' + $PathAsLiteral
                    $Env:PATH -match $Regex

                It's probably best to just write a second regex generating command
    .outputs
        [string]

    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # list of literal text to OR
        [Parameter(Mandatory)]
        [string[]]$Text,

        # list of regex's to OR
        [Parameter()][switch]$Regex,

        # otherwise also colorize match
        [Parameter()][switch]$PassThru

    )

    begin {}
    process {
        $splat_JoinLiteral = @{
            Separator = '|'
            Property  = { '({0})' -f [regex]::Escape( $_) }
        }
        $splat_JoinRegex = @{
            Separator = '|'
            Property  = { '({0})' -f $_ }
        }

        $Regex_MergedLiteral = $Text | Join-String @splat_JoinLiteral
        $Regex_MergedRegex = $Text | Join-String @splat_JoinRegex

        # if($Regex_MergedLiteral -and $Regex_MergedRegex) {
        $Regex_Final = @(
            $Regex_MergedLiteral
            $Regex_MergedRegex
        ) | Join-String $splat_JoinRegex

        Write-Debug "Regex: Merged literals: $Regex_MergedLiteral"
        Write-Debug "Regex: Merged Regex: $Regex_MergedRegex"
        Write-Debug "Regex: Merged all: $Regex_Final"
        Write-Debug "`$Regex = $Regex_Final"

        $query = Get-ChildItem env: | Where-Object Value -Match $Regex_Final
        if ($PassThru) {
            $query
            return
        }

        $query | rg -i $Regex_Final
    }
    end {}
}
