$experimentToExport.function += @(
    'Export-ConsoleColor'
)
$ExperimentToExport.alias += @('exportConfigColor', 'Export-FavConsoleColor')


function Export-FavConsoleColor {
    <#
    .synopsis
        export pansies (actually anywhere)
    .description
       .
    .example
          .
    .outputs
          [string | None]

    #>
    [Alias('Export-FavConsoleColor', 'exportConfigColor')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$Color,

        [alias('Path', 'PSPath')] # check whether color's PSPath would override dest
        [Parameter(Position = 1)]
        [string]$ExportPath = 'C:\nin_temp\colors\autoexport.csv'
    )

    begin {}
    Process {
        Test-Path $ExportPath -ea Stop | Out-Null

        $selectObjectSplat = @{
            Property = 'ConsoleColor', 'PSPath', 'PSDrive', 'PSProvider', 'RGB', '*term*', 'X11', 'R', 'G', 'B', @{name = 'AddedOn'; expression = { (Get-Date).ToShortDateString() } }
        }

        $text = $Color | Select-Object @selectObjectSplat
        | ConvertTo-Csv

        if (!(Test-Path $ExportPath)) {
            # skip headers if it exists
            $text | Select-Object -Skip 1
        }

        # | Select-Object -First 1 # strip headers
        $text | Add-Content -Path $ExportPath -Encoding utf8
        "Wrote: '$ExportPath'" | Write-Verbose

    }
    end {}
}
