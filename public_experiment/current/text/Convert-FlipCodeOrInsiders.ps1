#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Convert-FlipCodeOrInsider'
    )
    $experimentToExport.alias += @(
        'flipCodeAndInsider'        # 'Convert-FlipCodeOrInsider'
        'Format->FlipCodeOrInsider' # 'Convert-FlipCodeOrInsider'
    )
}

function Convert-FlipCodeOrInsider {
    <#
    .synopsis
        shortcut, makese it easier to swap between paths
    #>
    [Alias(
        'flipCodeAndInsider',
        'Format->FlipCodeOrInsider'

    )]
    [cmdletbinding()]
    param(
        [Alias('PSPath', 'FullName')]
        [parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)][object]$Path
    )

    begin {
        $re = @{}
        $re['IsCode'] = ReLit 'Code'
        $re['IsInsiders'] = ReLit 'Code - Insiders'

        $replacementStr = @{
            ToCode     = 'Code'
            ToInsiders = 'Code - Insiders'
        }

    }
    process {
        # $dbg = [ordered]@{
        $dbg = @{}
        # regex_IsCode     = $re['IsCode']
        # regex_IsInsiders = $re['IsInsiders']
        # toCode           = $replacementStr['IsCode']
        # toInsider        = $replacementStr['IsCode']
        # ObjectType       = $Path.GetType().Name


        if ($false) {
            switch ($Path) {
                { $_ -is 'System.IO.FileSystemInfo' } {
                    $strPath = $Path.FullName.ToString()
                    break
                }
                { $_ -is 'String' } {
                    'str'
                    break
                }
                default {
                    $strPath = $Path
                }
            }
        }
        $render = $Path.ToSTring()
        $dbg['StrPath'] = $strPath
        $dbg['Render'] = $render

        if ( ($render -notmatch $re.IsInsiders) -and ($render -notmatch $re['IsCode']) ) {
            $dbg['NeitherMatched'] = $true
            Write-Warning 'No Regex Matched'

            $dbg | Out-Default | Write-Debug
            return $Path
        }
        if ($render -match $re['IsInsiders']) {
            $dbg.IsInsiders = $true
            $render -replace $re['IsInsiders'], $replacementStr.ToCode
        } else {
            $dbg.IsCode = $true
            $render -replace $re['IsCode'], $replacementStr.ToInsiders
        }

        $dbg | Out-Default | Write-Debug
    }
}


if (! $experimentToExport) {
    if ($false) {
        flipCodeAndInsider 'C:\Users\cppmo_000\AppData\Roaming\Code - Insiders\User\snippets\yaml.json' -Debug
        <#
        t-FlipCodeOrInsiders.ps1:41:9
Line |
  41 |          $dbg = [ordered]@{
     |          ~~~~~~~~~~~~~~~~~~
     | Cannot index into a null array
     #>
    }
    ## relit '\Code - Insiders\' -AsRipgrepPattern
    # ...
}
