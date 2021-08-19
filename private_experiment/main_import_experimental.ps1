

# eaiser to manage and filter, especially a dynamic set, in one place
[hashtable]$script:__metaPrivateExperimental = @{
    Metadata = @{}
    # 'formatData' = @()
}

function Get-ModuleMetadata {
    <#
    .synopsis
        internal private metadata [todo] move to its own tiny module
    .description
        Desc
    .outputs
        type any
    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Keyname
        [Alias('Name')]
        [Parameter(Mandatory, Position = 0)]
        [string]$KeyName,

        [Parameter()]
        [switch]$List


    )
    if ($List) {
        $script:__metaPrivateExperimental.Metadata.keys
        return
    }

    if (! $script:__metaPrivateExperimental.Metadata.ContainsKey( $KeyName ) ) {
        # Throw [KeyNotFoundException]
        # Write-Error "Key: '$KeyName' does not exist!"
        Write-Error "Key: '$KeyName' does not exist!" # todo: exception throw

    }

    # any reason to use?: $script:__metaPrivateExperimental.Metadata.Item($KeyName)
    $script:__metaPrivateExperimental.Metadata[ $KeyName ]
}
function Set-ModuleMetada {
    <#
    .synopsis
        internal private metadata [todo] move to its own tiny module
    .description
        Desc
    .outputs
        type any
    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Keyname
        [Alias('Name')]
        [Parameter(Mandatory, Position = 0)]
        [string]$KeyName,

        # [allowemptystring()]
        # [Parameter()][string]$Namespace,

        # Value
        [Alias('Value')]
        [Parameter(Mandatory, Position = 1)]
        [object]$InputObject
    )

    $script:__metaPrivateExperimental.Metadata[ $KeyName ] = $InputObject
}

# & {

# Don't dot tests, don't call self.
Get-ChildItem -File -Path (Get-Item -ea stop $PSScriptRoot)
| Where-Object { $_.Name -ne 'main_import_experimental.ps1' }
| Where-Object {
    # are these safe? or will it alter where-object?
    # Write-Debug "removing test: '$($_.Name)'"
    $_.Name -notmatch '\.tests\.ps1$'
}
| ForEach-Object {
    # are these safe? or will it alter where-object?
    # Write-Debug "[dev.nin] importing experiment '$($_.Name)'"
    . $_
}
# }
#
