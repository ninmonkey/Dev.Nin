enum ETermFilterDate {
    datemodified = 1
    dm = 1
    dateccreated = 2
    dc = 2
}

function New-EverythingQueryTerm {
    <#
    .synopsis
        [...]
    .description
        [...]
    .notes
        [...]
    .
    #>
    [CmdletBinding(

        DefaultParameterSetName = 'setNin', PositionalBinding = $false)]
    param (
        # Name
        [Parameter(Mandatory = $True, ValueFromPipeline, ParameterSetName = 'setNin')]
        [string]$ParameterName
    )

    begin {
        throw 'nyi'
    }

    process {

    }

    end {

    }
}
