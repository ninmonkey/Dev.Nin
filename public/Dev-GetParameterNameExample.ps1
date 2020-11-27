<#
regex:
    prefix is 'Foo'
    match first Capital then only lowercase

    DoNotX
    DontX
    AsX
    NoX
#>


function Write-Highight {
    <#
    .synopsis
        adds color to raw text, like a highlighter
    #>
    param (
        [Parameter(
            ParameterSetName = 'PipeText',
            Mandatory, ValueFromPipeline,
            HelpMessage = 'raw text'
        )]
        [string[]]$InputText
    )


    process {
        # $regex 'user' DFs cgree
    }

}

function Find-VerbPrefix {
    <#
    .synopsis
    #>
    param (
        [Parameter(
            Mandatory, Position = 0,
            HelpMessage = 'case sensitive prefix')]
        [string[]]$PrefixList
    )
    begin {
        $Regex = @{}
        $Regex.CaseSensitive = '(?-i)'
        # ex: '\bDo[A-Z]' or  '^Do[A-Z]'
        $Regex.TemplatePrefix = $regex.CaseSensitive, '^{0}[A-Z]' -join ''
    }
    process {
        foreach ($CurPrefix in $PrefixList) {
            $curRegex = $Regex.TemplatePrefix -f $CurPrefix

            ''
            Label 'Prefix' $CurPrefix -fg red
            Label 'Regex' $curRegex -fg lightblue | Write-Debug
            ''
            Find-Member -Name $curRegex -RegularExpression
            | Sort-Object -Unique Name
            | ForEach-Object {
                $replaceStr = '{0}$0' -f ( New-Text -fg Green '' -LeaveColor )
                $replaceStr += "`e[0m"

                $_.Name -replace $curRegex, $replaceStr
            }

        }
    }
    end {}
}
h1 'test'
# Find-VerbPrefix 'Dont', 'Do' -Debug
Find-VerbPrefix 'Dont' -Debug
break
h1 'old'
$regex = '(?-i)^(Do[A-Z][a-z]+|Dont|DoNo)'
# $regex = '(?-i)^(Dont|DoNo|Do[A-Z][a-z]+(.*?)'
Find-Member $regex -RegularExpression | Sort-Object -Unique name
| ForEach-Object {
    $replaceStr = '{0}$1' -f ( New-Text -fg Green '' -LeaveColor )
    $replaceStr += "`e[0m"

    $_.Name -replace $regex, $replaceStr
}
| Format-Wide -c 1

hr
break
$regex = '\bAs[A-Z]' # As something
$regex = '\bDo[A-Z]' # As something

$regex = $regex, '\bDont' -join '|'
# default
$regex = '\bDont'
$regex = '\bDo[A-Z]'
$regex = '(?-i)' + $regex


Label 'Label' 'Do to lto lower N' -fg yellow

Label 'Regex' $Regex
Find-Member -Name $regex -RegularExpression
| Sort-Object -Unique Name
| Format-Wide -AutoSize
| rg $regex