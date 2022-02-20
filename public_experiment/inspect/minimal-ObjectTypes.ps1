using namespace Management.Automation

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'objTypes'
        'objTypes_basic'
    )
    $experimentToExport.alias += @(
        'Info->objTypes' # 'objTypes'
        'Info->objTypes_basic' # 'objTypes'
    )
}

function objTypes_basic {
    [CmdletBinding()]
    [Alias('Info->objTypesBasic_basic')]
    param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )
    process {
        $InputObject.GetType().Name
        $InputObject.PSTypeNames
        | ShortName
        | Join-String -sep ', '
        | Join-String -sep ', '
        | Join-String -op 'PSTypeNames: '
        | Format-IndentText

        if ($InputObject.count -gt 1) {
            $InputObject[0].GetType().Name
            | Join-String -op 'Child: '
            | Format-IndentText -Depth 2

            $InputObject[0].PSTypeNames
            | ShortName
            | Join-String -sep ', '
            | Join-String -op 'Child: PSTypeNames: '
            | Format-IndentText -Depth 2

        }
    }
}

function objTypes {
    <#
    .synopsis
        command "Dev.Nin\objTypes_basic" with colors
    .notes
        **NOT Performant** . Experimenting with dynamic expressions
    .link
        Dev.Nin\objTypes
    .link
        Dev.Nin\objTypes_basic
    #>
    [CmdletBinding()]
    [Alias('Info->objTypes')]
    param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # extra options
        [Parameter()][hashtable]$Options
    )
    begin {
        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        [hashtable]$Config = @{
            BaseDepth = 1
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})
        $Str = @{}

        $Str.ColorDim = @(
            '' | Write-color -fg (Color->Gray 30)
        ) -join ''

        $Str.PrefixPSTypenames = @(
            'PSTypeNames: ' | Write-Color -fg (Color->Gray 50)
            $PSStyle.Reset
            # $Str.ColorDim
            '' | Write-color -fg (Color->Gray 30)
            # "${fg:clear}"
            # $PSStyle.Foreground
        ) -join ''
        $Str.PrefixFirst = @(
            'First: ' | Write-Color -fg (Color->Gray 50)
            $PSStyle.Reset
            # "${fg:clear}"
            # $PSStyle.Foreground
        ) -join ''


    }
    process {
        $splatDent = @{
            # IndentString = '  '
            IndentString = '  '
        }
        $curDepth = $Config.BaseDepth

        $InputObject.GetType().Name
        $InputObject.PSTypeNames
        | ShortName
        | Join-String -sep ', '
        | Join-String -op $Str.PrefixPSTypeNames
        | Format-IndentText @splatDent -Depth (0 + $curDepth)

        if ($InputObject.count -gt 1) {
            $InputObject[0].GetType().Name
            | Join-String -op $Str.PrefixFirst
            | Format-IndentText @splatDent -Depth (1 + $curDepth)

            @(
                $InputObject[0].PSTypeNames
                | ShortName
                | Join-String -sep ', '
            ) | ForEach-Object toString
            | Join-String -op $Str.PrefixPSTypeNames
            | Format-IndentText @splatDent -Depth (1 + $curDepth)

        }
    }
}


if ( ! $experimentToExport ) {
    hr 2
    , (Get-ChildItem .) | objTypes_oneline

    hr 2
}
