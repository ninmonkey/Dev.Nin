
function Dev-FormatAlignedColumns {
    <#
   .synopsis
       test of tabular-like data but not Format-Table
   .description
        why? It was useful somewhere
   .notes
       .
   #>
    param (
        [Parameter(
            Mandatory, ValueFromPipeline,
            HelpMessage = 'any object')]
        [object[]]$InputObject

    )
    foreach ($Obj in $InputObject) {

    }
    #    begin {}
    #    process {


    #    }
    #    end {}
}
