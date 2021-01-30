using namespace System.Text.RegularExpressions

@'
See also:

- [RegexStringValidator attribute](https://docs.microsoft.com/en-us/dotnet/api/system.configuration.regexstringvalidator?view=net-5.0)
- [System.Text.RegularExpressions Namespace](https://docs.microsoft.com/en-us/dotnet/api/system.text.regularexpressions?redirectedfrom=MSDN&view=net-5.0)
'@ | Show-Markdown | Write-Debug
# ConvertFrom-Markdown

$Sample = @{}
$Sample.Template = @'
{datetime}] hi {user} !
'@

$Sample.NestedTest = @'

should fail on inner nested
{name{species}}

or non-word
{nonWord-}

num
{validWord3}
'@

function Format-TemplateString {
    [Alias('Template, Format-Template')]
    param()

    Write-Warning "Format-TemplateString: WIP"
    H1 'Should there be?
        "New-TemplateString"
    '
}


function _findRequiredKeys {
    <#
    .example
        PS> '{datetime}] hi {user} !' | _findRequiredKeys
        # list: 'datetime', 'user'
    #>
    param(
        # template string to test
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$TemplateString,

        # Case sensitive keys?
        [Parameter()][switch]$CaseSensitive # or pass enum?
    )

    $debugMeta = @{
        PSBoundParameters = $PSBoundParameters | Format-HashTable SingleLine
    }

    $Regex = @{
        KeyName = '\{(?<KeyName>\w+)\}'
    }

    $reOptions = [RegexOptions]::new()
    $reOptions = $reOptions -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase

    $MatchesResults = [regex]::Matches($TemplateString, $Regex.KeyName, $regexOptions)
    $Results = $MatchesResults.Groups | ForEach-Object { $_['KeyName'] }
    $RequiredKeys = $MatchesResults | ForEach-Object { $_.Groups['KeyName'] | ForEach-Object Value }
    | Sort-Object -Unique

    $debugMeta['Matches'] = $MatchesResults
    $debugMeta['Results'] = $Results
    $debugMeta['RequiredKeys'] = $RequiredKeys | Join-String -sep ', ' -SingleQuote
    $debugMeta | Format-HashTable | Write-Debug

    $RequiredKeys
    Write-Warning 'Format-TemplateString: WIP'
}

Write-Warning 'next: Format-TemplateString'
if ($false -and $DebugTestMode) {

    H1 'Template'
    $Sample.Template | _findRequiredKeys # -Debug -ov lastReq

    H1 'NestedTest'
    $Sample.NestedTest | _findRequiredKeys # -Debug -ov lastReq

    H1 'Start: Pester'

    # pester: unit test
    $expected = 'datetime', 'user' | Sort-Object
    '{datetime}] hi {user} !' | _findRequiredKeys | Should -Be $expected


    $expected = 'user', 'species' | Sort-Object
    '{user}, {species}, {user}' | _findRequiredKeys | Should -Be $expected

    $sampleInput = '
{name{species}}

or non-word
{nonWord-}

num
{validWord3}
'
    $expected = 'species', 'validWord3' | Sort-Object
    '{user}, {species}, {user}' | _findRequiredKeys | Should -Be $expected

    # pester: repeated keywords
}