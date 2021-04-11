function Format-DevParameterInfo {
    <#
    .synopsis
        experimenting with output formatting from <Get-DevParameterInfo>
    .notes
        - currently calls other function, doesn't format piped results
        - refactor as format types?
        - see also: 'ClassExplorer\Get-Parameter'
    .example
        PS> Format-DevParameterInfo 'Invoke-RestMethod'
    .example
        PS> Format-DevParameterInfo 'Get-Content', 'Get-Clipboard', 'Set-Location', 'ls'
    .link
        Get-DevParameterInfo
    .link
        ClassExplorer\Get-Parameter
    #>
    param(
        # Text CommandName
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [Alias('Name')]
        [String[]]$Command,

        # format mode
        [Parameter()]
        [ValidateSet('GroupByType')]
        [string]$FormatMode = 'GroupByType'
    )
    begin {
    }

    process {
        $Command | ForEach-Object {
            $CommandName = $_

            h1 "FormatMode: '$FormatMode'" -af 0
            switch ($FormatMode) {
                'GroupByType' {
                    $cmd = $CommandName | New-Text -fg 'skyblue'
                    h1 "Command: '$cmd'" -be 0 -af 1
                    #| Write-Debug
                    $info = Get-DevParameterInfo -Command $CommandName

                    $groups = $info | Select-Object Parameter, ParameterType
                    | Group-Object ParameterType
                    $groups | ForEach-Object {

                        $Label_TypeName = $_.Name -as 'type' | ForEach-Object { Label ('[{0}]' -f $_.Name ) -fg 'skyblue' -sep '' }
                        $Label_JoinedParamNames = $_.Group.Parameter | Join-String -sep ', ' { "-$_" }
                        Label $Label_TypeName $Label_JoinedParamNames -Fg 'skyblue' -sep ' = '

                    }
                    break
                }
                default {
                    throw "invalid mode: '$FormatMode'"
                }
            }
        }
    }

    end {
    }
}

if ($false) {
    # _zzFormat-DevParameterInfo 'Get-Item' -Debug
    $_devninConfig ??= @{
        RunInlineTests = $false
    }
    Format-DevParameterInfo 'Set-PSReadLineOption' -Debug

    if ($_devninConfig.RunInlineTests) {
        h1 '[typename] = <used by parameters>'
        $info = zzGet-DevParameterInfo 'Set-PSReadLineOption'
        $info = zzGet-DevParameterInfo 'Get-ConsoleEncoding'
        $groups = $info | Select-Object Parameter, ParameterType | Group-Object ParameterType
        $groups | ForEach-Object {

            $str1 = $_.Name -as 'type' | ForEach-Object { Label ('[{0}]' -f $_.Name ) }
            $str2 = $_.Group.Parameter | Join-String -sep ', ' { "-$_" }
            Label $str1 $str2
            #1| Label $Label_typeName


        }
    }
    if ($_devninConfig.RunInlineTests) {
        h1 'test C'
        $info = zzGet-DevParameterInfo 'Set-PSReadLineOption'
        $groups = $info | Select-Object Parameter, ParameterType | Group-Object ParameterType
        $groups | Join-String -sep "`n" {
            @(
                $_.Name -as 'type' | ForEach-Object { Label ('[{0}]' -f $_.Name ) }
                $_.Group.Parameter
            )
        }
    }
}
