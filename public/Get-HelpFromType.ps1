function _get_moduleFromType {
    param(
        # TypeName
        [Parameter(Mandatory, Position = 0)]
        [string]$TypeName
    )

    # $tinfo = $TypeName -as 'type'
    # $cmd = Get-Module -Name $tinfo.Namespace
    # $cmd | Select-Object -ExpandProperty ProjectUri

    $splat = @{ ModuleName = 'Pansies'; ModuleVersion = '1.0.0.0' }
    $modSpec = [Microsoft.PowerShell.Commands.ModuleSpecification]::new( $splat )
    Get-Module -FullyQualifiedName $modSpec | ForEach-Object ProjectUri
}

function _test-ValidHelpUrl {
    [OutputType([boolean])]
    param(
        [string]$Uri
    )
    <#
    .synopsis
        test whether help might not be official, better to just parse Get-Command metadata
    .example
        _test-ValidHelpUrl 'https://docs.microsoft.com/en-us/dotnet/api/System.Text' | Should -Be $True
        _test-ValidHelpUrl 'https://docs.microsoft.com/en-us/dotnet/api/PoshCode.Pansies.Text' | Should -Be $False
    #>
    # $uri = 'https://docs.microsoft.com/en-us/dotnet/api/PoshCode.Pansies.Text'
    try {
        Invoke-WebRequest $uri -ov response | Out-Null

    }
    catch {
        if ( $_.Exception.Response.StatusCode -eq [System.Net.HttpStatusCode]::NotFound ) {
            return $false
        }
    }
    $true
}

function Get-HelpFromType {
    <#
    .synopsis
        open Powershell docs from a type name
    .example
            .example
        PS> (Get-Command ls) | HelpFromType
        # Loads docs on [AliasInfo]
        # <https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.AliasInfo?view=powershellsdk-7.0.0>
    .notes
    future:
        - [ ] get 3rd party module's help urls from type name
        - [ ]  automatically wrap typename in a list to call
            'Get-Unique -OnType' or 'sort -unique' or 'hashset'1
    #>
    [Alias('TypeHelp', 'HelpFromType')]
    param(
        # object or type instance
        # should auto coerce to FullName
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # Return urls instead of opening browser pages
        [Parameter()][switch]$PassThru
    )

    process {

        if ($InputObject -is [string]) {
            $typeInstance = $InputObject -as [type]
            if ($null -eq $typeInstance) {
                Write-Debug "String, was not a type name: '$InputObject'"
                $typeName = 'System.String'
            }
            else {
                $typeName = $typeInstance.FullName
            }
            # $typeName = $InputObject
        }
        elseif ( $InputObject -is [type] ) {
            $typeName = $InputObject.FullName
        }
        else {
            $typeName = $InputObject.GetType().FullName
        }
        $url = 'https://docs.microsoft.com/en-us/dotnet/api/{0}' -f $typeName

        if ($PassThru) {
            $url
            return
        }
        Start-Process $url
    }
}

if ($false) {
    3, '21' | Get-HelpFromType -PassThru
    2, '354', 0.4, (Get-ChildItem . ), (Get-Date) | Get-HelpFromType -PassThru
}
