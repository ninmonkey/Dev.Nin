#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Pipe-Newest'
    )
    $experimentToExport.alias += @(
        # 'Pipe->Newest'

    )
}

# todo: Make Pipe->Newest (which is a filter

function Pipe-Newest {

    'NYI. Verb Peek-> is essentially composable filters or maps'
}

if (! $experimentToExport) {
    # ...
}
