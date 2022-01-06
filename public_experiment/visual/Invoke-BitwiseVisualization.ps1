#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Invoke-BitwiseVisualization'
    )
    $experimentToExport.alias += @(
    )

    $NotImplementedTags = @(
        # tags, not aliases
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
        ANSI formatting

    .example
        🐒 16 | bits
        | SHould -be '0001.0000'

        🐒 16 | bits | _colorizeBits
        | Format-ControlChar
        | Should -be '␛[38;2;127;127;127m0␛[39m␛[38;2;127;127;127m0␛[39m␛[38;2;127;127;127m0␛[39m␛[38;2;229;229;229m1␛[39m.␛[38;2;127;127;127m0␛[39m␛[38;2;127;127;127m0␛[39m␛[38;2;127;127;127m0␛[39m␛[38;2;127;127;127m0␛[39m'
    #>
    param(
        [AllowNull()]
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$InputText
    )
    process {
        # if($null -eq $InputText) {
        if ([string]::IsNullOrWhiteSpace( $InputText )) {
            return
        }
        $InputText
        | hi -Pattern '1' -Color gray90
        | hi -Pattern '0' -Color gray50
    }

}
function Invoke-BitwiseVisualization {
    <#
    .synopsis
        visualize bitwise operations
    .notes

        see / merge with:
        \nin.com\Dive-of-The-Week\2021-10-13 - DAX bitwise operators\BitwiseAndpowershell.ps1
        \nin.com\Dive-of-The-Week\2021-10-13 - DAX bitwise operators\BitwiseAnd-iter2-visualize.ps1
        \Dev.Nin\public_experiment\Invoke-BitwiseVisualization.ps1
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
    # [Alias(
    #     'Bitwise',
    #     'Bitwise🎨',
    #     'Style🎨.BitwiseVisual',
    #     'Cli_Interactive🖐.BitwiseVisual',
    #     'DevTool💻.BitwiseVisual'
    # )]
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
                    default {
                        throw "Operation NYI: '$Operation'"
                    }
                }

                # } $OperandLeft -bor $OperandRight

                $results = $OperandLeft, $OperandRight, $OperationResult | ForEach-Object {
                    $curOp = $_
                    $renderObj = [ordered]@{
                        Dec  = $curOp
                        # BitsRaw  = $curOp | bits
                        Bits = TRY {
                            $curOp | bits | _colorizeBits
                        } catch {
                            $curOp | bits
                        }
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
                            Bits = "Bitwise $Operation" | Write-Color 'orange'
                        }
                        [pscustomobject]$InnerText
                    }

                    $Results[1]
                    if (! $MinimizeOutput) {
                        $innerText = [ordered]@{
                            Dec  = ''
                            Bits = '=' | Write-Color 'orange'
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
        } else {
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



$Config = @{
    Randomize = $true
}
function _randomEnumValue {
    param(
        [Parameter(Position = 0, Mandatory)]
        # [enum]
        $Enum = [System.Security.AccessControl.FileSystemRights]
    )
    $Enum | Get-EnumInfo | Get-Random -Count 1
}
if (! $experimentToExport) {
    $info_sp = @{
        'InformationAction' = 'continue'
    }
    # ...

    $fsr = [System.Security.AccessControl.FileSystemRights]
    $invokeBitwiseVisualizationSplat = @{
        Operation    = 'or'
        # OperandLeft  = [int]$fsr::Delete
        OperandLeft  = [int]$fsr::TakeOwnership
        # OperandRight = [int]$fsr::ReadAndExecute
        # OperandRight = [int]$fsr::Modify
        # OperandRight = [int]$fsr::ReadAndExecute
        OperandRight = [int]$fsr::Read
    }

    $invokeBitwiseVisualizationSplat | Format-Table


    if ($Config.Randomize) {
        # $invokeBitwiseVisualizationSplat.OperandRight = _randomEnumValue [System.Security.AccessControl.FileSystemRights]
        $invokeBitwiseVisualizationSplat.OperandLeft = [int]($fsr | Get-EnumInfo | Get-Random -Count 1)
        $invokeBitwiseVisualizationSplat.OperandRight = [int]($fsr | Get-EnumInfo | Get-Random -Count 1)

        $invokeBitwiseVisualizationSplat | Format-Table
    }
    if ($false) {
        Invoke-BitwiseVisualization @invokeBitwiseVisualizationSplat -MinimizeOutput:$false
        hr 4
    }
    h1 'info'
    $fsr | Get-EnumInfo
    hr 2

    h1 'verbose'
    Invoke-BitwiseVisualization @invokeBitwiseVisualizationSplat -MinimizeOutput:$false
    | Format-Table -AutoSize


    h1 'Minimize with hidden headers'
    Invoke-BitwiseVisualization @invokeBitwiseVisualizationSplat
    | Format-Table -AutoSize -HideTableHeaders

    h1 'Minimize'
    Invoke-BitwiseVisualization @invokeBitwiseVisualizationSplat
    | Format-Table -AutoSize

    hr
    h1 'modify single row'
    $record = Invoke-BitwiseVisualization @invokeBitwiseVisualizationSplat
    # | Select-Object -First 1

    $propHexSelectStr = @{
        Name       = 'Hex'
        # Width      = 3
        Expression = {
            $_.Dec
            # ('0x{0,8:x}' -f $_.Dec)
        }
        # FormatString = '0,8:x'
        # alignment  = 'right'
    }

    hr
    h1 'custom + header'
    $record | Select-Object Dec, $propHexSelectStr, Bits
    | Format-Table -AutoSize

    hr 1

    h1 'custom - header'
    $record | Select-Object Dec, $propHexSelectStr, Bits
    | Format-Table -HideTableHeaders -AutoSize

    $propHexTable = @{
        Name       = 'Hex'

        Expression = {

            $render = @(
                '0x'
                $_.Dec.ToString('x')
            ) -join ''

            $render.PadLeft(6)
        }
        # FormatString = 'x'
        alignment  = 'right'
    }
    hr
    h1 'flat'
    $splatTable = @{
        AutoSize         = $true
        HideTableHeaders = $true
        Property         = $propHexTable, 'Bits'
    }

    $record | Format-Table @splatTable
    hr
    h1 'labels'
    $splatTable = @{
        AutoSize         = $true
        HideTableHeaders = $true
        Property         = $propHexTable, 'Bits'
    }
    $record | Format-Table @splatTable -HideTableHeaders:$false



    # $tableBitsColor = @{
    #     Name       = 'Bits'
    #     Expression = {
    #         $_ | Out-String | _colorizeBits | ForEach-Object tostring
    #     }
    #     # FormatString = 'x'
    #     # alignment  = 'right'
    # }
    # $fsr | Get-EnumInfo | Format-Table Name, $tableBitsColor -Wrap -AutoSize
    # $fsr | Get-EnumInfo | Format-Table Name, Bits -Wrap -AutoSize
    $propHexTable = @{
        Name       = 'Hex'

        Expression = {

            $render = @(
                '0x'
                $_.Dec.ToString('x')
            ) -join ''

            $render.PadLeft(6)
        }
        # FormatString = 'x'
        alignment  = 'right'
    }
    $formatTableSplat = @{

        Wrap     = $true
        AutoSize = $true
        Property = 'Bits', 'Value', 'Hex' #'Name', 'Dec'
    }

    h1 'oops, tooo much'

    $fsr | Get-EnumInfo
    | Format-Table @formatTableSplat
    | Out-String | _colorizeBits | Out-String



    h1 'just bits'
    $bitsColor = @{
        Name       = 'BitsC'

        Expression = {
            $_.Bits

            # $render = @(
            #     '0x'
            #     $_.Dec.ToString('x')
            # ) -join ''

            # $render.PadLeft(6)
        }
        # FormatString = 'x'
        alignment  = 'right'
    }
    $formatTableSplat = @{

        Wrap     = $true
        AutoSize = $true
        Property = 'BitsC', 'Value', 'Hex' #'Name', 'Dec'
    }
    $render = $fsr | Get-EnumInfo
    | ForEach-Object {
        $_
    }
    # | Add-Member -NotePropertyName 'BitsC' -NotePropertyValue { $this.Bits | _colorizeBits } -PassThru
    $render | Format-Table @formatTableSplat
    $render | ForEach-Object bits | _colorizeBits
    h1 'weird object'

    $targetObj = $render[0]
    $renderobj = [pscustomobject]@{
        Bits  = $targetObj.Bits
        BitsC = $targetObj.Bits | _colorizeBits
        Value = $target.Value
        Name  = $target.Name
    }
    #| Out-String | _colorizeBits | Out-String
    $render | s *
}
