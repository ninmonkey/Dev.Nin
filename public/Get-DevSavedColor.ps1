using namespace PoshCode.Pansies

$dev_colors = @{
    Yellow = [RgbColor]::FromRgb(235, 203, 139)
    Red    = [RgbColor]::FromRgb(196, 107, 108)
}
function Get-DevSavedColor {
    <#
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
                # $dev_colors.GetEnumerator() | Where-Object {
                #     $ColorName | ForEach-Object {
                #         $curColor = $_
                #         if ($_.Key -match $curColor) {
                #             return $true ; return
                #         }
                #     }
                # }
                break
            }

            default {
                throw "Unhandled Set: $($PSCmdlet.ParameterSetName)"
            }

        }
        if ($All) {
            $filteredColors = $dev_colors
        }

        $filteredColors
    }

}

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