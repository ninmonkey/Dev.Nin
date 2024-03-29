#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Invoke-MiniFormatDump'

    )
    $experimentToExport.alias += @(
        'FormatDump'
        'fDump'
        # 'A'
    )
}


try {
    $script:__miniFormatDump = @{}
    $state = $script:__miniFormatDump ?? @{}
    # $state = $script:__miniFormatDump ?? @{}

    $state.Help_PSTypeNames = {
        # param($TypeName)
        $TypeName = @($ArgList) | Select-Object -First 1
        $TypeName ??= '[Math]'
        $__doc__ = 'Nicely print out full PSTypeNames to copy -> paste'
        # Wait-Debugger6
        $str_op = @'
<#
PSTypeNames:
'@
        $str_os = @'
#>
'@

        $str_op
        $TypeName | ForEach-Object pstypenames
        | Dev.Nin\Join-StringStyle str "`n" -SingleQuote -Sort -Unique
        | Dev.Nin\Format-IndentText -Depth 2
        $str_os
    }
    $state.'FormatTo.ColorBytes' = {
        param($Text)
        <#
        .synopsis
            dynamically generate rows and cols
        .EXAMPLE
            .
        #>
        process {
            # h1 '_formatColorBytes'
            # $Text | _formatColorBytes
            Write-Warning 'get impl. from: <C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\buffer_format_prototype\Compare-EncodedText.ps1>'

        }
    }
    $state.'FormatTo.Colors' = {
        param($Text)
        <#
        .synopsis
            dynamically generate rows and cols
        .EXAMPLE
            .
        #>
        process {
            # h1 '_formatColorBytes'
            # $Text | _formatColorBytes

            $_color = @{
                BytesFg     = 'gray60'
                BytesZeroFg = 'gray30'
            }
            # transform to instances
            $_color.Keys.clone() | ForEach-Object {
                $key = $_
                $Value = $_color[ $key ]
                $_color[ $key ] = [rgbcolor]$Value
            }

            $text = $_color.Values


            h1 '_formatDictItem_ColorSingle'
            $Text | _FormatDictItem_ColorSingle

            h1 '_format_HslColorString -Compress'
            $Text | _format_HslColorString -AlignMode Compress

            h1 '_format_HslColorString -Perfect'
            $Text | _format_HslColorString -AlignMode Perfect
        }
    }
    $state.'Test_Font_Color_Semantics' = {
        param($Text)
        <#
        .synopsis
            dynamically generate rows and cols
        .EXAMPLE
            .
        #>
        $C = @{
            fgBright2 = 'gray0'
            fgBright  = 'gray80'
            fg        = 'gray70'
            FgDim     = 'Gray50'
            FgDim2    = 'Gray30'
            FgDim3    = 'Gray1'
        }
        $Style = @{
            'Clear'   = @{
                fg = 'clear'
                bg = 'clear'
            }
            'Glow'    = @{
                fg = 'gray70'
            }
            'DimGlow' = @{
                fg = 'gray30'
                bg = 'gray15'
            }
        }
        $styleDimGlow = $Style.DimGlow
        $styleGlow = $style.Glow


        h1 'Dim glow'

        Get-Date | Write-Color -fg $Style.DimGlow.fg -bg $Style.DimGlow.bg
        h1 'glow + FgDim3'
        Get-Date | Write-Color -fg $Style.DimGlow.fg -bg $Style.DimGlow.bg
        Get-Date | Write-Color -fg $Style.Glow.fg -bg $c.FgDim
        Get-Date | Write-Color -fg $Style.DimGlow.fg -bg $Style.DimGlow.bg
        Get-Date | Write-Color -fg $Style.Glow.fg -bg $c.FgDim2
        Get-Date | Write-Color -fg $Style.Glow.fg -bg $c.FgDim3
        Get-Date | Write-Color -fg $Style.DimGlow.fg -bg $Style.DimGlow.bg
        Get-Date | Write-Color -fg $Style.DimGlow.fg -bg $Style.DimGlow.bg
        Get-Date | Write-Color -fg $Style.Glow.fg -bg $c.FgDim2

        h1 'glow + FgDim2'
        Get-Date | Write-Color -fg $Style.DimGlow.fg -bg $Style.DimGlow.bg
        Get-Date | Write-Color -fg $Style.Glow.fg -bg $c.FgDim2

        h1 'clear'
        'none'
    }
    $state.'FormatTo.GridsOfRandom' = {
        param($Text)
        <#
        .synopsis
            dynamically generate rows and cols
        .EXAMPLE
            .
        #>

        RepeatIt 3 {
            RepeatIt 3 {
                'a'..'e'
                | str ul
            } | str Csv
        }

        RepeatIt 3 {
            RepeatIt 3 {
                'a'..'e'
                | str csv
            } | str ul
        }

        h1 'dotnet "unicode", utf-16-le'
        [Text.Encoding]::GetEncoding( 'utf-16le' ).GetBytes( 'hi world' )
        | ForEach-Object {
            $_.ToString('D3').PadLeft(3)
        } | str str ' '



    }

    # PowerQuery.EscapeForDocs = {
    # $state.PowerQuery.EscapeForDocs = {
    $state.'FormatTo.PqDocString' = {
        param($Text)
        <#
        .synopsis
            macro to convert PowerQuery sourcecode, escaped for use in documentation
        .EXAMPLE
            $PowerQueryString | fDump -ScriptName FormatTo.PqDocString
        #>

        $Text -join "`n" -replace '"', '""'

    }
    $state.SortUnique = {
        param($Text)
        $Text ??= Get-Clipboard

        $Text
        | Sort-Object -Unique
        | str nl -sort -Unique
    }

} catch {
    Write-Warning "funcDumpErrorOnLoad: $_"
}
function Invoke-MiniFormatDump {
    <#
    .synopsis
        1-liners or random one-offs not worth making a class
    .description
        will be replaced by template library
       .
    .example
          .
    .outputs
          [string | None]

    #>
    [Alias(
        'FormatDump', 'fDump' #, 'FmDump'
    )]
    [CmdletBinding(
        DefaultParameterSetName = 'InvokeTemplate')]
    param(
        # todo: auto-generate completions using hashtable.
        [Alias('Name')]
        [Parameter(
            Mandatory, Position = 0,
            ParameterSetName = 'InvokeTemplate'
        )]
        [ArgumentCompletions(
            'Help_PSTypeNames', 'SortUnique', 'FormatTo.PqDocString', 'Test_Font_Color_Semantics'
        )]
        [string]$ScriptName,

        # force quote when variable
        [parameter()]
        [switch]$ForceSingleQuote,

        # force quote when variable
        [parameter()]
        [switch]$ForceDoubleQuote,

        # force quote when variable
        [parameter()]
        [switch]$ForceNoQuote,

        # list commands
        [parameter(ParameterSetName = 'ListOnly')]
        [switch]$List, # warning: stopped working

        # list commands
        [parameter()]
        [alias('cl')]
        [switch]$SetClipboard,



        # any  other params?
        [Parameter(Position = 1, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [object[]]$ArgList
    )

    begin {
    }
    process {

        $state = $script:__miniFormatDump
        $quoteModeSplat = @{}

        # make help func
        if ($PSBoundParameters.ContainsKey('ForceNoQuote')) {
            $quoteModeSplat['ForceNoQuote'] = $ForceNoQuote
        }
        if ($PSBoundParameters.ContainsKey('ForceSingleQuote')) {
            $quoteModeSplat['ForceSingleQuote'] = $ForceSingleQuote
        }
        if ($PSBoundParameters.ContainsKey('ForceNoQuote')) {
            $quoteModeSplat['ForceNoQuote'] = $ForceNoQuote
        }
        $quoteModeSplat | Out-String | Write-Debug
        if ( $quoteModeSplat.keys.count -gt 0 ) {
            Write-Error -Category NotImplemented -Message '$quoteModeSplat'
        }

        if ($List -or (! $ScriptName)) {
            $state.keys
            return
        }

        if (! $State.ContainsKey($ScriptName)) {
            Write-Error -ea stop "No matching keys: '$_'"
            return
        }
        if ($GetScriptBlock) {
            $state[$ScriptName]
            return
        }

        try {
            # if ($ArgList) {
            #     throw 'double check args pass correctly'
            # }
            # try  allowing arglist?
            # & $state[$ScriptName] @ArgList
            & $state[$ScriptName] $ArgList
            return
        } catch {
            Write-Error "SBFailed: $_"
            return
        }


    }
    end {
    }
}


if (! $experimentToExport) {
    # ...
}
