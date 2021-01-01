
function Get-HelpFromType {
    <#
    .synopsis
        open Powershell docs from a type name
    .notes
        future: automatically wrap typename in a list to call
            'Get-Unique -OnType' or 'sort -unique' or 'hashset'1
    #>
    [Alias('TypeHelp')]
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
            } else {
                $typeName = $typeInstance.FullName
            }
            # $typeName = $InputObject
        } elseif ( $InputObject -is [type] ) {
            $typeName = $InputObject.FullName
        } else {
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