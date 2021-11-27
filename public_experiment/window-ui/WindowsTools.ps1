#Requires -Version 7
using namespace System.Collections.Generic
using namespace System.Text

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Close-OpenWindow'
        'Get-OpenWindow',
        'Get-WindowPosition'
        'Maximize-Window'
        'Minimize-Window'
        'Restore-Window', 
        'Set-WindowPosition'
    )
    $experimentToExport.alias += @(
        'Window->Close',
        'Window->Get'
        'Window->GetPosition'
        'Window->Maximize'
        'Window->Minimize'
        'Window->Restore'
        'Window->SetPosition'
        
    )
}


<#
original source was from:
    indented-automation/WindowTools.ps1
    <https://gist.github.com/indented-automation/cbad4e0c7e059e0b16b4e42ba4be77a1>

#>
Add-Type -TypeDefinition '
    using System;
    using System.Runtime.InteropServices;
    using System.Text;

    public class WindowTools
    {
        public delegate bool EnumWindowsProc(IntPtr hWnd, int lParam);

        [DllImport("user32.dll")]
        public static extern bool EnumWindows(EnumWindowsProc enumFunc, int lParam);

        [DllImport("user32.dll")]
        public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

        [DllImport("user32.dll")]
        public static extern IntPtr GetShellWindow();

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

        [DllImport("user32.dll")]
        public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

        [DllImport("user32.dll")]
        public static extern int GetWindowTextLength(IntPtr hWnd);

        [DllImport("user32.dll")]
        public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);

        [DllImport("user32.dll")]
        public static extern bool IsWindowVisible(IntPtr hWnd);

        [DllImport("user32.dll")]
        public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, int uFlags);

        [DllImport("user32.dll")]
        public static extern bool CloseWindow(IntPtr hWnd);

        [DllImport("user32.dll")]
        public static extern int SendMessage(IntPtr hWnd, uint Msg, uint wParam, uint lParam);
    }

    public struct RECT
    {
        public int Left;        // x position of upper-left corner
        public int Top;         // y position of upper-left corner
        public int Right;       // x position of lower-right corner
        public int Bottom;      // y position of lower-right corner
    }
'

enum WindowMessage {
    WM_SYSCOMMAND = 0x0112
}

enum WindowCommand {
    SC_CLOSE = 0xF060
    SC_CONTEXTHELP = 0xF180
    SC_DEFAULT = 0xF160
    SC_HOTKEY = 0xF150
    SC_HSCROLL = 0xF080
    SCF_ISSECURE = 0x00000001
    SC_KEYMENU = 0xF100
    SC_MAXIMIZE = 0xF030
    SC_MINIMIZE = 0xF020
    SC_MOVE = 0xF010
    SC_RESTORE = 0xF120
}

class OpenWindow {
    [string] $Title
    [IntPtr] $Handle
    [uint]   $ProcessID
}

function Get-OpenWindow {
    [Alias('Window->Get')]
    [CmdletBinding()]
    param (
        # wildcard patterns
        [Parameter(Position = 0, ValueFromPipeline)]
        [string]$Name = '*'
    )

    
    process {
        $handles = [List[IntPtr]]::new()
        $shellWindowhWnd = [WindowTools]::GetShellWindow()
    
        $null = [WindowTools]::EnumWindows(
            {
                param (
                    [IntPtr] $handle,
                    [int]    $lParam
                )
    
                if ($handle -eq $shellWindowhWnd) {
                    return $true
                }
    
                if (-not [WindowTools]::IsWindowVisible($handle)) {
                    return $true
                }
    
                $handles.Add($handle)
    
                return $true
            },
            0
        )
    
        foreach ($handle in $handles) {
            $titleLength = [WindowTools]::GetWindowTextLength($handle)
            if ($titleLength -gt 0) {
                $titleBuilder = [StringBuilder]::new($titleLength)
                $null = [WindowTools]::GetWindowText(
                    $handle,
                    $titleBuilder,
                    $titleLength + 1
                )
                $title = $titleBuilder.ToString()
    
                if ($title -like $Name) {
                    $processID = 0
                    $null = [WindowTools]::GetWindowThreadProcessId(
                        $handle,
                        [ref]$ProcessID
                    )
    
                    [OpenWindow]@{
                        Title     = $title
                        Handle    = $handle
                        ProcessId = $ProcessID
                    }
                }
            }
        }
    }
}

