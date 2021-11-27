#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'New-VSCodeSnippet'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

#Requires -Version 7

$SampleSrc = @'
function convertFrom-ExampleNumber {
    <#
    .synopsis
        sample convertTo NameIt template
    #>
    param(
        # InputObject
        [Parameter(position = 0, ValueFromPipeline)]
        [object]$InputObject
    )
    process {

        $InputObject
    }
}
'@


function New-VSCodeSnippet {
    <#
    .synopsis
        helps with most wrapping; quick hack, not best practices
    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$Text
    )

    begin {
        $inputList = [list[string]]::new()
        $Config = @{
            ReplaceTabsWith = '  ' # or: '\\t'
        }
    }
    process {
        $inputList.Add( $Text )
    }
    end {
        # $strAccum = [System.Text.StringBuilder]::new()
        # $strAutotranslate = [System.Text.StringBuilder]::new()


        $asLines = ($inputList -join '') -split '\r?\n'
        #optional mappings. order matters.
        $asLines | ForEach-Object {
            $curLine = $_
            $strAccum = $curLine -replace '"', '\"'
            Write-Debug "accum -> '$strAccum'"
            $strAccum = $curLine -replace '$', '\\$'
            Write-Debug "accum -> '$strAccum'"
            $strAccum = $curLine -replace '^\t', $Config.ReplaceTabsWith
            Write-Debug "accum -> '$strAccum'"
            $strAccum = $strAccum | Join-String -DoubleQuote
            $strAccum


            # $strAutotranslate.Append( ($curLine | ConvertTo-Json ) ?? $null )
        }

        # h1 'accum'
        # $strAccum -join ''
        # hr
        # $strAccum -join "`n"

        # # | str nl 22
        # h1 'auto'
        # $strAutotranslate
        # | SplitStr -SplitStyle Newline | str nl 2
    }
}



if (! $experimentToExport) {
    # New-VSCodeSnippet ($SampleSrc -join "`n")
    ',' | New-VSCodeSnippet
    'if ($true -eq "yes") { ' | New-VSCodeSnippet
    if ($false) {
        # return
        $SampleSrc | New-VSCodeSnippet
        # New-VSCodeSnippet $SampleSrc
        | str nl 2
        hr
        # ...
    }
}