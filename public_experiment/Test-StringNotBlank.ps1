function IsNotBlank {
    <#
    .outputs
        boolean
    #>
    param(
        [string]$Text
    )
    [string]::IsNullOrWhiteSpace( $InputText )
    return
}