function Close-Window {
    [Alias('Window->Close')]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High', DefaultParameterSetName = 'ByName')]
    param (
        [Parameter(Mandatory, Position = 1, ParameterSetName = 'ByName')]
        [String]$Name,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'FromInputObject')]
        [OpenWindow]$InputObject
    )

    begin {
        if ($Name) {
            Get-OpenWindow -Name $Name | Close-Window
        }
    }

    process {
        if ($pscmdlet.ParameterSetName -eq 'FromInputObject') {
            if ($pscmdlet.ShouldProcess('Closing window {0}' -f $InputObject.Title)) {
                $null = [WindowTools]::SendMessage(
                    $InputObject.Handle,
                    [UInt32][WindowMessage]::WM_SYSCOMMAND,
                    [UINt32][WindowCommand]::SC_CLOSE,
                    0
                )
            }
        }
    }
}

function Minimize-Window {
    [Alias('Window->Minimize')]

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ByName')]
    param (
        [Parameter(Mandatory, Position = 1, ParameterSetName = 'ByName')]
        [String]$Name,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'FromInputObject')]
        [OpenWindow]$InputObject
    )

    begin {
        if ($Name) {
            Get-OpenWindow -Name $Name | Minimize-Window
        }
    }

    process {
        if ($pscmdlet.ParameterSetName -eq 'FromInputObject') {
            if ($pscmdlet.ShouldProcess('Minimising window {0}' -f $InputObject.Title)) {
                $null = [WindowTools]::SendMessage(
                    $InputObject.Handle,
                    [UInt32][WindowMessage]::WM_SYSCOMMAND,
                    [UINt32][WindowCommand]::SC_MINIMIZE,
                    0
                )
            }
        }
    }
}

function Restore-Window {
    [Alias('Window->Restore')]
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ByName')]
    param (
        [Parameter(Mandatory, Position = 1, ParameterSetName = 'ByName')]
        [String]$Name,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'FromInputObject')]
        [OpenWindow]$InputObject
    )

    begin {
        if ($Name) {
            Get-OpenWindow -Name $Name | Restore-Window
        }
    }

    process {
        if ($pscmdlet.ParameterSetName -eq 'FromInputObject') {
            if ($pscmdlet.ShouldProcess('Restoring window {0}' -f $InputObject.Title)) {
                $null = [WindowTools]::SendMessage(
                    $InputObject.Handle,
                    [uint][WindowMessage]::WM_SYSCOMMAND,
                    [uint][WindowCommand]::SC_RESTORE,
                    0
                )
            }
        }
    }
}

function Maximize-Window {
    [Alias('Window->Maximize')]
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ByName')]
    param (
        [Parameter(Mandatory, Position = 1, ParameterSetName = 'ByName')]
        [String]$Name,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'FromInputObject')]
        [OpenWindow]$InputObject
    )

    begin {
        if ($Name) {
            Get-OpenWindow -Name $Name | Maximize-Window
        }
    }

    process {
        if ($pscmdlet.ParameterSetName -eq 'FromInputObject') {
            if ($pscmdlet.ShouldProcess('Restoring window {0}' -f $InputObject.Title)) {
                $null = [WindowTools]::SendMessage(
                    $InputObject.Handle,
                    [uint][WindowMessage]::WM_SYSCOMMAND,
                    [uint][WindowCommand]::SC_MAXIMIZE,
                    0
                )
            }
        }
    }
}

function Get-WindowPosition {
    [Alias('Window->GetPosition')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'FromInputObject')]
        [OpenWindow]$InputObject
    )

    process {
        $rect = [RECT]::new()

        $null = [WindowTools]::GetWindowRect(
            $InputObject.Handle,
            [ref]$rect
        )

        [PSCustomObject]@{
            Title     = $InputObject.Title
            Handle    = $InputObject.Handle
            ProcessID = $InputObject.ProcessID
            Left      = $rect.Left
            Top       = $rect.Top
            Right     = $rect.Right
            Bottom    = $rect.Bottom
        }
    }
}

function Set-WindowPosition {
    [Alias('Window->SetPosition')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'FromInputObject')]
        [OpenWindow]$InputObject,

        # The Y position of the window.
        [int]$Top,

        # The X position of the window.
        [int]$Left
    )

    process {
        $null = [WindowTools]::SetWindowPos(
            $InputObject.Handle,
            $null,
            $Left,
            $Top,
            -1,
            -1,
            1
        )
    }
}

if (! $experimentToExport) {
    # ...
}