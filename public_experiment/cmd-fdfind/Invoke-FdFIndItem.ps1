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

function Get-SmartAlias {
    <#
    .synopsis
        sugar to validate alias, maybe named Test-SmartAlias
    .outputs
        <$null | [string]>
    #>
    [cmdletbinding()]
    param(
        # state to validate
        [Parameter(Mandatory, Position = 0)]
        # false negative param binding? #or will I get some false negatives if typed?
        [Management.Automation.Cmdlet] # it failed on # [Management.Automation.PSScriptCmdlet]
        $PSCmdletSource
    )
    $maybeAlias = $PSCmdletSource.MyInvocation.InvocationName
    # Wait-Debugger
    if ($maybeAlias -eq $PSCmdletSource.CommandRuntime.ToString()) {
        $null; return
    }
    $maybeAlias; return
}
<#
'f' or 'file': regular files
'd' or 'directory': directories
'l' or 'symlink': symbolic links
'x' or 'executable': executables
'e' or 'empty': empty files or directories
's' or 'socket': socket
'p' or 'pipe': named pipe (FIFO)
#>

# [todo] can I namespace a few parameters to keep them strict
# do { Set-Content @someExistingVar }.GetSteppablePipeline() and play with it
enum FdFindFiletypeKind {
    file        # 'f' : regular files
    directory   # 'd' : directories
    symlink     # 'l' : symbolic links
    executable  # 'x' : executables
    empty       # 'e' : empty files or directories
    socket      # 's' : socket
    pipe        # 'p' : named pipe (FIFO)
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
        dev.nin\Match-String
    .link
        dev.nin\Find-FDNewestItem
    .link
        dev.nin\Invoke-FdFind
    .link
        dev.nin\Invoke-FdFindItem

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
        [Parameter()][switch]$Directory,

        [Alias('WhatIf')]
        [Parameter()][switch]$Test
    )

    begin {
        $docs = @'
        'f' or 'file': regular files
        'd' or 'directory': directories
        'l' or 'symlink': symbolic links
        'x' or 'executable': executables
        'e' or 'empty': empty files or directories
        's' or 'socket': socket
        'p' or 'pipe': named pipe (FIFO)
'@

    }
    process {
        $smartAlias = Get-SmartAlias $PSCmdlet
        [object[]]$fdArgs = @()

        "Alias: '$smartAlias'" | Write-Debug


        $selectedTypes = @()
        switch ($smartAlias) {
            'findd' {
                $selectedTypes += [FdFindFiletypeKind]::directory
            }
            'findf' {
                $selectedTypes += [FdFindFiletypeKind]::file
            }
            Default {

            }
        }

        $old_fdArgs = @(
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

        [object[]]$fdArgs = @(
            $selectedTypes | ForEach-Object {
                '--type', $_.ToString() # it seemed to coerce to string correctly, but, just to be clear
            }
        )

        $fdArgs += @(
            '--color', 'always'
        )


        $fdArgs | Join-String -sep ' ' -op 'Invoke-Fd args: '
        | Write-Information
        | Write-Color magenta

        $fdArgs | str csv | Join-Before { h1 'stuff' }
        | wi

        if ($Test) {
            return
        }

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
    findd -infa Continue 'cmd'
    | f 4
    hr 2

    # ...
}