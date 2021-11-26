$experimentToExport.function += @(
    'Invoke-VSCodeViewError'
    '_processErrorRecord_AsLocation'
)
$experimentToExport.alias += @(
    'gotoError'
)

function _processErrorRecord_AsLocation {
    <#
    .synopsis
        Tested on error records
    .notes
        see: https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.InvocationInfo?view=powershellsdk-7.0.0
    .outputs
        [nin.VSCodeFilepath]
    .link
        Dev.Nin\ConvertFrom-ScriptExtent
    .link
        System.Management.Automation.InvocationInfo
    .link
        System.Management.Automation.CmdletInvocationException
    .link
        System.Management.Automation.ErrorRecord

    #>
    param(
        # ErrorRecord (or info?)
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )
    process {
        $InputObject.GetType() | str prefix 'type: '
        | Write-Debug

        if ($InputObject -is 'System.Management.Automation.CmdletInvocationException') {
            $InputObject.GetType().Name
            | str prefix 'was: '
            | str suffix 'trying: attempting: $_.ErrorRecord'
            | Write-Debug

            $input_record = $InputObject.ErrorRecord
        }
        else {
            $input_record = $InputObject
        }
        if ($Null -eq $input_record) {
            Write-Error 'Failed to find ErrorRecord'
            return
        }

        $iinfo = $input_record.InvocationInfo
        # # $iinfo = $InputObject.InvocationInfo
        # $Path = $iinfo.ScriptName | Get-Item
        # $Line = $iinfo.ScriptLineNumber
        # $iinfo.PositionMessage | wi

        # # https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.errorrecord?view=powershellsdk-7.0.0
        # # [pscustomobject]@{
        # #     # todo: mergeg into nin.VSCodeFilepath
        # #     PSTypeName = 'nin.'
        # #     Path       = $Path ;
        # #     LineNumber = $Line
        # # }

        # if ($iinfo.DisplayScriptPosition) {
        #     'Found "$Info.DisplayScriptPosition"' | Write-Debug
        #     $iinfo.DisplayScriptPosition | Format-Table | Out-String | Write-Debug

        # }

        # $iinfo.DisplayScriptPosition # [IScriptExtent]
        # Line
        # OffsetInLine
        # PositionMessage
        # ScriptLineNumber
        # ScriptName
        if (!($iinfo.ScriptName)) {
            $x = 'bad'
        }

        $maybePath = $iinfo.ScriptName | Get-Item -ea ignore
        $maybePath ??= $iinfo.ScriptName

        $meta = [ordered]@{
            PSTypeName      = 'nin.VSCodeFilepath'
            ColumnNumber    = $iinfo.OffsetInLine
            HasLocation     = $True # to be script property
            LineNumber      = $iinfo.ScriptLineNumber
            Path            = $iinfo.ScriptName
            PositionMessage = $iinfo.PositionMessage
            PSPath          = $maybePath
        }
        [pscustomobject]$meta
    }
}

function Invoke-VSCodeViewError {
    <#
    .synopsis
        jumps to code for an errorRecord. terrible name.
    .description

        jumps to module's source, or its directory
    .outputs
        [string] or none
    .example
    #>
    [Alias('gotoError')]
    [cmdletbinding()]
    param(
        # Only read some errors. future: add pagination cmldetbinding
        [Alias('Max', 'L')]
        [parameter()]
        [int]$Limit = 1,

        # return filepaths, don't open
        [parameter()]
        [switch]$PassThru,

        # return filepaths, don't open
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )
    begin {
        $inputList = [list[object]]::new()
    }
    process {
        $InputObject | ForEach-Object {
            $inputList.Add( $_ )
        }
    }
    end {
        $InputList | ForEach-Object {
            $curItem = $_
            $record = $curItem | _processErrorRecord_AsLocation
            if ($PassThru) {
                $record
            }
            else {
                code-venv -path $Record.Path -line $Record.LineNumber -Column   $Record.ColumnNumber
            }
        }
    }
}
# $savedErr[0]
#     hr 2
#     _processErrorRecord $savedErr[0]

#     $inputList
#     | Select-Object -First $Limit
#     | ForEach-Object {
#         @(
#             'Found: '
#             $_
#         ) | Join-String | Write-Information
#     }
# }
# }
