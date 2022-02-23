#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Filter-ByTypeName'
    )
    $experimentToExport.alias += @(
        'Filter->ByType' # 'Filter-ByTypeName'
        'Test-TypeName' # 'Filter-ByTypeName'
    )
}

function Filter-ByTypeName {
    <#
    .synopsis
        include, or exclude, based on type names
    .notes
    .
    .example
        PS> Verb-Noun -Options @{ Title='Other' }
    #>
    # [outputtype( [string[]] )]
    # [Alias('x')]
    [cmdletbinding()]
    param(

        # docs
        # [Alias('y')]
        [parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject,

        # required types
        [Parameter(Position = 0)]
        [ArgumentCompletions(
            'String', 'Array', 'Int', 'Hashtable'
        )]
        [string[]]$IsType,

        # excluded types
        [Parameter(Position = 1)]
        [ArgumentCompletions(
            'String', 'Array', 'Int', 'Hashtable'
        )]
        [string[]]$IsNotType,

        # extra options
        [Parameter()][hashtable]$Options
    )
    begin {
        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        [hashtable]$Config = @{
            # AlignKeyValuePairs = $true
            # Title              = 'Default'
            # DisplayTypeName    = $true
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})
    }
    process {

        [hashtable]$dbg = @{}

        $dbg += @{
            InputType = $InputObject.GetType().FullName
            IsType    = $IsType | Join-String -sep ', ' -SingleQuote
            NotType   = $IsNotType | Join-String -sep ', ' -SingleQuote
        }

        $dbg | Format-HashTable -AsString | Write-Debug

        $okayState_Includes = $IsType | ForEach-Object {
            $t_name = $_ -as 'type'
            if ($null -eq $t_name) {
                return
            }
            $InputObject -is $t_name
        } | Test-AnyTrue

        $dbg += @{
            okayState_Include = $okayState_Includes
            okayState_Exclude = $okayState_Excludes
        }

        $okayState_Excludes = $IsNotType | ForEach-Object {
            $t_name = $_ -as 'type'
            if ($null -eq $t_name) {
                return
            }
            $InputObject -is $t_name
        } | Test-AllFalse

        # at the end, if lists are empty, then set defaults
        if ($IsType.count -eq 0) {
            $okayState_Includes = $true
        }

        if ($IsNotType.count -eq 0) {
            $okayState_Excludes = $true
        }

        $dbg += @{
            okayState_Include2 = $okayState_Includes
            okayState_Exclude2 = $okayState_Excludes
        }

        $dbg | Format-HashTable -FormatMode Table -AsString | Write-Debug

        if ($okayState_Includes -and $okayState_Excludes) {
            return $InputObject
        }
        return
    }
    end {
    }
}



if (! $experimentToExport) {
    # ...
}
