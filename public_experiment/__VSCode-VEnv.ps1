$experimentToExport.function += @(
    '_VSCode-VEnv'
)
$experimentToExport.alias += @(
    'VEnv.VSCode'
)

function _VSCode-VEnv {
    <#
    .synopsis
        when you don't need detailed stats, just a quick ping result
    .link
        Dev.Nin\NetworkTool🌎.SlowNetTest
    #>
    # quick 1 off test
    [Alias('VEnv.VSCode')]
    [CmdletBinding()]
    param(
        [switch]$OpenOnly = $true
    )

    if (! $OpenOnly ) {
        write-error -Category NotImplemented -Message 'see: "code-venv" instead'
    }

    $binCodeEye = gi 'J:\vscode_port\VSCode-win32-x64-1.61.0-insider\bin\code-insiders.cmd' -ea stop
    
    if (! $openOnly) {
        $filename = gi -ea stop 'C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\buffer\2021-09\Parallel-Test-Connection'
        $eyeArgs = @('-r', '-a', $filename)
    }

    $binCodeEye | Join-String -sep ' ' -op 'bin: ' -SingleQuote | Write-Information
    $eyeArgs | Join-String -sep ' ' -op 'args: ' | Write-Information

    if ($OpenOnly) {
        Start-Process -FilePath $binCodeEye
        # & $binCodeEye
    }
    else {
        # & $binCodeEye @eyeArgs
        Start-Process -FilePath $binCodeEye -ArgumentList $eyeArgs
    }


}

