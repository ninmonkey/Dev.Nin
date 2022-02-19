#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(

    )
    $experimentToExport.alias += @(

    )
}

if ($script:___throttleTaskList) {

    $SBTask = {
        Write-Warning 'rebuilding gh.ps1...'
    }

    $newTask = [ThrottledTaskInfo]::new(
        'Build: RipGrep Autocomplete',
        'Build Github CLI autocompletions for latest version',
        '1d',
        $SBTask)
    $script:___throttleTaskList.add( $NewTask )
}

if (! $experimentToExport) {
    # ...
}
