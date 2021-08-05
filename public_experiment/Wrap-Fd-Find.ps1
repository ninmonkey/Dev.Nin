$experimentToExport.function += 'Invoke-FdFind'
$experimentToExport.alias += 'Dig', 'FdFind'

function Invoke-FdFind {
    <#
    .synopsis
        Stuff
    .description
        Desc
    .outputs

    #>
    [alias('Dig', 'FdFind')]
    [CmdletBinding(PositionalBinding = $false)]
    param(

    )

    begin {}
    process {

        # todo: always wrap CmdletExceptionWrapper: From Sci
    }
    end {}
}

<#

Other types
    fd --glob *.gif

Example error:

[fd error]: The search pattern 'C:\Users\cppmo_000\Documents\2021' contains a path-separation character ('\') and will not lead to any search results.

If you want to search for all files inside the 'C:\Users\cppmo_000\Documents\2021' directory, use a match-all pattern:

  fd . 'C:\Users\cppmo_000\Documents\2021'

Instead, if you want your pattern to match the full file path, use:

  fd --full-path 'C:\Users\cppmo_000\Documents\2021'
#>
