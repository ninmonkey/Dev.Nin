Write-Warning "run --->>>> '$PSCommandPath'"

"run --->>>> '$PSCommandPath'" #| Write-TExtColor white -bg black
| Write-Warning
if ($experimentToExport) {
    $experimentToExport.function += @(
        'Old.Invoke-VSCodeVenv'
    )
    $experimentToExport.alias += @(
        'Old.Code-vEnv'
        # 'Out-CodeVEnv'
        # 'Out-VSCodeEnv'
        # 'Invoke-VSCode'
    )
}

# $OneDrive_VSCode
# & $OneDrive_VSCode @('-r', '-g', 'telemetryCache.otc')
# & $OneDrive_VSCode @('-r', '-g', 'telemetryCache.otc')
function Old.Invoke-VSCodeVenv {
    <#
    .synopsis
        quick hack to work around one drive bug
    .example
        🐒> $profile | code-venv
    .example
        🐒> $profile | code-venv -WhatIf


            vscode_venv: "J:\vscode_port\VSCode-win32-x64-1.57.1\Code.exe"
            vscode_args: '-r' '-g' 'C:\Users\cppmo_000\SkyDrive\Documents\PowerShell\Microsoft.VSCode_profile.ps1'
            J:\vscode_port\VSCode-win32-x64-1.57.1\Code.exe
    #>
    # [Alias('Code-vEnv', 'Out-CodeVEnv', 'Out-VSCodeEnv')]
    [Alias('Old.Code-vEnv', 'Old.Out-CodeVEnv', 'Old.Out-VSCodeEnv')]
    [cmdletbinding(PositionalBinding = $false, DefaultParameterSetName = 'OpenFile')]
    param(
        # which venv
        [Alias('VEnv')]
        [Parameter()]
        # [ValidateSet('J:\vscode_port\VSCode-win32-x64-1.57.1\Code.exe')]
        # [string]$VirtualEnv = 'J:\vscode_port\VSCode-win32-x64-1.57.1\Code.exe',
        [string]$VirtualEnv = 'J:\vscode_port\VSCode-win32-x64-1.61.0-insider\bin\code-insiders.cmd',

        # File
        [Alias('Path', 'PSPath', 'File')]
        [Parameter(
            ParameterSetName = 'OpenFile',
            Mandatory,
            Position = 0, ValueFromPipelineByPropertyName = 'PSPath', ValueFromPipeline
        )]
        [string]$TargetPath,

        # WhatIf
        [Parameter()][switch]$WhatIf,

        # Open the app to resume sessions
        [Alias('Start')]
        [Parameter(Mandatory, ParameterSetName = 'Resume')]
        [switch]$ResumeSession,

        # args to vs code instead
        [Parameter(Mandatory, ParameterSetName = 'ExplicitArgs')]
        [string[]]$ArgsRest
        # # Args to code
        # [Parameter(AttributeValues)]
        # [ParameterType]
        # $ParameterName]
    )
    begin {
        <#
        future:
        Visual Studio Code - Insiders 1.61.0-insider

            Usage: code-insiders.exe [options][paths...]

            To read output from another program, append '-' (e.g. 'echo Hello World | code-insiders.exe -')

            Options
            -d --diff <file> <file>           Compare two files with each other.
            -a --add <folder>                 Add folder(s) to the last active window.
            -g --goto <file:line[:character]> Open a file at the path on the specified
                                                line and character position.
            -n --new-window                   Force to open a new window.
            -r --reuse-window                 Force to open a file or folder in an
                                                already opened window.
            -w --wait                         Wait for the files to be closed before
                                                returning.
            --locale <locale>                 The locale to use (e.g. en-US or zh-TW).
            --user-data-dir <dir>             Specifies the directory that user data is
                                                kept in. Can be used to open multiple
                                                distinct instances of Code.
            -h --help                         Print usage.

            Extensions Management
            --extensions-dir <dir>
                Set the root path for extensions.
            --list-extensions
                List the installed extensions.
            --show-versions
                Show versions of installed extensions, when using --list-extensions.
            --category <category>
                Filters installed extensions by provided category, when using --list-extensions.
            --install-extension <extension-id[@version] | path-to-vsix>
                Installs or updates the extension. The identifier of an extension is always `${publisher}.${name}`. Use `--force` argument to update to latest version. To install a specific version provide `@${version}`. For example: 'vscode.csharp@1.2.3'.
            --uninstall-extension <extension-id>
                Uninstalls an extension.
            --enable-proposed-api <extension-id>
                Enables proposed API features for extensions. Can receive one or more extension IDs to enable individually.

            Troubleshooting
            -v --version                       Print version.
            --verbose                          Print verbose output (implies --wait).
            --log <level>                      Log level to use. Default is 'info'.
                                                Allowed values are 'critical', 'error',
                                                'warn', 'info', 'debug', 'trace', 'off'.
            -s --status                        Print process usage and diagnostics
                                                information.
            --prof-startup                     Run CPU profiler during startup.
            --disable-extensions               Disable all installed extensions.
            --disable-extension <extension-id> Disable an extension.
            --sync <on> <off>                  Turn sync on or off.
            --inspect-extensions <port>        Allow debugging and profiling of
                                                extensions. Check the developer tools for
                                                the connection URI.
            --inspect-brk-extensions <port>    Allow debugging and profiling of
                                                extensions with the extension host being
                                                paused after start. Check the developer
                                                tools for the connection URI.
            --disable-gpu                      Disable GPU hardware acceleration.
            --max-memory <memory>              Max memory size for a window (in Mbytes).
            --telemetry                        Shows all telemetry events which VS code
                                                collects.


        #>
        $Regex = @{
            FilepathWithPosition = '(:\d+){1,}$'
        }
        $bin_vscode = Get-Item -ea stop $VirtualEnv
    }

    end {
        [object[]]$code_args = @()

        function _handleOpenFile {

            # because: if '-r' is used on a directory, you lose the current session
            if ($targetPath) {
                # quick hack, just always drop the goto
                if ($TargetPath -match $Regex.FilepathWithPosition) {
                    @(
                        'NYI: dropping positions on file uris'
                        $targetPath | Join-String -DoubleQuote -op '  '
                        $targetPath -replace $Regex.FilepathWithPosition, '' | Join-String -DoubleQuote -op '  '
                    ) | Join-String -sep "`n" | Write-Warning
                    $targetPath = $targetPath -replace $Regex.FilepathWithPosition, ''
                }
                $Fullpath = Get-Item -ea stop $targetPath
                $isAFolder = Test-IsDirectory $Fullpath
                @{
                    FullPath  = $Fullpath
                    IsAFolder = $IsAFolder
                } | Out-String | Write-Debug

                if ($isAFolder) {
                    $code_args += @(
                        '-n'
                        '-g'
                    )
                }
                else {
                    $code_args += @(
                        '-r'
                        '-g'
                        $Fullpath
                    )
                }
            }

            if ($WhatIf) {

                Write-Information "IsDir? $IsAFolder"
                $VirtualEnv | Join-String -op 'vscode_venv: ' -DoubleQuote | Write-TExtColor 'hotpink3'
                $code_args | Join-String -op 'vscode_args: ' -sep ' ' -SingleQuote | Write-TExtColor 'hotpink3'
                $VirtualEnv
                return
            }
            Write-Information "IsDir? $IsAFolder" | Write-Information
            $VirtualEnv | Join-String -op 'vscode_venv: ' -DoubleQuote | Write-TExtColor 'hotpink3' | Write-Information
            $code_args | Join-String -op 'vscode_args: ' -sep ' ' -SingleQuote | Write-TExtColor 'hotpink3' | Write-Information

            # & $bin_vscode @code_args
            Start-Process -Path $bin_vscode -WindowStyle Hidden -Args $code_args
        }

        function _handleResumeSession {
            $code_args = @()
            if ($WhatIf) {
                "run: '$bin_vscode'"
                return
            }
            # & $bin_vscode
            Start-Process -Path $bin_vscode -WindowStyle Hidden
        }

        function _handleExplicitArgs {
            Write-Error -ea stop -Category NotImplemented -Message 'Args nyi'
        }

        switch ($PSCmdlet.ParameterSetName) {
            'Resume' {
                'state: _handleResumeSession' | Write-Debug
                _handleResumeSession
                break
            }
            'ExplicitArgs' {
                'state: _handleExplicitArgs' | Write-Debug
                _handleExplicitArgs
                break
            }
            default {
                'state: [default | _handleOpenFile]' | Write-Debug
                _handleOpenFile
                break

            }
        }
    }
}
