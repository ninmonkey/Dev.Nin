function Get-SpecialFolder {
    <#
    .synopsis
        List (several)
    .description
        .This is more so documentation that a tool ?
    .example
        PS>
    .notes
        See:
            [Microsoft.VisualBasic.FileIO.SpecialDirectories](https://docs.microsoft.com/en-us/dotnet/api/Microsoft.VisualBasic.FileIO.SpecialDirectories?view=net-5.0)

        [Microsoft.VisualBasic.FileIO.SpecialDirectories]::Desktop

    #>
    param (

    )
    begin {}
    process {
        $result = @{}
        [Environment+SpecialFolderOption] | EnumInfo | SelectProp Name -PassThru | Join-String -Separator ', ' -op '[Environment+SpecialFolderOption] values = '
        | Write-Verbose

        <#
    enums:
        Environment+SpecialFolder
        Environment+SpecialFolderOption

    GetFolderPath(System.Environment+SpecialFolder folder)
    GetFolderPath(System.Environment+SpecialFolder folder, System.Environment+SpecialFolderOption option)

    #>

        $names = [Microsoft.VisualBasic.FileIO.SpecialDirectories] | Fm -MemberType Property | ForEach-Object Name
        $result['VBSpecialDirectories'] = $names

        $result['SpecialFolder'] = [Environment+SpecialFolder] | Get-EnumInfo | ForEach-Object {
            [pscustomobject]@{
                Name    = $_.Name
                Numeric = $_.Value
                Value   = [System.Environment]::GetFolderPath( $_.Name )
                #  [specialfold]
            }
        }

        [pscustomobject]$result


    }
    end {
        Write-Warning 'NYI: this will
        1]
            Microsoft.VisualBasic.FileIO.SpecialDirectories
        2]
            [Environment+SpecialFolder] '
    }
}

if ($false) {
    function Get-SpecialEnv {


        Write-Warning 'NYI: this will
        1]
            read all env vars using Env:
        2]
            read all env vars using the global scope'

    }


    if ($TempDebugTest) {
        Get-SpecialFolder
        Hr 4
        Import-Module Dev.Nin -Force
        $res = Get-SpecialFolder
        Hr
        $res
    }

    function Get-NinEnvInfo {
        Write-Warning 'NYI: this will make it quick to regex Env: provider names

        🐒> [System.Environment]::GetEnvironmentVariables


        OverloadDefinitions
        -------------------
        static System.Collections.IDictionary GetEnvironmentVariables(System.EnvironmentVariableTarget target)
        static System.Collections.IDictionary GetEnvironmentVariables()

    '
    }
    # [Environment+SpecialFolder] | Get-EnumInfo | ForEach-Object …
    # Find-Type -FullName *special*folder* -Force
    # | ForEach-Object FullName
    # Get-ParameterInfo -Parameter [Environment+SpecialFolder]

}
