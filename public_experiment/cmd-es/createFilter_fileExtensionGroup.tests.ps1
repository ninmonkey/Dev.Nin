BeforeAll {
    Import-Module Dev.Nin -Force -wa silentlyContinue -DisableNameChecking
}

Describe '_new-ESearchFilter_byFiletype' {
    BeforeAll {
        $ErrorActionPreference = 'Stop'
    }

    # aka 'nes->NewFiletypeFilter'
    It 'rg --type-list: Powershell <Sample> ' -ForEach @(
        @{
            $Sample = '*.cdxml, *.ps1, *.ps1xml, *.psd1, *.psm1'
        }
        @{
            $Sample = '  *.cdxml, *.ps1, *.ps1xml, *.psd1, *.psm1'
        }

    ) {

        $Expected = '( ext:cdxml;ps1;ps1xml;psd1;psm1 )'

        $sample | Dev.Nin\_new-ESearchFilter_byFiletype #-infa continue
        | Should -Be $Expected

        # '*.cdxml, *.ps1, *.ps1xml, *.psd1, *.psm1'
        # | Dev.Nin\_new-ESearchFilter_byFiletype -infa Continue
        # $rawin = '*.cdxml, *.ps1, *.ps1xml, *.psd1, *.psm1'
        # $rawin -replace '\s+' -split '\*\.' -replace ',', '' | Sort-Object -Unique
    }
    Describe '_getRipgrepDefinedTypelist' {
        BeforeAll {
            $sampleList = @(
                @{
                    ExactLangName  = 'ps'
                    InitialText    = '*.cdxml, *.ps1, *.ps1xml, *.psd1, *.psm1'
                    # maybe? rename to ExpectedRender
                    Expected       = '( ext:cdxml;ps1;ps1xml;psd1;psm1 )'
                    ErrorAsPending = $false # because: regex wip
                }
                @{
                    ExactLangName  = 'ps'
                    InitialText    = '*.cdxml, *.ps1, *.ps1xml, *.psd1, *.psm1'
                    Expected       = '( ext:cdxml;ps1;ps1xml;psd1;psm1 )'
                    ErrorAsPending = $false
                }
                @{
                    ExactLangName  = 'pendingMe'
                    InitialText    = '*.cdxml, *.ps1, *.ps1xml, *.psd1, *.psm1'
                    Expected       = '( ext:cdxml;ps1;ps1xml;psd1;psm1 )'
                    ErrorAsPending = $true
                }
            )
        }
        It 'ExportTypes' -Tag 'File-Export', 'File-IO' {
            Set-ItReset -Skipped -because 'Actual file Export that did-not get $PSSCriptRoot or something'
            $RootDir = Get-Item -ea stop (Join-Path $PSSCriptROot '.output')
            $query = es->ImportRgFiletype

            $query | to->Json
            | Set-Content -Path (Join-Path $RootDir 'Exported-RgFiletypes.json')
            $query | to->Csv | Set-Content -Path (Join-Path $RootDir 'Exported-RgFiletypes.csv')
        }
        It 'Format => Expected <ExactLangName> : <InitialText> => <Expected> [ <ErrorAsPending>' -ForEach $sampleList {

            # $sampleList
            # | Dev.Nin\_new-ESearchFilter_byFiletype
            # |
            $InitialText
            | Dev.Nin\_new-ESearchFilter_byFiletype
            | Should -Be $Expected
        }
        It 'Find => ExpectedPattern: <ExactLangName> : <InitialText> => <Expected> [ <ErrorAsPending>' -ForEach $sampleList {

            $sampleList
            | Dev.Nin\_new-ESearchFilter_byFiletype

            Set-ItResult -Pending -Because 'nyi, next'
        }
        Context 'integration -> mine -> export' {
            # It 'IntegrateParse "Lang ps" -> newEsFilter for <Sample>: ' -Foreach $sampleList {
            It 'IntegrateParse "Lang ps" -> newEsFilter for <Sample>: ' {

                $ExactLangName = 'ps'
                $Expected = '( ext:cdxml;ps1;ps1xml;psd1;psm1 )'
                Dev.Nin\_getRipgrepDefinedTypelist
                | Where-Object Lang -EQ $ExactLangName
                | ForEach-Object Glob
                | Should -Be $Expected
                # | Dev.Nin\_new-ESearchFilter_byFiletype

            }
        }

    }
}
