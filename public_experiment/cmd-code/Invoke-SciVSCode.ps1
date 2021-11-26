using namespace System.Collections.Generic

$experimentToExport.function += @(
    'Invoke-SciVSCode'
)
$experimentToExport.alias += @(
    # 'CodeSci'
)
$global:PathToVSCodeOverride ??= 'code'


function Invoke-SciVSCode {
    <#
    .synopsis
        invoke or pipe to vs code to open files

    .notes
        - validate filepaths
        - use "-g" to support filenames with numbers
    #>
    [Alias('CodeSci')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, ValueFromRemainingArguments)]
        [string]
        $Path
    )
    begin {
        # $code = $global:PathToVSCodeOverride | ?? { 'C:\Program Files\Microsoft VS Code\Code.exe' }
        $code = $global:PathToVSCodeOverride ?? (Get-NativeCommand code)
        $pathList = [List[string]]::new()
    }
    process {
        if (-not $Path) {
            return
        }
        $pathList.Add($Path)
    }
    end {
        throw 'finish writing this. it uses FormatScriptExtent too'
        if (-not $pathList) {
            & $code
            return
        }
        $Path = $pathList

        foreach ($item in $pathList) {
            $extraArgs = ($item = Get-Item $Path -ea 0) -and $item.PSIsContainer | ?? { '' } : { '-r' }
            & $code $pathList $extraArgs
        }
    }
}
