#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Filter-IsDirectory'
        'Filter-SkipPropertyType'
    )
    $experimentToExport.alias += @(
        '?IsDir'            # 'Filter-IsDirectory'
        'Filter->IsDir'     # 'Filter-IsDirectory'
        'Filter->SkipPropType' # 'Filter-SkipPropertyType'
    )
}

function Filter-IsDirectory {
    <#
        .synopsis
            include or exclude directories
        .notes
            Filter->
                means removal
            Pipe->
                could mean sort
                could mean transform
            .
        .example
            PS> Verb-Noun -Options @{ Title='Other' }
        #>
    [outputtype( '[object]' )]
    [Alias(
        'Filter->IsDir',
        '?IsDir'
    )]
    [cmdletbinding()]
    param(
        # what to pipe
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # negate the test
        [alias('NotADirectory')]
        [switch]$NotTrue
    )

    begin {
    }
    process {

        [bool]$result = $InputObject | Test-IsDirectory
        if ($NotTrue) {
            $result = ! $result
        }
        if ($result) {
            $InputObject
            return
        } else {
            return
        }
    }
    end {
    }
}


function Filter-SkipPropertyType {
    <#
    .synopsis
        currently used after 'iter->Prop'
    .notes
        abstract to two commands

        [1] Filter-ObjectByProperty

        [2] SkipPropType            (smart alias)
            which filters using property name 'TypeNameOfValue'

    #5 -> Can auto-inspect names from type, potentially on first run only, to make it able to determine properties, which are at run time
    .link
        Dev.Nin\Iter->Prop
    .example
        PS> $stuff | Iter->Prop
            | skipPropType -TypeNameRegex Object^
    .example
        PS> # Compare filtering long names
        # skip properties by name length (from regex)
        gcm * | at 0
        | iter->prop | Filter->SkipPropType '.{30,}'
        | ft -AutoSize Name, TypeNameOfValue, Value

        # skip properties by name length (from regex)
        gcm * | at 0
        | iter->prop #| Filter->SkipPropType '.{30,}'
        | ft -AutoSize Name, TypeNameOfValue, Value
    .example
        gcm * | at 0
        | iter->prop
        | Filter->SkipPropType '.{60,}'
        | ft -AutoSize Name, TypeNameOfValue, Value

        gcm * | at 0
        | iter->prop
        #| Filter->SkipPropType '.{30,}'
        | ft -AutoSize Name, TypeNameOfValue, Value
    #>
    [outputtype( '[object]' )]
    [Alias(
        'Filter->SkipPropType'
    )]
    [cmdletbinding()]
    # param(
    #     # what to pipe
    #     [parameter(Mandatory, Position = 0, ValueFromPipeline)]
    #     [object]$InputObject,

    #     # negate the test
    #     [alias('NotADirectory')]
    #     [switch]$NotTrue
    # )

    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject,

        [alias('Regex')]
        [parameter(Position = 0)]
        [argumentcompletions(
            'string^', 'Object^',

            '.{30,}', # long names
            '.{80,}' # long names
        )]
        [string[]]$TypeNameRegex
    )
    process {
        # count requires collect pattern
        #$OrigPropCount = $InputObject | Len | Write-information
        #$filtered = $inputObject |?{ $_.TypeNameOfValue -notmatch (Join-Regex -Regex $TypeNameRegex ) }
        #$filtered.count
        $inputObject | Where-Object {
            $_.TypeNameOfValue -notmatch (Join-Regex -Regex $TypeNameRegex )
        }

    }
}


if (! $experimentToExport) {
    # ...
}
