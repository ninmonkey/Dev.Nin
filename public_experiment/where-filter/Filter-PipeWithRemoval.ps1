#Requires -Version 7
using namespace System.Collections.Generic

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Filter-IsDirectory'
        'Filter-SkipPropertyType'
        'Filter-Newest'
        'Filter-UniqueType'
    )
    $experimentToExport.alias += @(
        'Filter->UniqueType' # 'Filter-UniqueType'
        '?IsDir'            # 'Filter-IsDirectory'
        'Filter->IsDir'     # 'Filter-IsDirectory'
        'Filter->SkipPropType' # 'Filter-SkipPropertyType'


        'Filter->Newest'  # 'Filter-Newest'
        '?Newest'    # 'Filter-Newest'
    )
}

function Filter-Newest {
    <#
        .synopsis
            include or exclude directories
        .notes
            default is to sort
            assumes LastModified property
            .
        .example
            PS> Filter-Newest -InputObject (ls -file)  -Since '2d'
        #>
    [outputtype( '[object]' )]
    [Alias(
        '?Newest', 'Filter->Newest'
    )]
    [cmdletbinding()]
    param(
        # what to pipe
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # Cutoff date the test
        #5 : unclear on the best name
        [Alias('RelativeTimeString', 'Last', 'Ago', 'Within')]
        [ArgumentCompletions('36h', '10m', '1m', '3d', '90d')]
        [string]$Since
    )
    begin {
        [List[object]]$items = [list[object]]::new()
        $dateCuttoff = (Get-Date) - (RelativeTs $Since)
        "Cutoff: $dateCuttoff" | Write-Debug
        # Wait-Debugger
        $dbg = [ordered]@{
            CutOff      = $dateCuttoff
            TypesAdded  = @()
            KeptList    = @()
            RemovedList = @()
        }
    }
    process {
        $dbg['TypesAdded'] += $InputObject.GetType().Nmae
        $items.add( $InputObject)
    }
    end {
        $items
        | ForEach-Object {
            @{
                Type           = $_.GetType().FullName | ShortName
                LastWriteTime  = $curObj.LastWriteTime
                IsKeptByCutoff = $curObj.LastWriteTime -gt $dateCuttoff
            } | format-dict | Write-Debug

            $dbg['KeptList'] += @(
                @{
                    Type           = $_.GetType().FullName | ShortName
                    LastWriteTime  = $curObj.LastWriteTime
                    IsKeptByCutoff = $curObj.LastWriteTime -gt $dateCuttoff
                }
            )


            if ($curObj.LastWriteTime -gt $dateCuttoff) {

                $curObj
            } else {
                return
            }
        }
        $global:glob_dbg = $dbg
    }
}

function Filter-UniqueType {
    [Alias('Filter->UniqueType')]
    param()
    <#
        .synopsis
            filter to distinct types, outputs objects
        .description
            sugar for
                ... | Get-Unique -OnType

            to:ninmonkey.console
            .
        .example
            PS> Verb-Noun -Options @{ Title='Other' }
            Get-Item . | jProp -PassThru | ForEach-Object { ($_.Value) } | ?NotBlank | Get-Unique -OnType | len
            Get-Item . | jProp -PassThru | ForEach-Object { ($_.Value) } | Filter->UniqueType | len
        #>
    end {
        $Input | Where-IsNotBlank | Get-Unique -OnType
    }
}

#gi . | jProp -PassThru | % TypeNameOfValue | sort -Unique

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

        export:ninmonkey.console
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
