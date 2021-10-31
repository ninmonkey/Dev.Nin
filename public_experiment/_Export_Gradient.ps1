$experimentToExport.function += @(
    # '_format-AnsiForFzf'
    # 'Write-AnsiBlock'
    # 'New-VtEscapeClearSequence'
    '_Import-RgbColor'
    '_Export-RgbColor'
)
$experimentToExport.alias += @(
    # '_write-AnsiBlock'
    # 'All' # breaks pester
    # 'Any'
)

$__ExportColorMeta = @{
    ExportPath     = 'C:/Users/cppmo_000/.ninmonkey/dev/PowerShell/exports/color'
    ExportFileName = 'saved_colors.json'
}
if (!(Test-Path $__ExportColorMeta.ExportPath)) {
    mkdir -Path $__ExportColorMeta.ExportPath
    $__ExportColorMeta.ExportPath = Get-Item $__ExportColorMeta.ExportPath
}

function _Export-RgbColor {
    param(
        [Alias('Color')]
        [parameter(Mandatory, Position = 1, ValueFromPipeline)]
        [rgbcolor[]]$InputObject,

        # misc label
        [parameter(Mandatory, position = 0)]
        [string]$Label
    )
    process {
        # $x = Get-Gradient 'blue' -EndColor 'tan'


        $converted = @(
            @{
                'Label'  = $Label
                'Colors' = [object[]]($InputObject | ForEach-Object Rgb )
            }
        ) | ConvertTo-Json

        $converted | Write-Debug

        $joinpathSplat = @{
            Path      = $__ExportColorMeta.ExportPath
            ChildPath = $__ExportColorMeta.ExportFileName
        }

        $fullName = Join-Path $__ExportColorMeta.ExportPath $__ExportColorMeta.ExportFileName
        $fullname | str prefix 'wrote: ' | Write-Debug

        $converted | Set-Content -Path $fullName

        #| Set-Content 'saved_gradients.json.old'

    }
}

function _Import-RgbColor {
    [cmdletbinding()]
    param(
        # [Alias('Color')]
        # [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        # [rgbcolor[]]$InputObject
    )
    process {
        # $x = Get-Gradient 'blue' -EndColor 'tan'

        # $converted = @(
        #     @{
        #         'Label'  = 'NiceBlue'
        #         'Colors' = [object[]]$x
        #     }
        # ) | ConvertTo-Json
        $joinpathSplat = @{
            Path      = $__ExportColorMeta.ExportPath
            ChildPath = $__ExportColorMeta.ExportFileName
        }

        $fullName = Join-Path $__ExportColorMeta.ExportPath $__ExportColorMeta.ExportFileName
        $fullName
        | str prefix 'Importing.... '
        | Write-Debug

        $imported = Get-Content $fullName


        # $imported | Write-Debug
        $Imported | ConvertFrom-Json

        #| Set-Content 'saved_gradients.json.old'

    }
}


# $fullname | str prefix 'wrote: ' | Write-Debug

# $converted | Set-Content -Path $fullName
# $x = Get-Gradient 'blue' -EndColor 'tan'
# @{ 'Label' = 'NiceBlue'  ; 'Gradient' = $x  }
# | ConvertTo-Json
# #| Set-Content 'saved_gradients.json.old'

# gc .\saved_gradients.json | ConvertFrom-Json | at 0 | % gradient
# | %{ [rgbcolor]::ConvertFrom(  $_ ) }
