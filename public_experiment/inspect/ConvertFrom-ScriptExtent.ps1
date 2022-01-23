#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        # 'ConvertFrom-ScriptExtent'
        'New-VsCodeFilepath'
        '_renderVsCodeGotoPath'

    )
    $experimentToExport.alias += @(
        # 'ConvertTo-VsCodeFilepath'
        # 'Format-ScriptExtentToVscodeFilepath'

    )
}
$sample = 'C:\Users\cppmo_000\SkyDrive\Documents\2021\dotfiles_git\powershell\Ninmonkey.Profile\Ninmonkey.Profile.psm1:964'
$regex = @'
(?x)
    (?<First>^.*)
    (?<Line>\d+$)
'@

function _renderVsCodeGotoPath {
    <#
    .synopsis
        creates a string containing filepath, optional line, optional column
    #>
    [OutputType('System.String')]
    param(
        [Alias('Name', 'PSPath')]
        [parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [object]$InputObject,

        [Parameter(Position = 1)]
        [int]$Line,

        [Parameter(Position = 2)]
        [int]$Column
    )
    process {

        $Render = @(
            $Path
            if ($Line) {
                ":$Line"
            }
            if ($Column) {
                ":$Column"
            }
        ) | Join-String -DoubleQuote -sep ''
        $Render

    }

}

class VsCodeFilePath {
    [string]$Path
    [uint]$Line
    [uint]$Column

    #  Possible input types;
    #         gi .\Invoke-BuildGenerateAll.ps1 | % gettype | Fullname
    #         [System.IO.FileInfo]
    [string]ToString() {

        # $template_all = @(
        #     '-r'
        #     '-g'
        #     '""{0}:{1}:{2}""' -f @(
        #         $Path
        #         $Meta.StartLineNumber
        #         $Meta.StartColumnNumber
        #     )
        # )
        $TemplateStrGo = '--goto '
        # $TemplateStrPath = @(
        #     @(
        #         $This.Path.ToString()
        #         if ($This.Line) {
        #             ":$This.Line"
        #         }
        #         if ($This.Column) {
        #             ":$This.Column"
        #         }

        #     ) | Join-String -DoubleQuote -sep ''

        # )
        # '"{0}{1}{2}"' -f @(
        #     # $Path
        #     $Target.FullName
        #     if($Path)
        #     $LineNumber ?? 0
        #     $ColumnNumber ?? 0
        # )

        $render = ('"{0}"' -f $This.Path.ToString())
        return $render
    }
}
# function ConvertTo-VsCodeFilepath {
function New-VSCodeFilepath {
    <#
    .synopsis
        jump to line number in a file, assumes it's not a folder
    .description
       .
        code --help synatx:
            # actual use: --goto <file:line[:character]>
    .notes
        todo checklist: convert from:
        - [ ] text filepath with columns
        - [ ] convertFrom RipGrep output (--json)
        - [ ] ScriptBlock / ScriptExtent
            see existing: Dev.Nin\ConvertFrom-ScriptExtent
        - [ ] Exception/ErrorRecord

    .example
          .
    .outputs
          [string | None]

    #>
    [Alias('VsCodePath'
        # ,'ConvertTo-VSCodePath'
    )]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Alias('PSPath', 'Path', 'Name')]
        [Parameter(
            Mandatory, Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [object]$InputObject
    )

    begin {
    }
    process {
        # maybe path with numbers?
        # $path

        # TryFor line numbers
        if (Test-IsDirectory $InputObject) {
            Write-Error "'$InputObject' is a directory"
            return
        }
        $path = Get-Item -Path $InputObject
        $meta = @{
            PSTypeName   = 'nin.VSCodeFilepath'
            PSPath       = $Path.PSPath
            Path         = $Path
            HasLocation  = $True # to be script propertyh
            LineNumber   = $Null
            ColumnNumber = $null
        }
        [pscustomobject]$meta

    }
    end {
    }
}


function ConvertFrom-ScriptExtent {
    <#
    .synopsis
        convert type 'script extent' to vs code's filepath
    .inputs
        a [System.Management.Automation.Language.InternalScriptExtent]
    .example
        PS> $Sample = 'System.Management.Automation.Language.InternalScriptExtent'

    .notes
        - [ ] future:
            support script locations from [ErrorRecord] and [Exception]

        maybe related:

        [Selected.System.Management.Automation.Language.InternalScriptExtent]
        [ComponentModel.ITypeDescriptorContext]
        [ComponentModel.ITypeDescriptorContextSystem.Management.Automation.Language.IScriptExtent]
        [Management.Automation.Language.InternalScriptExtent]
        [Management.Automation.Language.IScriptExtent]
        [Management.Automation.Language.ScriptExtent]

    #>
    [Alias(
        'ConvertTo-VsCodeFilepath',
        'Format-ScriptExtentToVscodeFilepath'

    )]
    [OutputType([string])]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # input objects
        [Alias('Script', 'Extent')]
        [Parameter(Mandatory, Position = 0)]
        [object]$InputObject
    )

    begin {
        $ExpectedProperties = @(
            'EndColumnNumber'
            'EndLineNumber'
            'EndOffset'
            'EndScriptPosition'
            'File'
            'StartColumnNumber'
            'StartLineNumber'
            'StartOffset'
            'StartScriptPosition'
        )
        $RequiredProperties = @(
            'File'
            'StartLineNumber'
        )
    }
    process {

        <#
                ScriptBlock.Ast.Extent
                    check type from editfunc
            #>

        switch ($InputObject.GetType()) {
            [System.Management.Automation.Language.InternalScriptExtent] {
                'do normal' | Write-Warning
            }
            [Selected.System.Management.Automation.Language.InternalScriptExtent] {
                'todo: Its''s a PSCO of an extent' | Write-Warning
            }
            [System.Management.Automation.Language.InternalScriptPosition] {
                'todo: Its''s a PSCO of an extent' | Write-Warning
                <#
                    🐒> (editfunc editfunc -PassThru).StartScriptPosition | iprop

                    Name         TypeNameStr ValueStr
                    ----         ----------- --------
                    File         [String]    C:\Users\cppmo_000\Documents\2021\Pow
                    LineNumber   [Int32]     1
                    ColumnNumber [Int32]     1
                    Line         [String]    function Edit-FunctionSource {…
                    Offset       [Int32]     0
                #>
            }
            [PSCustomObject] {
                'todo: test if it has props'
                $RequiredProps = 'File', 'StartScriptPosition', 'EndScript'
            }
            default {
                throw "Unhandledtype: $Switch"
            }
        }
    }
    end {
    }
}


if (! $experimentToExport) {
    # ...
}
