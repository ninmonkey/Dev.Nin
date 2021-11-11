$experimentToExport.function += @(
    'Format-RipGrepResult'
)
$experimentToExport.alias += @(
    'From->RipGrepResult'
)

function Format-RipGrepResult {
    <#
    .synopsis
        basic ripgrep filename output, to usable url
    .description
    .notes
        currently a relative path like this is not clickable:

            shell\Ninmonkey.Profile\Ninmonkey.Profile.psm1
2021\dotfiles_git\power

    .example
            PS> rg -c -tps 'invoke-restmethod'
                | Format-RipGrepResult -AsText
                | gi
    .notes
        original snippet was

        rg -c -tps -i 'ripgrep' -- 2021 | ForEach-Object { $_ -split ':' | Select-Object -SkipLast 1 | Join-String }

    #>
    [cmdletbinding(PositionalBinding = $false)]
    [alias('Out-ConRipGrepResult', 
        'From->RipGrepResult')]
    param (
        #
        [Alias('Text')]
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$InputObject,

        # Object instead of text
        [Parameter()][switch]$PassThru,

        # Force text output, not the custom fileinfo type
        [Parameter()][switch]$AsText,
        # Ansi escapes
        [Parameter()][switch]$AsUri
    )
    begin {
    }
    process {
        $ResultList = $InputObject
        | StripAnsi
        | ForEach-Object -ea continue {
            [hashtable]$Result = @{}
            $Parts = $_ -split ':'

            $Fullname_Ending = $Parts | Select-Object -SkipLast 1 | Join-String
            $Result.MatchCount = $Parts | Select-Object -Last 1
            $Result.FullName = Join-Path (Get-Location) $FullName_Ending
            $Result.File = Get-Item -ea continue $Result.Fullname


            [pscustomobject]$Result
        } | Sort-Object LastWriteTime -Descending

        if ($PassThru) {
            $ResultList
        } else {
            if ($AsText) {
                $ResultList | ForEach-Object FullName
            } elseif ($AsUri) {
                <#
                Note: VS Code does not allow urls with a separate name,
                but 'wt' does. ie:

                    Both:
                        New-Hyperlink -Uri 'https://www.google.com'
                    Only 'wt':
                        New-Hyperlink -Uri 'https://www.google.com' -Object 'search'
                #>
                $ResultList
                | ForEach-Object {
                    New-Hyperlink -Uri $_.Fullname
                    New-Hyperlink -Uri "file:///$($_.FullName)"
                }
                # $ResultList | ForEach-Object File
            } else {
                $ResultList # fallback to result with metadata
            }
            # $ResultList | ForEach-Object FullName | ForEach-Object tostring
        }
    }
    end {
    }
}
