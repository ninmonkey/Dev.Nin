function Get-DevParameterInfo {
    <#
    .synopsis
        quick function to inspect Command Parameter Types
    .notes
        - see also: 'ClassExplorer\Get-Parameter'
    .example
        # one command
        PS> Get-DevParameterInfo 'Set-PSReadLineOption'
    .example
        # or many, as a table
        PS> Get-DevParameterInfo 'gi', 'ls' | Ft
    .link
        Format-DevParameterInfo
    .link
        ClassExplorer\Get-Parameter
    #>
    [alias('ParamInfo')]
    param (
        # Text CommandName
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [Alias('Name')]
        [String[]]$Command,

        # Colorize output?
        [Parameter()]
        [switch]$Colorize
    )
    begin {
        h1 "Get-DevParameterInfo: $CommandName" -fg orange -be 0 -af 0 | Write-Debug
    }
    process {
        $Command | ForEach-Object {
            $CommandName = $_

            if ($Colorize) {
                Format-DevParameterInfo -CommandName $CommandName -FormatMode 'GroupByType'
                return
            }

            $cur_command = Get-Command -Name $CommandName
            $Params = $cur_command.Parameters
            $ParamSets = $cur_command.ParameterSets
            $DefaultParams = $cur_command.DefaultParameterSet

            if ($Null -eq $Params) {
                # throw "NullParameters: using '$CommandName'"
                # switched to error so the caller can choose to continue
                Write-Error "NullParameters: using '$CommandName'"
                return
            }

            $all_params = $params.GetEnumerator() | ForEach-Object {
                $cur_param = $_
                $cur_Key = $_.Key
                $cur_Value = $_.Value

                # refactor using formattypes instead of '_Name'
                $hash_parameter = @{
                    Command           = $cur_command
                    CommandName       = $cur_command.Name
                    Parameter         = $cur_Key
                    ParameterType     = $cur_Value.ParameterType
                    ParameterTypeName = $cur_Value.ParameterType.Name
                } | Sort-Hashtable -SortBy Key

                [pscustomobject]$hash_parameter

            }

            # all_paramTypes
            $all_params | Sort-Object -Unique -Property ParameterType | ForEach-Object ParameterType | Sort-Object FullName
            | Format-Table | Out-String | Write-Debug


            $all_params | Sort-Object -Property Command, Parameter

            #| Sort-Hashtable -SortBy Key

            # [hashtable]$meta_everything = @{}
            # [pscustomobject]$meta_everything

        }
    }

}


