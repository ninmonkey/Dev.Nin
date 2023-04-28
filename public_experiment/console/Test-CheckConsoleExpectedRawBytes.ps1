function Test-CheckConsoleExpectedRawBytes {
    <#

https://discord.com/channels/180528040881815552/447476117629304853/963968380996579328

    .example
        $OutputEncoding = [Console]::InputEncoding = [Console]::OutputEncoding = [Text.Encoding]::UTF8

        $string = 'café'
        $stringBytes = $OutputEncoding.GetBytes($string)
        $stringB64 = [Convert]::ToBase64String($stringBytes)

        $null = $string | powershell.exe -NoLogo -File C:\temp\proc_io.ps1 -Path input-1 $stringB64
        Format-Hex -Path input-1

        $OutputEncoding = [Console]::InputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::new()

        $null = $string | powershell.exe -NoLogo -File C:\temp\proc_io.ps1 -Path input-2 $stringB64
        Format-Hex -Path input-2

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Path, # The file the script should write the raw stdin bytes to.

        [Parameter(Mandatory)]
        [string]
        $OutputData, # Base64 encoded bytes that the script should output to the stdout pipe.

        # Raw = raw FileStream read and write with bytes
        # .NET = [Console]::Read and [Console]::Write ($Path and $OutputData are treated as UTF-8)
        [Parameter()]
        [ValidateSet('Raw', '.NET')]
        [string]
        $Method = 'Raw',

        [int]
        $InputCodepage = $null,

        [int]
        $OutputCodepage = $null
    )

    Add-Type -TypeDefinition @'
using Microsoft.Win32.SafeHandles;
using System;
using System.Runtime.InteropServices;

namespace RawConsole
{
    public class NativeMethods
    {
        [DllImport("Kernel32.dll")]
        public static extern int GetConsoleCP();

        [DllImport("Kernel32.dll")]
        public static extern int GetConsoleOutputCP();

        [DllImport("Kernel32.dll")]
        public static extern SafeFileHandle GetStdHandle(
            int nStdHandle);

        [DllImport("Kernel32.dll")]
        public static extern bool SetConsoleCP(
            int wCodePageID);

        [DllImport("Kernel32.dll")]
        public static extern bool SetConsoleOutputCP(
            int wCodePageID);
    }
}
'@

    $origInputCP = [RawConsole.NativeMethods]::GetConsoleCP()
    $origOutputCP = [RawConsole.NativeMethods]::GetConsoleOutputCP()

    if ($InputCodepage) {
        [void][RawConsole.NativeMethods]::SetConsoleCP($InputCodepage)
    }
    if ($OutputCodepage) {
        [void][RawConsole.NativeMethods]::SetConsoleOutputCP($OutputCodepage)
    }

    try {
        $outputBytes = [Convert]::FromBase64String($OutputData)
        $utf8NoBom = [Text.UTF8Encoding]::new($false)

        if ($Method -eq 'Raw') {
            $stdinHandle = [RawConsole.NativeMethods]::GetStdHandle(-10)
            $stdinFS = [IO.FileStream]::new($stdinHandle, 'Read')

            $stdoutHandle = [RawConsole.NativeMethods]::GetStdHandle(-11)
            $stdoutFS = [IO.FileStream]::new($stdoutHandle, 'Write')

            $inputRaw = [byte[]]::new(1024)
            $inputRead = $stdinFS.Read($inputRaw, 0, $inputRaw.Length)
            $outputFS = [IO.File]::Create($Path)
            $outputFS.Write($inputRaw, 0, $inputRead)
            $outputFS.Dispose()

            $stdoutFS.Write($outputBytes, 0, $outputBytes.Length)

            $stdinFS.Dispose()
            $stdinHandle.Dispose()

            $stdoutFS.Dispose()
            $stdoutHandle.Dispose()
        } elseif ($Method -eq '.NET') {
            $inputRaw = [Text.StringBuilder]::new()
            while ($true) {
                $char = [Console]::Read()
                if ($char -eq -1) {
                    break
                }

                [void]$inputRaw.Append([char]$char)
            }
            [IO.File]::WriteAllText($Path, $inputRaw.ToString(), $utf8NoBom)

            $outputString = $utf8NoBom.GetString($outputBytes)
            [Console]::Write($outputString)
        }
    } finally {
        [void][RawConsole.NativeMethods]::SetConsoleCP($origInputCP)
        [void][RawConsole.NativeMethods]::SetConsoleOutputCP($origOutputCP)
    }

}
