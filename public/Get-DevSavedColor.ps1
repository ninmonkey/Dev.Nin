using namespace PoshCode.Pansies

$dev_colors = @{
    Yellow      = [RgbColor]::FromRgb(235, 203, 139)
    Yellow2     = [RgbColor]'#E0F543'
    Red         = [RgbColor]::FromRgb(196, 107, 108)
    Green       = [RgbColor]::FromRgb(15, 232, 49)
    Green2      = [RgbColor]'#6A9955'
    GreenBright = [RgbColor]::FromRgb(131, 246, 46)
    LightBlue   = [RgbColor]'#9CDCFE'
    Blue        = [RgbColor]'#418AFF'
    Blue2       = [RgbColor]'#569CD0'
    DimYellow   = [RgbColor]'#DCDCAA'
    Tan         = [RgbColor]'#DCDCAA'
    Purple      = [RgbColor]'#C586C0'
} | Sort-Hashtable -SortBy Value
#| ForEach-Object GetEnumerator | Sort-Object Key

function Get-DevSavedColor {
    <#X
    .SYNOPSIS
    colors

    .DESCRIPTION
    Long description

    .EXAMPLE
    PS>
        Get-SavedColor
        Get-SavedColor -name 'yellow'

    .NOTES
    future:
        - [ ] fromRGB
        - [ ] preview not needed, just create [Color.Format-Wide.Format.ps1xml]
            (inspect pansi/ClassExplorer) for types
    #>
    [cmdletbinding(DefaultParameterSetName = 'fromName')]
    param(
        # PassThru
        [Parameter()][switch]$PassThru,

        # List All
        [Parameter()][switch]$All,

        # color name
        [Parameter(
            ParameterSetName = 'fromName', Position = 0
        )]
        [Alias('Name')]
        [string[]]$ColorName
    )

    begin {
        [hashtable]$Regex = @{
            AllColors = $ColorName | Join-String -sep '|' {
                [regex]::escape($_)
            }
        }
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'fromName' {
                $filteredColors = $dev_colors.GetEnumerator() | Where-Object {
                    $_.Key -match $Regex.AllColors
                }
            }

            default {
                throw "Unhandled Set: $($PSCmdlet.ParameterSetName)"
            }

        }
        if ($All) {
            $filteredColors = $dev_colors
        }

        if ($PassThru) {
            $filteredColors
            return
        }


        $filteredColors | ForEach-Object {
            $curColor = $_
            $Name = $curColor.Key
            @(
                New-Text $Name -fg $curColor.Value | ForEach-Object tostring
                New-Text $Name -bg $curColor.Value | ForEach-Object tostring
            ) -join ' '
        }

    }

}


if ($false) {
    Get-DevSavedColor -All
    hr
    Get-DevSavedColor -Name 'yellfow', 'red'
    hr
    Get-DevSavedColor -All | ForEach-Object GetEnumerator | ForEach-Object {
        $Name = $_.Key
        New-Text $Name -fg $_.Value
    } #| Format-Table

    Get-DevSavedColor -All | ForEach-Object GetEnumerator | ForEach-Object {
        $Name = $_.Key
        @(
            New-Text $Name -fg $_.Value | ForEach-Object tostring
            New-Text $Name -bg $_.Value | ForEach-Object tostring
        ) -join ' '
    }

    Get-DevSavedColor -Name 'yellfow', 'red'
    # | Format-DevColor RenderTest

    hr 4
    $dev_colors.GetEnumerator() | ForEach-Object Value

    HR
    $dev_colors.Red | Format-DevColor -PassThru
    hr
    $dev_colors.Red | Format-DevColor RenderTest
}