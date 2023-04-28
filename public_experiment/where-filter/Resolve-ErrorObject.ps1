# allows script to be ran alone, or, as module import
if (! $DebugInlineToggle ) {
    $experimentToExport.function += @(
        'Resolve-ErrorObject'
    )
    $experimentToExport.alias += @(
        'Resolve->Error'
    )
}

function Resolve-ErrorObject {
    <#
     .synopsis
        suger to get $error, if empty try $global:error , useful when debugging
    .description
        attemps local and global error instances, fails if they are both empty.
     #>
    [Alias('Resolve->Error')]
    param()

    $target = $error
    # empty or not in local scope
    if ($null -eq $error ) {
        #-or $error.count -eq 0) {
        Write-Debug '$Error is null, attempting global scope (ex: debug term)'
        if ( !( $null -eq $global:Error) ) {
            Write-Debug '$global:Error has values, returning that'
            $target = $global:Error
            return $target
        }
        Write-Error 'NoErrorFoundExceptionInAnything: could not find in local or global -- todo: ask on correct errors to throw.' -ErrorId '?'
    }


    Write-Warning 'not yet finsihed/stable'

    $Target | ForEach-Object {
        # $($_)?.ToString()
        # $($_).Exception
    } | str csv ' ' | Write-Information
    "ErrorsFound: $($Target.Count)" | Write-Information

    return $target
}
