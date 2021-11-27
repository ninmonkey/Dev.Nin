#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Pipe->Newest'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

# todo: Make Pipe->Newest (which is a filter

function Pipe->Newest {
    throw 'NYI. Verb Peek-> is essentially composable filters or maps'
}

if (! $experimentToExport) {
    # ...
}