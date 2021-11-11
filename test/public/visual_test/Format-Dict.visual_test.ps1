Import-Module dev.nin -Force -wa ignore | Out-Null
hr

'see also: ./test/public/visual_test/Find-Property.visual_test.ps1'
$SampleText = @{
    LoremIpsum = Get-Content (Join-Path $PSScriptRoot 'lorem_ipsum.txt')
}

$RunConfig = @{
    FrontChunk       = $true
    CatChunk         = $true
    NeedsImprovement = $True
    BestExamples     = $True
    Colors           = $true

}

if ($RunConfig.FrontChunk) {
    $Color = @{
        FGDimYellow    = [PoshCode.Pansies.RgbColor]'#937E5E'
        TermThemeFG    = [PoshCode.Pansies.RgbColor]'#EBB667'
        TermThemeError = [PoshCode.Pansies.RgbColor]'#943B43'
        FG             = [RgbColor]'#494943'
        FGDim          = [rgbcolor]'#7C7C73'
        FGDim2         = [rgbcolor]'#A2A296'
    }

    $Color | Format-Dict
}

$ErrorActionPreference = 'continue'
if ($RunConfig.FrontChunk) {
    Get-ChildItem env: | at 0 | Format-Dict

    $h = @{ species = 'cat' ; lives = 9 }
    $h | Format-Dict

    $o = [pscustomobject]$h
    $o | Format-Dict


    'todo: other $options like
    - [ ] darken \x2400-\x2500 to gray30
        - [ ] after, then preserve newline symbols, after -join
    - [ ] align columns
    - [ ] force truncation, force single line merge
    - [ ] enumerate recursive for values?
    ' | Write-Warning
    $ErrorActionPreference = 'Stop'

    hr 2
    'Part1: '

    @(
     (Get-Item .)
        @{'a' = 3; z = 4 }
        'hi world'
        [pscustomobject] @{'a' = 3; z = 4 }
    ) | Format-Dict -infa continue

    hr 6
}
if ($RunConfig.CatChunk) {


    'Part2: '

    Get-ChildItem env: | f 3 | Format-Dict

    $h = @{ species = 'cat' ; lives = 9 }
    $h | Format-Dict

    $o = [pscustomobject]$h
    $o | Format-Dict

    # Get-ChildItem env: | f 3
    hr 10
}

if ($RunConfig.NeedsImprovement) {
    @(
        Get-Process | f 2
        Get-Item .

        $cat = @{
            species = 'cat' ; lives = 9
            LotsOfText = $SampleText.LoremIpsum
        }
        $cat

        $otherCat = Join-Hashtable $cat @{
            'Kittens' = @(
                @{'Name' = 'Bob' },
                @{'Name' = 'Sue' }
            )
        }

        $otherCat | Format-Dict

        hr

        $human = @{
            Name = 'Mittens'
            Pet  = $otherCat
            Book = $SampleText.LoremIpsum
        }

        $humanObj = [pscustomobject]$human
        $humanObj

        Get-Date
    ) | Format-Dict #-ea break
    hr 3



    '$Human Dict' | Write-Color 'magenta'
    $human | Format-dict
    hr
    '$Human Obj' | Write-Color 'magenta'
    $humanObj | Format-Dict

    'Array Properties' | Write-Color 'magenta'
    @'
,@() | Format-Dict
'@ | Write-Color gray70 | str prefix '> '
    , @() | Format-Dict

    hr
}

if ($RunConfig.BestExamples) {
    'Array Properties' | Write-Color 'magenta'
    @'
> ,@() | Format-Dict
> , @(0, '3', (Get-Item . )) | Format-Dict

'@ | Write-Color gray70

    , @() | Format-Dict
    , @(0, '3', (Get-Item . )) | Format-Dict

    hr

}

$RunConfig | Format-dict