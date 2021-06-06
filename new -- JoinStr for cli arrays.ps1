function JoinStr {
    <#
    .synopsis
        temp dev command to simplify pretty print
    .example
        3..102 | JoinStr
    #>
    [alias('Csv')]
    param([Parameter(ValueFromPipeline, Mandatory)]
        [object[]]$InputObject)

    begin {
        $all_list = @()
        $colorSep1 = [RgbColor]'#5F6C85'
        $colorSep2 = [RgbColor]'#373E4C'  # '#7E90B1'
    }
    process {
        $all_list += $InputObject
    }
    end {
        $colorSep = New-Text ' ' -bg $colorSep2  | ForEach-Object tostring
        #    $all_list | Join-String -sep ' ' -FormatString '{0,-3}'
        #     $all_list | Join-String -sep $colorSep -FormatString '{0,-3}'

        #      $all_list | Join-String -sep $colorSep { '{0,-3}' -f $_ | New-Text -bg $colorSep1 }
        $all_list | Join-String -sep ' ' -FormatString '{0,-3}'
    }
}

