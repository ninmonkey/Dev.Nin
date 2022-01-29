#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Filter-IsDirectory'
    )
    $experimentToExport.alias += @(
        '?IsDir'            # 'Filter-IsDirectory'
        'Filter->IsDir'     # 'Filter-IsDirectory'
    )
}

function Filter-IsDirectory {
    <#
        .synopsis
            include or exclude directories
        .notes
            Filter->
                means removal
            Pipe->
                could mean sort
                could mean transform
            .
        .example
            PS> Verb-Noun -Options @{ Title='Other' }
        #>
    [outputtype( '[object]' )]
    [Alias(
        'Filter->IsDir',
        '?IsDir'
    )]
    [cmdletbinding()]
    param(
        # what to pipe
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # negate the test
        [alias('NotADirectory')]
        [switch]$NotTrue
    )

    begin {
    }
    process {

        [bool]$result = $InputObject | Test-IsDirectory
        if ($NotTrue) {
            $result = ! $result
        }
        if ($result) {
            $InputObject
            return
        } else {
            return
        }
    }
    end {
    }
}



if (! $experimentToExport) {
    # ...
}
