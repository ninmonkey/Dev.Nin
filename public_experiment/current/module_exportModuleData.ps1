#Requires -Version 7
using namespace System.Collections.Generic
using namespace System.Text

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        # 'Export-RelativePath'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}


# [hashtable]$App = @{
#     Root = Get-Item $PSScriptRoot
# }
# [hashtable]$App = $App + @{
#     Export = Join-Path $App.Root '.output'
# }

# New-Item -Path $App.Export -ItemType Directory -ea Ignore

<#

#>
function __newModuleRelPath_or_Export-RelativePath {
    <#
    .synopsis
        wrapper makes set-content of temp exports easier
    .description
       .
    .example
          iwr google.com | Set-ExportContent 'google.html'
    .outputs
          [any]
    #>
    [alias('_export')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        #input stream
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject,

        # filename
        [Parameter(Mandatory, Position = 0)]
        [string]$Name,

        # append?
        [switch]$Append
    )
    begin {
        Write-Warning @'

    see also ref: ninLog

    probably should make
        new-relPathContext , or
        set-relPathContext then

        relPath '.output' # implicitly uses context
            or, if, inside a module, then use module name for contexts

'@
        Write-Error 'Sketch, NYI'
        $lines = [List[string]]::new()
        $strb = [StringBuilder[]]::new()
        $BasePath = $App.Export
        $outFile = Join-Path $BasePath $Name
    }
    process {
        $strb.Add( $InputObject )
        $lines.add( $InputObject )
    }
    end {
        $splatDest = @{
            Encoding = 'utf8'
            Path     = $outFile
        }
        if ($Append) {
            Write-Warning 'nyi'
            $InputObject | Add-Content @splatDest
            return
        } else {
            Write-Warning 'nyi'

        }
    }



}


# 'literal string'


if (! $experimentToExport) {
    # ...
}
