

# eaiser to manage and filter, especially a dynamic set, in one place
[hashtable]$script:__metaPrivateExperimental = @{
    Metadata = @{}
    # 'formatData' = @()
}

function _Get-ModuleMetada {
    <#
    .synopsis
        internal private metadata
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
        [string]$KeyName
    )

    if (! $script:__metaPrivateExperimental.Metadata.ContainsKey( $KeyName ) ) {
        # Throw [KeyNotFoundException]
        # Write-Error "Key: '$KeyName' does not exist!"
        Throw "Key: '$KeyName' does not exist!"
    }

    $script:__metaPrivateExperimental.Metadata.Item($KeyName)
}
function _Set-ModuleMetada {
    <#
    .synopsis
        internal private metadata
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
