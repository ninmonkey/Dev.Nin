function Test-ItemType {
    <#
    .synopsis

    .description
        .
    .example
        PS>
    .notes
        .
        Enum: [FileAttributes]
            https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-childitem?view=powershell-7.1&WT.mc_id=ps-gethelp#example-1--get-child-items-from-a-file-system-directory

        fileystem provider:
            https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_filesystem_provider?view=powershell-7.1#attributes-flagsexpression
    #>
    [alias('WhatIs')]
    param (
        # Item
        [Parameter(Mandatory, position = 0, ValueFromPipeline)]
        [object]$InputObject
    )
    begin {}
    process {
        # $Target = gi -ea stop $InputObject # Yes? No?
        $meta = @{
            TypeName = ($InputObject)?.GetType() ?? '[null]'
            IsNull   = $null -eq $InputObject
        }

        $meta

        switch ($meta.TypeName) {
            default {

            }
        }

    }
    end {}
}


if ($false -and $TestDebugMode) {
    Test-ItemType (Get-Item 'c:\nin')

    $file = Get-ChildItem . | Select-Object -First 1
    @(
        $File.GetType()
        $File.GetType().GetType()
        $file
        # $null
        ''
        'foo'

    ) | Test-ItemType

}
