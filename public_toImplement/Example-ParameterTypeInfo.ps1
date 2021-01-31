# [1] save
# display parameters in ParameterSetName 'SingleQuote'
$paramList = $cinfo.ParameterSets | Where-Object Name -EQ SingleQuote | ForEach-Object Parameters | Sort-Object -Unique Name
$distinctParamName = $paramList | ForEach-Object Name | Sort-Object -Unique
$distinctParamName -join ', '

$cinfo.ParameterSets | Where-Object Name -EQ 'singlequote' | ForEach-Object Parameters | Format-Table

hr 1;
Label 'ParameterSetName' 'SingleQuote'
Label 'ParameterName' 'OutputPrefix'

$cinfo.ParameterSets | Where-Object Name -EQ 'singlequote' | Select-Object -exp Parameters
| Where-Object Name -Match 'OutputPrefix' -ov filtered

Label '-OutputPrefix' 'ParameterType'
$filtered.ParameterType | Format-Table *

# same
@($filtered)[0].parametertype | Format-Table *

$info = [ordered]@{
    SetName = 'SingleQuote'
    Name    = 'OutputPrefix'
    Type    = 'x.parametertype'
}

$info | Format-Table
