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


    }
    end {
        Write-Warning 'NYI: this will
        1]
            Microsoft.VisualBasic.FileIO.SpecialDirectories
        2]
            [Environment+SpecialFolder] '
    }
}

function Get-SpecialEnv {



    [Environment+SpecialFolder] | Get-EnumInfo | ForEach-Object {
        [pscustomobject]@{
            Name    = $_.Name
            Numeric = $_.Value
            #  [specialfold]
        }
    }

    Write-Warning 'NYI: this will
        1]
            read all env vars using Env:
        2]
            read all env vars using the global scope'

}

function Get-NinEnvInfo {
    Write-Warning 'NYI: this will make it quick to regex Env: provider names'
}
# [Environment+SpecialFolder] | Get-EnumInfo | ForEach-Object …
Find-Type -FullName *special*folder* -Force
| ForEach-Object FullName
# Get-ParameterInfo -Parameter [Environment+SpecialFolder]
