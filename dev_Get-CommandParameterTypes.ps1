
& {
    $Regex = @{}
    $Regex.Help_ParamLineOnly = '^(?<first>\-.+)(?<rest>\b.*)$'

    h1 'parse function params and types'
    $cmdName = 'format-table'
    Get-Help $cmdName -Parameter * | ForEach-Object {
        $_ | Select-String $Regex.Help_ParamLineOnly  -List
    } | Tee-Object -var 'lastsel'

    $lastsel.foreach('ToString') | Sort-Object


    hr

    $param = Get-Help Out-String -Parameter * | rg '^\-' | Sort-Object
    h1 'all'
    $param
    h1 'split'
    $param.foreach( { $_.split(' ')[0] })
    Write-Host -fore Yellow 'warning: this is a quick regex, you should use inspection instead'

}