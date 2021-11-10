BeforeAll {
    Import-Module Dev.Nin -Force
    $color = @{
        SkyBlue      = '#85BDD8'
        FgDim        = 'gray60'
        PesterGreen  = '#3EBC77'
        PesterPurple = '#A35BAA'
    }
    $ColorString = $color
    $ColorInstance = @{
        FGDimYellow    = [PoshCode.Pansies.RgbColor]'#937E5E'
        TermThemeFG    = [PoshCode.Pansies.RgbColor]'#EBB667'
        TermThemeError = [PoshCode.Pansies.RgbColor]'#943B43'
        FG             = [RgbColor]'#494943'
        FGDim          = [rgbcolor]'#7C7C73'
        FGDim2         = [rgbcolor]'#A2A296'
    }
}

Describe 'Format-Dict: Visual Test' -Skip:$true -Tag 'VisualTest', 'ANSIEscape', 'UsingWriteHost' {
    <#
    todo:
        does a custom rule fix this? currently test outputs first,
            then Pester test label prints after.
    #>

    It 'MoreTests' -Skip {
        # 'C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin\test\public\visual_test\Format-Dict.visual_test.ps1'
        # | str prefix 'check here for tests' | Write-Host
        Set-ItResult -Because 'not written yet'
    }
    It '"<Name>"' -ForEach @(
        @{
            Name        = 'stuff'
            InputObject = @{}
            # Config = @{}
        }
        @{
            Name        = 'Profile'
            InputObject = $Profile
            # Config = @{}
        }
    ) {
        @(

            hr
            Write-Color -t $Name $color.SkyBlue
            | str Prefix (Write-Color -t 'Name: ' $color.FgDim)


            $InputObject | Format-Dict

            # $profile | Format-Dict
        ) | Write-Host
        $true | Should -Be $true

    }
    Describe 'Env: Provider' {
        It 'a' {
            @(
                $profile | Format-Dict
                , (Get-ChildItem env:) | format-dict
                @(, (Get-Item env:) ) | format-dict                    
                Get-Item env: | Format-dict
            ) | Write-Host
        }
    }

    It 'Default args' {
        $stdout = @(
            @{a = 3 }

        )
        $stdout | Write-Host
        # @{a = 3 } | Format-dict -Options @{'DisplayTypeName' = $false }
        # @{a = 3 } | Format-dict -Options @{'DisplayTypeName' = $true }
        # @{a = 3 } | Format-dict -Options @{'DisplayTypeName' = $true ;
        #     'PrefixLabel'                                    = 'true';
        # }
        $true | Should -Be $true
    }
    It 'Default Options: "<Name>"' -ForEach @(
        @{
            Name = 'stuff'
            Obj  = @{a = 1 ; b = @('a'..'f') }
        }
        @{
            Name = 'Profile'
            Obj  = $Profile
        }
        @{
            Name = 'Profile | Select'
            Obj  = $Profile | Select-Object *
        }
    ) {
        @(
            $Obj | Format-Dict -Options @{'PrefixLabel' = "DefaultOpts: '$Name'" }
        ) | Write-Host
        $true | Should -Be $true
    }
    It 'Solo $Profile' {
        @(
            $Profile | Format-Dict -Options @{'PrefixLabel' = '$Profile' }
        ) | Write-Host
        $true | Should -Be $true
    }
    Context 'Nested Tests' -Pending {
        It 'todo: nesting' {
            'Todo: Take the same sample inputs, crossproduct on different options'
            | Should -Be $false
        }
    }
    Context 'ColorTypes' {
        It 'RGBInstance' {
            $Color = @{
                FGDimYellow    = [PoshCode.Pansies.RgbColor]'#937E5E'
                TermThemeFG    = [PoshCode.Pansies.RgbColor]'#EBB667'
                TermThemeError = [PoshCode.Pansies.RgbColor]'#943B43'
            }

            $Color | Format-Dict
        }
        It 'Text: RGB Hex' {
            $Color = @{
                FGDimYellow    = '#937E5E'
                TermThemeFG    = '#EBB667'
                TermThemeError = '#943B43'
            }

            $Color | Format-Dict
        }
    }
    # It 'Custom Options: "<Name>" "<options.keys>"' -ForEach @(
    # It 'Custom Options: "<Name>" "<options.keys>"' -ForEach @(
    It '"<Name>"' -ForEach @(
        @{
            Name = 'stuff'
            Obj  = @{a = 1 ; b = @('a'..'f') }
        }
        @{
            Name = 'Color Children'
            Obj  = @{

                Numbers     = 0..9
                ColorSingle = ''
            }
        }
        
        @{
            Name = 'Color[] Children'
            Obj  = @{
                Numbers       = 0..9
                SingleColor   = [rgbcolor]'magenta'
                ColorGradient = Get-Gradient -StartColor '#FF1C14' -EndColor '#BC8F8F'
            }
        }
    ) {
        @(
            $Obj | Format-Dict -Options @{'PrefixLabel' = "DefaultOpts: '$Name'" }
        ) | Write-Host
        $true | Should -Be $true
    }


    It 'future' -Pending {
        $false | Should -Be $true

        if ($false) {
            $SampleHash = @{a = 3 }
            $sampleHash | Format-dict -Options @{
                'DisplayTypeName' = $false
                'PrefixLabel'     = '<Label>'
            } -infa Continue -Debug -ea break

            # 'need one that toggles alignment'

            $sampleHash | format-dict -Options @{'TruncateLongChildren' = $true }

            $sampleHash | format-dict -Options @{'ColorChildType' = $true }
            $sampleHash | format-dict -Options @{'TruncateLongChildren' = $true }

            $sampleHash | Format-dict -Options @{'DisplayTypeName' = $true ; 'PrefixLabel' = 'true'; } -ea break
            $sampleHash | Format-dict -Options @{'DisplayTypeName' = $false } -ea break
            $sampleHash | Format-dict -Options @{'DisplayTypeName' = $false } -infa Continue -Debug -ea break
        }
    }
}