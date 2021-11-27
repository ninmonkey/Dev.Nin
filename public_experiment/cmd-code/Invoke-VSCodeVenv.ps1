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



function __format_HighlightVenvPath {
    <#
    .synopsis
        colorizes breadcrumb to emphasize version number
    .example
        'J:\vscode_port\VSCode-win32-x64-1.62.0-insider\bin\code-insiders.cmd'
        | __format_HighlightVenvPath
        | Format-ControlChar
        | Should -be 'J:\vscode_port\␛[96mVSCode-win32-x64-1.62.0-insider\␛[39mbin\code-insiders.cmd'


    #>
    param(
        [Alias('Path')]
        [parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$InputObject
    )
    begin {
        $Colors = @{
            Bold = 'cyan'
            Dim  = 'gray40'
        }
        $Regex = @{
            NumberCrumb                       = @'
(?x)
(?<Crumb>
   [^\\]+
   \d+
   # [^\\]+
   .*?
)
(?:\\)
'@
            NumberCrumbFullLines              = @'
(?x)
(?<Prefix>
.*)
(?<Crumb>
   [^\\]+
   \d+
   # [^\\]+
   .*?
)
(?:\\)
(?<Suffix>.*)
'@
            LargeRegexAttemptDoesNotFullyWork = @'
(?x)
^
(?<FullName>
  .+
)
# --goto <file:line[:character]> Open a file
(?<Suffix>
  \:
  (?:
    \:
    (?<Line>\d+)
  )?
  (?:
    \:
    (?<Column>\d+)
  )?
)
$
'@

        }
    }
    process {
        $InputObject -replace $Regex.NumberCrumb, { $_ | Write-Color -fg $Colors.Bold | Join-String }

    }
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
        🐒> gi .\normalize.css | Code-vEnv
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
        [Alias('Path')] #, 'PSPath')]
        [Parameter(
            # ParameterSetName = 'OpenItem',
            Position = 0,
            ValueFromPipelineByPropertyName,
            ValueFromPipeline
        )]
        [string]$TargetPath = '.',

        [Parameter()]
        [string]$DataDir = 'J:\vscode_datadir\games',

        # which mode, reuse/new
        [alias('Mode')]
        [parameter(
            # ParameterSetName = 'OpenItem',
            position = 1
        )]
        [validateSet('ReuseWindow', 'NewWindow')]
        [string]$WindowMode = 'ReuseWindow',

        # Open the app to resume sessions
        [Alias('Start', 'Restart')]
        [Parameter()]
        [switch]$ResumeSession,

        # info
        # --version and extension info
        [Parameter(ParameterSetName = 'OnlyHelpInfo')]
        [switch]$Version,

        # --help
        [Parameter(ParameterSetName = 'OnlyHelpInfo')]
        [switch]$Help,

        # what line?
        [Alias('Line')]
        [Parameter()]
        [uint]$LineNumber,

        # what column?
        [Alias('Col')]
        [Parameter()]
        [uint]$ColumnNumber,

        [Alias('ExtraArgs')]
        [Parameter(ValueFromRemainingArguments)]
        [string]$RemainingArgs,

        # return paths, but don't run code
        [alias('GetCurrentBin')]
        [Parameter()]
        [switch]$PassThru



        # args to vs code instead
        # [Parameter(Mandatory, ParameterSetName = 'ExplicitArgs')]
        # [string[]]$ArgsRest
        # # Args to code
        # [Parameter(AttributeValues)]
        # [ParameterType]
        # $ParameterName]
    )
    begin {

    }
    process {
        # try {

        function  __printCodeArgs {
            "execute: $codeBin" | Write-Color 'gray40'
            | Write-Information
            $CodeArgs | Join-String -sep ' ' | Write-Color 'gray40'
            | Write-Information
        }


        $metaInfo = [ordered]@{}

        # $CodeBin = Get-Item -ea stop 'J:\vscode_port\VSCode-win32-x64-1.62.0-insider\bin\code-insiders.cmd'
        # first try default, else fallback
        $splatSilent = @{'ErrorAction' = 'SilentlyContinue' }
        $CodeBin = @(
            # todo: add user's saved value as the first part
            # Explicitly tries 'code[insiders].cmd' to bypass any global handler aliases.
            Get-Item @splatSilent "${Env:LOCALAPPDATA}\Programs\Microsoft VS Code Insiders\bin\code-insiders.cmd"
            Get-Command code-insiders.cmd -CommandType Application @splatSilent

            # paths differ because ? local user install?
            Get-Item @splatSilent 'C:\Program Files\Microsoft VS Code\bin\code.cmd'
            Get-Command @splatSilent code.cmd -All -CommandType Application
            Get-Command @splatSilent code-insiders -All -CommandType Application
            Get-Command @splatSilent code -All -CommandType Application
        ) | Select-Object -First 1
        if (! $CodeBin) {
            throw 'Did not find any code-insider instances' ; return;
        }
        try {
            $DataDir = Get-Item -ea stop $DataDir
        } catch {
            Write-Error -ea continue "Invalid $dataDir = '$dataDir'. $_"
            Write-Warning 'falling back to implicit default path'
        }
        try {
            $target = Get-Item -ea ignore $TargetPath
        } catch {
            Write-Error -ea stop 'Invalid Path'
            # Write-Error -ErrorRecord $_ 'Invalid path' # todo: research best method
        }

        @(
            if (Test-IsDirectory $target) {
                hr
                'Open 📁 a directory?'
                | Write-Color 'blue'
                hr

            } else {
                hr
                'Open 📄 File?' | Write-Color 'blue'
                hr
            }
        ) | Wi

        [string[]]$codeArgs = @()

        # Exit Early functions
        if ($Version) {
            & $CodeBin @('--list-extensions')
            | Join-String -op (hr 2) -os (hr 2) -sep "`n"

            & $CodeBin @('--list-extensions', '--show-versions')
            | ForEach-Object { $_ -replace '@', ': ' }
            | Join-String -op (hr 2) -os (hr 2) -sep "`n"

            & $CodeBin @('--version')
            | Join-String -sep ', ' -op (Write-Color orange -t 'Version: ')

            return
        }
        if ($Help) {
            & $CodeBin @('--help')
            return
        }
        if ($PassThru) {
            # GetCurrentBin
            [pscustomobject]@{
                PSTypeName   = 'nin.CodeVenv.Config'
                CodeBinPath  = $CodeBin
                UserDataDir  = $DataDir ?? $Null
                ExtensionDir = 'nyi'
            }
            return
        }



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
        if ($ResumeSession) {

            if ($PSCmdlet.ShouldProcess("($CodeBin, $DataDIr)", 'ResumeSession')) {

                __printCodeArgs
                Start-Process -path $CodeBin -args $codeArgs -WindowStyle Hidden
                return
            }
        }
        ## now more

        if (Test-IsDirectory $target) {
            $CodeArgs += @(
                # '--add' modifier will *always* use an existing window
                if ($WindowMode -eq 'ReuseWindow') {
                    '--add'
                }
                Get-Item $Target | Join-String -DoubleQuote
            )
        } else {
            # always use goto, even without line numbers. it's more resistant to errors
            if (! $LineNumber) {
                'LineNumber? Y' | Write-Color green | wi
                $CodeArgs += @(
                    '--goto'
                    (Get-Item $Target | Join-String -DoubleQuote)
                )
            } else {
                'LineNumber? Y' | Write-Color green | wi
                $codeArgs += @(
                    '--goto'
                    '"{0}:{1}:{2}"' -f @(
                        # $Path
                        $Target.FullName
                        $LineNumber ?? 0
                        $ColumnNumber ?? 0
                    )
                )
            }
        }

        if (! [string]::IsNullOrWhiteSpace($RemainingArgs )) {
            $CodeArgs += $RemainingArgs
        }

        if ($True) {
            # any non-finished invokes
            $strTarget = $target | Join-String -sep ' ' -DoubleQuote
            $StrOperation = $CodeBin, $DataDIr -join ', '

            if (! $Env:NoColor) {

                $StrTarget = $Target | Join-String -sep "`n" -op "`n" -os "`n"

                # bold version number
                $boldBinCode = __format_HighlightVenvPath $CodeBin
                @(
                    "`nCode = "
                    $BoldBinCode
                    "`nDataDir = "
                    $DataDir | Write-Color cyan
                    "`n"
                    $strTarget | Format-RelativePath -BasePath .
                    "`n"
                ) | Join-String

                # $StrOperation = "`nCode = $BoldBinCode", "`nDataDir = $DataDIr"
                # | Join-String -sep "`n" -op "`n" -os "`n"

                # | Join-String -sep "`n" -op "`n" -os "`n"
                # | write-color magenta
                # | write-color magenta
            }


            @(
                hr 1
                $strTarget | Join-String -op '$strTarget: '
                $StrOperation | Join-String -op '$strOperation: '
                $codeArgs | Join-String -sep ' ' -op '***args***'
                hr 1
            ) | wi
            if ($PSCmdlet.ShouldProcess($strTarget, $strOperation)) {
                __printCodeArgs
                Start-Process -path $CodeBin -args $codeArgs -WindowStyle Hidden
            }
        }

        if ($ResumeSession) {
            Write-Color -t 'ResumeSession' 'green' | Write-Information
        } else {
            Write-Color -t 'LoadItem: ' 'orange' | Write-Information
            Write-Color -t $Target 'yellow' | Write-Information
        }
        $metaInfo += @{
            BinCode       = $CodeBin
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


        # $target
        # hr
        # $Operation = 'open file, re-use window'
        # $DataDir | write-color blue
        # hr
        # $CodeBin.FullName | write-color 'yellow'
        # $codeArgs | Join-String -sep ' ' -op ' $codeArgs: '

        $metaInfo += @{
            Operation     = $operation
            FinalCodeArgs = $codeArgs
        }

        # catch {
        #     $PSCmdlet.WriteError( $_ )
        # }
    }




    end {
        Write-Debug 'checklist:
    - [ ] resume session
    - [ ] open file (append to session)
    - [ ] and from pipeline
    - [ ] --status
    - [ ] --log <level>
    - [ ] --wait
    - [ ] --inspect-brk-extensions <port>
    - [ ] --status
    - [ ] --verbose'
        Format-Dict $metaInfo | Write-Information
    }
}
