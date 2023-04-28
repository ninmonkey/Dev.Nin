BeforeAll {
    # Import-Module Dev.Nin -Force -DisableNameChecking
}


Describe 'CountIt' -Tag 'ANSI', 'Write-Host', 'Format' {
    Context 'TestingOptions' {
        BeforeAll {
            $Sample1 = 0..3 + 'a'..'e' # global default
            # $__meta = @{
            #     TestId = 0
            # }
        }
        It 'iter: <Sample>, <PassThru>, <IgnoreBlank>, <Label>, <Options>' -Foreach @(
            @{
                Sample      = $null
                # Id          = $__meta['TestId']++

                PassThru    = $true #?? $false
                IgnoreBlank = $false #?? $false
                Label       = $null # 'length'
                Options     = @{
                    PrintOnEveryObject                  = $false
                    PrintNewElementType                 = $true
                    OutputMode                          = $PassThru ? 'OnlyInt' : 'WithInformation'
                    Experimental_AutoEnableEnableWIPref = $true
                }
            }
        ) {

            @(
                $example = $Sample ?? $Sample1
                $measureObjectCountSplat = @{
                    PassThru    = $PassThru ?? $false
                    Label       = $Label ?? $null
                    Options     = $Options ?? @{}
                    IgnoreBlank = $true
                }

                $Options
                | Format-HashTable -FormatMode SingleLine

                $example
                | Dev.Nin\Measure-ObjectCount @measureObjectCountSplat
                | Str Csv
                #  | Write-Host



                # $__meta['TestId'] | Label 'id'
                # $Id | Label 'dynamic'
            )
            | Join-String -op ( hr 2 -fg gray30 ) -os ( hr 2 -fg gray30 )
            # | Join-String -op "`n`n`n`nbegin" -os "`n`n`n`nend"
            | Write-Host
            Set-ItResult -Skipped -Because 'Formatting Test'
        }
        # #Import-Module Dev.Nin -Force
        # hr 2
        # $o = @{
        #     'PrintOnEveryObject'  = $false
        #     'PrintNewElementType' = $true
        # }
        # $items = 'a'..'e' | len -PassThru -Label 'tag' -Options $o
        # $items

    }
}
