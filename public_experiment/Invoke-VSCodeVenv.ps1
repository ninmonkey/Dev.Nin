Write-Warning "run --->>>> '$PSCommandPath'"

"run --->>>> '$PSCommandPath'" #| Write-TExtColor white -bg black
| Write-Warning
if ($experimentToExport) {
    $experimentToExport.function += @(
        'Invoke-VSCodeVenv'
    )
    $experimentToExport.alias += @(
        'Code-vEnv'
    )
}
function __findVSCodeBinaryPath {
    <#
    .synopsis
        internal. Find versions of vscode
    .outputs
        [IO.FileInfo]
    #>
    $fdArgs = @(
        # '-d', 5
        '--max-depth', '5'
        # '-e', 'cmd',
        '--extension', 'cmd'
        'code' # regex
        'j:\'  # root path
        '--color=never'
    )

    $binFd = Get-NativeCommand fd
    [object[]]$results = & $BinFd @fdArgs

    $results | Get-Item | Sort-Object LastWriteTime -desc
}
<#
code --help:
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
function Invoke-VSCodeVenv {
    <#
    .synopsis
        quick hack to work around one drive bug
    .description
        .
    .notes
        . - next:
            - [ ] argument transformation attribute:
                supports [Path] or [VsCodeFilePath]


        POC
            - [ ] code-venv -ResumeSession
            - [ ] '-reuse -g <filename>'
            - [ ] '-r -a <path>'
            - [ ] '-n -a <path>'
    .link
        New-VSCodeFilepath
    .link
        VsCodeFilePath
    .link
        ConvertTo-VsCodeFilepath
    .link
        ConvertFrom-ScriptExtent
    .example
        🐒> $profile | code-venv
    .example
        🐒> $profile | code-venv -WhatIf


            vscode_venv: "J:\vscode_port\VSCode-win32-x64-1.57.1\Code.exe"
            vscode_args: '-r' '-g' 'C:\Users\cppmo_000\SkyDrive\Documents\PowerShell\Microsoft.VSCode_profile.ps1'
            J:\vscode_port\VSCode-win32-x64-1.57.1\Code.exe
    # #>
    # [Alias('Code-vEnv', 'Out-CodeVEnv', 'Out-VSCodeEnv')]
    #>
    [Alias('Code-vEnv', 'Out-CodeVEnv')]
    [cmdletbinding(
        PositionalBinding = $false,
        DefaultParameterSetName = 'OpenItem',
        # DefaultParameterSetName = 'ResumeSession',
        SupportsShouldProcess, ConfirmImpact = 'High'
    )]
    param(
        # which venv
        # [Alias('VEnv')]
        # [Parameter()]
        # # [string]$VirtualEnv = 'J:\vscode_port\VSCode-win32-x64-1.57.1\Code.exe',
        # # todo: make DynamicCompleter

        # [ValidateSet(( 'J:\vscode_port\VSCode-win32-x64-1.62.0-insider\bin\code-insiders.cmd',
        #         'J:\vscode_port\VSCode-win32-x64-1.61.0-insider\bin\code-insiders.cmd',
        #         'J:\vscode_port\VSCode-win32-x64-1.57.1\bin\code.cmd'))]
        # [string]$VirtualEnv = 'J:\vscode_port\VSCode-win32-x64-1.62.0-insider\bin\code-insiders.cmd',

        # [Alias('VEnv')]
        # [Parameter()]
        # # todo: make DynamicCompleter
        # [ValidateSet('J:\vscode_datadir\games')]
        # [string]$DataDir,

        # File
        <#
            if System.Management.Automation.Language.InternalScriptExtent:
                use: File
                #>

        # [Alias('Path', 'PSPath', 'File')]
        [Parameter(
            ParameterSetName = 'OpenItem',
            Position = 0,
            ValueFromPipelineByPropertyName = 'PSPath',
            ValueFromPipeline
        )]
        [string]$TargetPath = '.',

        # which mode, reuse/new
        [alias('Mode')]
        [parameter(
            ParameterSetName = 'OpenItem',
            position = 1
        )]
        [validateSet('ReuseWindow', 'NewWindow')]
        [string]$WindowMode,

        # Open the app to resume sessions
        [Alias('Start', 'Restart')]
        [Parameter()][switch]$ResumeSession,

        # info
        # --version and extension info
        [Parameter()][switch]$Version,

        # --help
        [Parameter()][switch]$Help,

        [Alias('ExtraArgs')]
        [Parameter(ValueFromRemainingArguments)]
        [string]$RemainingArgs



        # args to vs code instead
        # [Parameter(Mandatory, ParameterSetName = 'ExplicitArgs')]
        # [string[]]$ArgsRest
        # # Args to code
        # [Parameter(AttributeValues)]
        # [ParameterType]
        # $ParameterName]
    )
    begin {}
    process {
        $BinCode = Get-Item -ea continue 'J:\vscode_port\VSCode-win32-x64-1.62.0-insider\bin\code-insiders.cmd'
        $DataDir = Get-Item -ea continue 'J:\vscode_datadir\games'
        $target = Get-Item -ea continue $TargetPath
        if (Test-IsDirectory $target) {
            'Open a directory?' | write-color 'Magenta'
        }
        'latest manual invoke' | write-color 'blue'
        [string[]]$codeArgs = @()
        if ($DataDir) {
            $codeArgs += @(
                '--user-data-dir'
                $DataDir | Get-Item -ea stop
            )
        }

        switch ($WindowMode) {
            'NewWindow' {
                $CodeArgs += @('--new-window')
            }
            'ReuseWindow' {
                $CodeArgs += @('--reuse-window')
            }
            default {
                $CodeArgs += @('--reuse-window')
            }
        }

        if (Test-IsDirectory $target) {
            $CodeArgs += @('--add', $Target)
        }
        else {
            # always use goto, even without line numbers. it's more resistant to errors
            $CodeArgs += @('--goto', $Target)
        }

        if (! [string]::IsNullOrWhiteSpace($RemainingArgs )) {
            $CodeArgs += $RemainingArgs

        }

        if ($ResumeSession) {
            write-color -t 'ResumeSession' 'green'
        }
        else {
            write-color -t 'LoadItem: ' 'green'
            write-color -t $TargetPath 'yellow'
        }
        $metaInfo = [ordered]@{
            BinCode       = $BinCode
            DataDir       = $DataDir
            Target        = $Target
            codeArgs      = $CodeArgs
            ResumeSession = $ResumeSession
            BoundParams   = $PSBoundParameters
            ParameterSet  = $PSCmdlet.ParameterSetName
            RemainingArgs = $RemainingArgs
            PSCommandPath = $PSCommandPath
            PSScriptRoot  = $PSScriptRoot
        }

        # Exit Early functions
        if ($Version) {
            & $CodeBin @('--list-extensions')
            | Join-String -op (hr 2) -os (hr 2) -sep "`n"

            & $CodeBin @('--list-extensions', '--show-versions')
            | ForEach-Object { $_ -replace '@', ': ' }
            | Join-String -op (hr 2) -os (hr 2) -sep "`n"

            & $CodeBin @('--version')
            | Join-String -sep ', ' -op (write-color orange -t 'Version: ')
            return
        }
        if ($Help) {
            & $CodeBin @('--help')
            return
        }

        if ($ResumeSession) {
            if ($PSCmdlet.ShouldProcess("($BinCode, $DataDIr)", 'ResumeSession')) {
                Start-Process -path $CodeBin -args $codeArgs -WindowStyle Hidden -Verbose -WhatIf
                return
            }
        }
        $target
        hr
        $Operation = 'open file, re-use window'
        $DataDir | write-color blue
        hr
        $CodeBin.FullName | write-color 'yellow'
        $codeArgs | Join-String -sep ' ' -op ' $codeArgs: '

        $metaInfo += @{
            Operation     = $operation
            FinalCodeArgs = $codeArgs
        }


        if ($PSCmdlet.ShouldProcess("($BinCode, $DataDir)", "$Target")) {

            Start-Process -path $CodeBin -args $codeArgs -WindowStyle Hidden -Verbose -WhatIf
        }

        return
    }




    end {
        Write-Warning 'checklist:
    - [ ] resume session
    - [ ] open file (append to session)
    - [ ] and from pipeline
    - [ ] --status
    - [ ] --log <level>
    - [ ] --wait
    - [ ] --inspect-brk-extensions <port>
    - [ ] --status
    - [ ] --verbose

'
        Format-Dict $MetaInf | Write-Information
    }
}
