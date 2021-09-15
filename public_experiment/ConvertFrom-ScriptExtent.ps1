$experimentToExport.function += 'ConvertFrom-ScriptExtent'
# $experimentToExport.alias += 'Format-ScriptExtentToVscodeFilepath'

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
        'Format-ScriptExtentToVscodeFilepath'

    )]
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
    end {}
}
