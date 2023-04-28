#Requires -Version 7
# wip dev,nin: todo:2022-02
if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Test-ObjectHasProperty'
        'Test-ObjectHasKeyOrProperty'
    )
    $experimentToExport.alias += @(
        'Test-HasProperty'
        'Test-HasKeyOrProperty'
        # get test-contains parameter name for psreadline
    )
}

## todo: post blog: [2022/02]

function Test-ObjectHasProperty {
    <#
        .synopsis
            Does object contain property names? ignores values
    #>
    [Alias('Test-HasProprty')]
    [OutputType('System.Boolean')]
    param(
        # target object
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        $InputObject,

        # name[s] to query
        [alias('Name')]
        [Parameter(Mandatory)]
        [string[]]$PropertyName
    )

    process {
        foreach ($name in $PropertyName) {
            $InputObject.PSObject.Properties.Name -contains $Name
        }
    }
}


function Test-ObjectHasKeyOrProperty {
    <#
            .synopsis
                if you want a dict value or object property
            #>
    [alias('Test-HasKeyOrProperty')]
    param(
        [parameter(Mandatory, Position = 0)]
        $InputObject,

        [Parameter(Mandatory, Position = 1)]
        $Name
    )

    throw "NYI WIP $PSCommand"

}


if (! $experimentToExport) {
    # ...
}
