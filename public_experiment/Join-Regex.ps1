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

        See ./Join-Regex.tests.ps1 for more

    .example
        PS> ls env: | ?{ $_.Value -match (Join-Regex -LiteralText $Env:USERPROFILE) }

    .example
        PS> Get-ChildItem env: | Where-Object {
            $_.Value -match ( Join-Regex -LiteralText $Env:USERPROFILE  )
        } | rg -i $(Join-Regex -LiteralText $Env:USERPROFILE, '$')

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
        [alias('LiteralText')]
        [Parameter()]
        [string[]]$Text,

        # list of regex's to OR
        [Parameter()]
        [string[]]$Regex
    )

    begin {
        # maybe related Exception names: 'ArgumentException', 'ParameterBindingException', 'PositionalParameterNotFound', 'PSArgumentException', 'ArgumentException'
        if ([string]::IsNullOrWhiteSpace($Text) -and [string]::IsNullOrWhiteSpace($Regex)) {
            $e = [System.ArgumentException]::new('Requires at least -TextLiteral or -Regex parameters')
            $PSCmdlet.ThrowTerminatingError($e)
        }
    }
    process {
        $splat_JoinLiteral = @{
            Separator = '|'
            Property  = { '({0})' -f [regex]::Escape( $_) }
        }
        $splat_JoinRegex = @{
            Separator = '|'
            Property  = { '({0})' -f $_ }
        }
        $splat_FinalJoin = @{
            Separator = '|'
            Property  = { '{0}' -f $_ }
        }

        $Regex_MergedLiteral = $Text | Join-String @splat_JoinLiteral
        $Regex_MergedRegex = $Regex | Join-String @splat_JoinRegex

        # if($Regex_MergedLiteral -and $Regex_MergedRegex) {
        $finalItems = @(
            if (! [string]::IsNullOrWhiteSpace($Text)) {
                $Regex_MergedLiteral
            }
            if (! [string]::IsNullOrWhiteSpace($Regex)) {
                $Regex_MergedRegex
            }
        )
        $Regex_Final = $finalItems | Join-String @splat_FinalJoin

        Write-Debug "Regex: Merged literals: $Regex_MergedLiteral"
        Write-Debug "Regex: Merged Regex: $Regex_MergedRegex"
        Write-Debug "Regex: Merged all: $Regex_Final"
        Write-Debug "`$Regex = $Regex_Final"

        # $Regex_Final = $finalItems
        # Write-Debug "Regex: Merged all: $Regex_Final"
        # if ($finalItems.count -gt 1) {
        #     Write-Debug "Regex: Merged all: $Regex_Final"
        # }
        # ) | Join-String @splat_FinalJoin
        # ) | Join-String @splat_JoinRegex # Do I want final outer parens? No for now.

        # $query = Get-ChildItem env: | Where-Object Value -Match $Regex_Final
        Write-Information $Regex_Final
        if ($PassThru) {
            $Regex_Final
            return
        }
        $Regex_Final
        # $query | rg -i $Regex_Final
    }
    end {
        # 'am end'
    }
}
