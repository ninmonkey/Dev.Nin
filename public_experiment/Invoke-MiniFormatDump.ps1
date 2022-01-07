#Requires -Version 7.0


$experimentToExport.function += @(
    'Invoke-MiniFormatDump'
)
$experimentToExport.alias += @(
    'FormatDump',
    'fDump'
)

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
            'Help_PSTypeNames', 'SortUnique', 'FormatTo.PqDocString'
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
