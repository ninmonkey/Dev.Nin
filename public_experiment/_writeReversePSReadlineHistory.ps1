# $experimentToExport.function += 'Measure-ChildItem'
# $experimentToExport.alias += 'LsSize'
# tags: experiment, test


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

    }
}
