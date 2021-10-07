# allows script to be ran alone, or, as module import
if (! $DebugInlineToggle ) {
    $experimentToExport.function += @(
        'Invoke-FdFind'
    )
    $experimentToExport.alias += @(
        'Dig'
    )
}

function Invoke-FdFind {
    <#
    .synopsis
        Stuff
    .description
        Desc

        mimics
            PS> fd -d 2 -t d cat --color=always | Out-Fzf -ov fzf
    .notes
        naming:
            dive -> you find and enter filepath
            dig -> you find something, but don't get it

    .outputs

    #>
    [alias('Dive', 'FdFind')]
    [CmdletBinding(PositionalBinding = $true, SupportsShouldProcess
        # NYI: , SupportsPaging
    )]
    param(
        # base path
        [Parameter(Position = 0)]
        [string]$Path,

        # file types
        [Parameter()]
        [validateSet('File', 'Directory')]
        [string[]]$Type = @('File', 'Directory'),

        # optional query for fd-find
        [Alias('Text', 'Query')]
        [AllowNull()]
        [Parameter(Position = 1)] # should type be positional?
        [string]$Pattern,

        # depth to search, the default is to recurse
        [Parameter()]
        [uint]$Depth,

        # Extensions to find?
        [Parameter()] # should type be positional?
        [ArgumentCompletions('code-workspace', 'ps1', 'pq', 'md', 'json')]
        [string[]]$Extension

        # # test cli arguments
        # [parameter()][switch]$WhatIf

    )

    begin {}
    process {
        try {
            if ($Type.Count -eq 0) {
                $Type.Count += @('Directory', 'Text')
            }
            $BinFd = Get-Command 'fd' -CommandType Application -ea stop
            $Path ??= '.'

            if (! (Test-Path $Path)) {
                Write-Warning "Invalid File path '$Path', using '.'"
                $Path = Get-Item '.'
                # Write-Error "Invalid File path '$Path'"
                # return
                # $PSCmdlet.ThrowTerminatingError(
                #     <# errorRecord: #> $errorRecord)

                # # future: todo:
                # [System.Management.Automation.ErrorRecord]::new(
                #     <# exception: #> [Exception]::new("Invalid File Path '$Path'"),
                #     <# errorId: #> $errorId,
                #     <# errorCategory: #> $errorCategory,
                #     <# targetObject: #> $targetObject)

            }


            [string[]]$fdArgs = @()

            if ($Depth) {
                $fdArgs += @(
                    '-d'
                    $Depth
                )
            }
            # todo: this was not outputting correct
            if ($False) {
                switch ($Type) {
                    { 'File' } {
                        $fdArgs += '-t', 'f'
                        break
                    }
                    { 'Directory' } {
                        $fdArgs += '-t', 'd'
                        break
                    }
                    default { 'bad' }
                }
            }
            if ($Type -contains 'Directory' -and $Type -contains 'File') {
                # implicit is all
            }
            else {
                if ($Type -contains 'Directory') {
                    $fdArgs += @('-t', 'd')
                }
                if ($Type -contains 'File') {
                    $fdArgs += @('-t', 'f')
                }
            }

            if ($Extension) {
                Write-Warning 'Extension partiallly implemented'
            }
            # $Extension | ForEach-Object {
            #     $fdArgs += @(
            #         '-e'
            #         "'$Extension'"
            #     )
            # }

            $fdArgs += @($Pattern)
            $fdArgs += @(
                '--color=always'
            )

            # if ($PSCmdlet.ShouldProcess("$kwargs", "'FdFind'")) {
            if ($WhatIf) {
                @(
                    $Path | Format-RelativePath -BasePath '.' | Join-String -op 'Path: ' | write-color green
                    $fdArgs | Join-String -sep ' ' -op 'fdfind args: ' | write-color green
                ) | Join-String
                return

            }
            else {
                if ($Path) {
                    Push-Location $Path -StackName 'fd.find'
                }

                @(
                    $Path | Format-RelativePath -BasePath '.' | Join-String -op 'Path: '
                    $fdArgs | Join-String -sep ' ' -op 'fdfind args: ' | write-color magenta
                ) | Write-Information

                & $binFd @FdArgs

                # Pop-Location -StackName 'fd.find'

            }
        }
        catch {
            $PSCmdlet.WriteError($_)
        }
    }
    # todo: always wrap CmdletExceptionWrapper: From Sci


    end {}
}

if ($DebugInlineToggle ) {
    # pester tests
    if ($false -and 'for pester parameter unit testing') {
        Invoke-FdFind -t Directory | Should -Be @('.', '-t', 'd')
        Invoke-FdFind -t File, Directory | Should -Be @('.', '-t', 'd', '-t', 'f')
        Invoke-FdFind 'a' -t File, Directory | Should -Be @('.', '-t', 'd', '-t', 'f', 'a')
    }


    # code
    Invoke-FdFind '.' a  -Type Directory, File
    Invoke-FdFind . -Type Directory a -infa Continue -e code-workspace, ps1
}
<#

Other types
    fd --glob *.gif

Example error:

[fd error]: The search pattern 'C:\Users\cppmo_000\Documents\2021' contains a path-separation character ('\') and will not lead to any search results.

If you want to search for all files inside the 'C:\Users\cppmo_000\Documents\2021' directory, use a match-all pattern:

  fd . 'C:\Users\cppmo_000\Documents\2021'

Instead, if you want your pattern to match the full file path, use:

  fd --full-path 'C:\Users\cppmo_000\Documents\2021'
#>
