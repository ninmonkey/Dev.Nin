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
        [Parameter(Mandatory = $True, ValueFromPipeline)]
        [ParameterType]
        $ParameterName
    )

    begin {
        throw 'nyi'
    }

    process {

    }

    end {

    }
}
