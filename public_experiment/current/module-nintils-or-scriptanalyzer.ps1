#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(

    )
    $experimentToExport.alias += @(
        # 'A'
    )
}


function _Test-IsList {
    <#
    .synopsis
        is it some sort of non-scalar?
    #>
    param(
        $Object
    )
    $conditions = @(
        $Object.Length -gt 1

    )
    if (Test-Any $conditions) {
        $True; return;
    }
    $false
}
function _Test-IsDict {
    <#
    .synopsis
        is it some sort of dict?
    .notes
        some funcs, like 'gci env:' will return the older type of dict
    #>
    param(
        $Object
    )
}



if (! $experimentToExport) {
    # ...
}
