#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_writeReverseHistory'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}


function _writeReverseHistory {
    [cmdletbinding()]
    param(

    )
    begin {
        $Paths = @{
            PSReadLine        = Get-Item -ea ignore 'C:\Users\cppmo_000\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt'
            PSReadLine_vscode = Get-Item -ea ignore 'C:\Users\cppmo_000\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\Visual Studio Code Host_history.txt'
            ExportPath        = Join-Path (Get-Item -ea stop 'c:\nin_temp') 'PSReadlineHistory_Ordered'
        }


    }
    process {
        Write-Error 'NotYetImplemented' -Category NotImplemented
        # [System.Management.Automation.ErrorRecord]::new(
        #     <# exception: #> $null,
        #     <# errorId: #> 'NotYetImplemented',
        #     <# errorCategory: #> ([System.Management.Automation.ErrorCategory]::NotImplemented),
        #     <# targetObject: #> $null)
        # # write-warning 'no-op: wip'
    }
}


if (! $experimentToExport) {
    # ...
}
