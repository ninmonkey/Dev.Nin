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



    '$Human Dict' | write-color 'magenta'
    $human | Format-dict
    hr
    '$Human Obj' | write-color 'magenta'
    $humanObj | Format-Dict

    'Array Properties' | write-color 'magenta'
    @'
,@() | Format-Dict
'@ | write-color gray70 | str prefix '> '
    , @() | Format-Dict

    hr
}

if ($RunConfig.BestExamples) {
    'Array Properties' | write-color 'magenta'
    @'
> ,@() | Format-Dict
> , @(0, '3', (Get-Item . )) | Format-Dict

'@ | write-color gray70

    , @() | Format-Dict
    , @(0, '3', (Get-Item . )) | Format-Dict

    hr

}

$RunConfig | Format-dict