#Requires -Version 7.0.0

# allows script to be ran alone, or, as module import
if (! $DebugInlineToggle -and $experimentToExport) {
    $experimentToExport.function += @(
        'Invoke-BitwiseVisualization'
    )
    $experimentToExport.alias += @(
        'Bitwise'
        'Bitwise🎨'
        'Style🎨.BitwiseVisual'
        'Cli_Interactive🖐.BitwiseVisual'
        'DevTool💻.BitwiseVisual'
    )
}





function _colorizeBits {
    <#.
    .synopsis
        colorize bits for emphasis
    .description
        refactor to colorize a 'Nin.BitString' type
    .example
        🐒 16 | bits
        | SHould -be '0001.0000'

        🐒 16 | bits | _colorizeBits
        | Format-ControlChar
        | Should -be '␛[38;2;127;127;127m0␛[39m␛[38;2;127;127;127m0␛[39m␛[38;2;127;127;127m0␛[39m␛[38;2;229;229;229m1␛[39m.␛[38;2;127;127;127m0␛[39m␛[38;2;127;127;127m0␛[39m␛[38;2;127;127;127m0␛[39m␛[38;2;127;127;127m0␛[39m'
    #>
    param(
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$InputText
    )
    process {
        $InputText
        | hi -Pattern '1' -Color gray90
        | hi -Pattern '0' -Color gray50
    }

}
function Invoke-BitwiseVisualization {
    <#
    .synopsis
        visualize bitwise operations
    .example
        🐒> Invoke-BitwiseVisualization 5 4 -Operation 'And' -MinimizeOutput

            # Plus syntax highlighting
            Dec Bits
            --- ----
            5   0000.0101
            4   0000.0100 Bit-And
            4   0000.0100 =

    .example

        🐒> Invoke-BitwiseVisualization 5 4 -Operation 'And'

            # Plus syntax highlighting
            Dec Bits
            --- ----
            5   0000.0101
                Bitwise And
            4   0000.0100
                =
            4   0000.0100
    #>
    [Alias('Bitwise', 'Bitwise🎨', 'Style🎨.BitwiseVisual', 'Cli_Interactive🖐.BitwiseVisual', 'DevTool💻.BitwiseVisual')]
    [cmdletbinding(PositionalBinding = $false)]
    param(
        # LHS operand in test
        [Alias('Left', 'First', 'Object1')]
        [parameter(Mandatory, Position = 0)]
        [string]$OperandLeft,

        # RHS operand in test
        [Alias('Right', 'Second', 'Object2')]
        [parameter(Mandatory, Position = 1)]
        [string]$OperandRight,

        [alias('Mode')]
        [parameter(Position = 2)]
        [ValidateSet('AND', 'OR', 'all')]
        [string]$Operation = 'all',

        [alias('Tiny')]
        [parameter(Position = 2)]
        [switch]$MinimizeOutput = $true
    )

    begin {

    }
    process {
        $meta = @{
            Left      = $OperandLeft
            Right     = $OperandRight
            Operation = $Operation
        }
        function _processOperation {
            [alias('Mode')]
            param(
                # LHS operand in test
                [Alias('InputObject1')]
                [parameter(Mandatory, Position = 0)]
                [string]$OperandLeft,

                # RHS operand in test
                [Alias('Right', 'Second', 'Object2')]
                [Alias('InputObject2')]
                [parameter(Mandatory, Position = 1)]
                [string]$OperandRight,

                [parameter(Mandatory, Position = 2)]
                [ValidateSet('AND', 'OR')][string]$Operation
            )
            process {
                # [string]$Operation = 'all',
                $OperationResult = switch ($Operation) {
                    'AND' {
                        $OperandLeft -band $OperandRight
                    }
                    'OR' {
                        $OperandLeft -bor $OperandRight
                    }
                    default { throw "Operation NYI: '$Operation'" }
                }

                # } $OperandLeft -bor $OperandRight

                $results = $OperandLeft, $OperandRight, $OperationResult | ForEach-Object {
                    $curOp = $_
                    $renderObj = [ordered]@{
                        Dec  = $curOp
                        # BitsRaw  = $curOp | bits
                        Bits = $curOp | bits | _colorizeBits
                        # warning: order breaks render
                    }
                    if (! $Env:NoColor) {
                        $RenderObj.Bits = $RenderObj.Bits
                    }
                    [pscustomobject]$renderObj

                }

                @(

                    if ( $MinimizeOutput ) {
                        $Results[1].bits += " Bit-$Operation"
                        $Results[2].bits += ' ='
                    }
                    $Results[0]

                    if (! $MinimizeOutput) {
                        $innerText = [ordered]@{
                            Dec  = ''
                            Bits = "Bitwise $Operation" | Write-color 'orange'
                        }
                        [pscustomobject]$InnerText
                    }

                    $Results[1]
                    if (! $MinimizeOutput) {
                        $innerText = [ordered]@{
                            Dec  = ''
                            Bits = '=' | Write-color 'orange'
                        }
                        [pscustomobject]$InnerText
                    }
                    $Results[2]
                )


            }
        }

        if ($Operation -ne 'all' ) {
            _processOperation -OperandLeft $OperandLeft -OperandRight $OperandRight -Operation $Operation
            return
        }
        else {
            'AND', 'OR' | ForEach-Object {
                hr
                $curOperation = $_
                _processOperation -OperandLeft $OperandLeft -OperandRight $OperandRight -Operation $curOperation
            }
        }



        # 'BAND' | write-color orange
        # @(
        #     @( $x | bits | write-color green; $x ) -join '  '
        #     @( $y | bits | write-color green; $y ) -join '  '
        #     $result = $x -band $y
        #     @( $result | bits | write-color green; $result ) -join '  '
        # )


    }
    end {
        $meta | format-dict | Write-Information
    }
}

$info_sp = @{
    'InformationAction' = 'continue'
}
