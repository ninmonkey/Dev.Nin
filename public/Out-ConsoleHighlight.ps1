function Out-ConsoleHighlight {
    <#
    .synopsis
        highlight patterns without removing any text
    #>
    [Alias('Hi')]
    param(
        # input text
        [Parameter(ValueFromPipeline)]
        [string[]]$InputText,

        # Regex to highlight
        [Parameter(Mandatory, Position = 0)]
        [string]$Pattern
    )

    begin {
        $finalRegex = '$|', $Pattern -join ''
        $binRipgrep = Get-NativeCommand 'rg' -ea Stop
        $rgArgs = @($finalRegex)
    }

    process {
        # ($InputText -split '\r?\n' )
        foreach ($line in $InputText -split '\r?\n') {
            $InputText
            | & $binRipgrep @rgArgs        
        }
    }
    end {
        Write-Warning 'not working yet'
    }
}

if ($TestDebugMode) {
    H1 'rg'
    Get-ChildItem | rg 'm'
    H1 'new'
    Get-ChildItem | Hi 'm'
}