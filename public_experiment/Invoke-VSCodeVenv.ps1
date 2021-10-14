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
    [cmdletbinding(PositionalBinding = $false, DefaultParameterSetName = 'OpenFile')]
    param(
        # which venv
        [Alias('VEnv')]
        [Parameter()]
        # [string]$VirtualEnv = 'J:\vscode_port\VSCode-win32-x64-1.57.1\Code.exe',
        # todo: make DynamicCompleter

        [ValidateSet(('J:\vscode_port\VSCode-win32-x64-1.61.0-insider\bin\code-insiders.cmd',
                'J:\vscode_port\VSCode-win32-x64-1.57.1\bin\code.cmd'))]
        [string]$VirtualEnv = 'J:\vscode_port\VSCode-win32-x64-1.61.0-insider\bin\code-insiders.cmd',

        # File
        [Alias('Path', 'PSPath', 'File')]
        [Parameter(
            ParameterSetName = 'OpenFile',
            Mandatory, Position = 0,
            ValueFromPipelineByPropertyName = 'PSPath', ValueFromPipeline
        )]
        [string]$TargetPath,

        # WhatIf
        [Parameter()][switch]$WhatIf,

        # Open the app to resume sessions
        [Alias('Start')]
        [Parameter(
            Mandatory, ParameterSetName = 'Resume'
        )]
        [switch]$ResumeSession

        # args to vs code instead
        # [Parameter(Mandatory, ParameterSetName = 'ExplicitArgs')]
        # [string[]]$ArgsRest
        # # Args to code
        # [Parameter(AttributeValues)]
        # [ParameterType]
        # $ParameterName]
    )
    begin {}
    process {}
    end {
        Write-Warning 'checklist:
    - [ ] resume session
    - [ ] open file (append to session)
    - [ ] and from pipeline
'
    }
}
