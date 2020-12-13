function Dev-GetManPage {
    <#
    .synopsis
        shortcut to read and 'grep' man pages
    .notes
        - [ ] Add syntax highlighting or at least regex-based syntax highlighting of flags
    #>
    [Alias('Man', 'nMan')]
    param (
        # app name, hard coded for test
        [Parameter(Mandatory, Position = 0)]
        [Alias('Name')]
        [ValidateSet('fd', 'fzf', 'rg', 'python', 'pwsh', 'powershell')]
        [string]$CommandName,

        # search for specific flag names
        [Parameter(Position = 1)]
        [Alias('Flag')]
        [string]$FlagName,


        # Skip cached local man page
        [Parameter()][switch]$NoCache
    )

    $Regex = @{}
    $Regex.ShortFlag_Part1 = '(?x-i)
        \s*\-'
    $Regex.ShortFlag_Part2 = '{1,2}\b'

    # function regexTemplate {
    #     [Parameter()]
    #     [object]$List

    # }

    switch ($FlagName) {
        { $true } {
            $FullRegex = $regex.ShortFlag_Part1, $FlagName, $Regex.ShortFlag_Part2 -join ''
        }
        default { throw "ShouldNever: $FlagName" }
    }


    $Paths = @{
        'config'  = Get-Item -ea stop 'C:\Users\cppmo_000\Documents\2020\powershell\MyModules_Github\Dev.Nin\public\man\manpage.json'
        'manPage' = Get-Item -ea stop 'C:\Users\cppmo_000\Documents\2020\powershell\MyModules_Github\Dev.Nin\public\man\'
    }

    $manPage = Join-Path $Paths.manPage -ChildPath "$CommandName.man.txt"
    $cmdBin = Get-Command $CommandName -ea Continue

    $isSkipCache = (!(Test-Path $manPage)) -or (! $skipCache)
    Label 'skip' $isSkipCache

    if ( [string]::IsNullOrWhiteSpace($FlagName) ) {
        if ( $isSkipCache ) {
            & $cmdBin --help
            return
        }
        Get-Content $manPage
        return
    }


    if ( $isSkipCache ) {
        & $cmdBin --help  | rg -i $FullRegex -C 2
        return
    }
    Get-Content $manPage | rg -i $FullRegex -C 2
}

# Import-Module dev.nin -Force
nman rg -FlagName 'I'