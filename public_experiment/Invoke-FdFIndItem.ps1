#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Invoke-FdFindItem'
    )
    $experimentToExport.alias += @(
        'FindD' # 📁
        'FindF' # 📄
    )
}





function Invoke-FdFindItem {
    <#
    .synopsis
        wrapper ontop of 'fdfind', which is fast
    .description
    
        .
    .example
            # filters paths by regex, preserves color in the pipe to fzf
        PS> findd | ?str azure | fzf -m

        # sugar for the same
        PS> findd -Regex 'azure' | fzf -m
    .example
        PS> FindD
            # only find 📁
    .example
        PS> FindF
            # only finds 📄
    .link
        Dev.Nin\Invoke-FdFind
    .link
        Dev.Nin\Invoke-FdFindItem
    .link
        Dev.Nin\Match-String

    .outputs
          [string | None]
    
    #>
    [Alias(
        'findd', 
        'findf'  #'ff'
    )]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Position = 0)]
        [string]$Regex,

        # max depth
        [Alias('Depth', 'D')]
        [Parameter()]
        [uint]$MaxDepth = 4,

        # optional: only files: files, exclusive modes
        [Parameter()][switch]$File,
        [Parameter()][switch]$Directory
    )
    
    begin {
       
    }
    process {
        $fdArgs = @(
            if ($File) {
                '-t', 'f'
            }
            if ($Directory) {
                '-t', '-d'
            }
            if ($MaxDepth) {
                '-d', 4 
            } else {
                '-d', 4 
            }
            if ($Regex) {
                $Regex
            }
            '--color=always'
        )

        $fdArgs | Join-String -sep ' ' -op 'Invoke-Fd args: '
        | Write-Information
        | Write-Color magenta

        $fdArgs | str csv | Join-Before { h1 'stuff' }
        | wi 


        $binFd = Get-NativeCommand 'fd'
        & $binFd @fdArgs

    }
    end {
      
    }
}




if (! $experimentToExport) {
    $PSDefaultParameterValues['Invoke-FDFindItem:Infa'] = 'continue'
    # $InformationPreference = ''
    findf -infa Continue
    | f 4
    findd -infa Continue
    | f 4
    hr 2
    findd -infa Continue 'parse' 
    | f 4
    hr 2 

    # ...
}