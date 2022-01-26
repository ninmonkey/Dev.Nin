#Requires -Version 7
using namespace System.Collections.Generic


if ( $experimentToExport ) {
    $experimentToExport.function += @(
        # confirmed
        'Out-MinimalPicker'
        'Pipe-Pick'
        'Pick-Member'
        #rest
    )
    $experimentToExport.alias += @(
        # confirmed
        'Pick', # Pipe-Pick
        'Out->Picker'       # Pipe-Pick
        'pm', 'pickProp', 'Pick->Member'    # Pick-Member
        #rest
    )
}



function Out-MinimalPicker {
    <#
    .synopsis
        redundant? Throw in a pipeline to quickly filter, also saves as $picker, if needed
    .description
    #>
    end {
        $global:picker ??= $Input | fzf -m
        $global:picker
    }
}

function Pick-Member {
    <#
    .synopsis
        You choose a property, like '.Name', then populate with values
    .description
        returns sorted, distinct list
        for example you want to query a few processes by name, ignore the rest
        .

    .example
        🐒> ps | Pick->Member Name

            Agent
            AppleMobileDeviceService
            ApplicationFrameHost
            audiodg
            BtwRSupportService

        🐒>
            #$picks = $Null # to always pick
            ps
            | Pick->Member Name
            | Out->Picker

            ps $picks
            ps | Pick->Member Name

        $picks | str ul
            | Label 'Picks: '

            ps $picks
            | Ft Name, WorkingSet64

    .example
        #$picks = $Null # always relelect values
        Get-Process
        | Pick->Member Name
        | Out->Picker

        Get-Process $picks
    .example
        PS> ls g:\ | Pick->Member Name

            Downloads
            eula.1033.txt
            eula.1036.txt
            temp

    #>
    [Alias(
        'pm', 'pickProp', 'Pick->Member'
    )]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # current object
        # Docstring
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputObject,

        # property to choose from
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory, Position = 0)]
        [string]$Name
    )

    begin {
        $valueList = [List[string]]::new()
    }
    process {
        $InputObject | ForEach-Object {

            $valueList.Add(
                (($_)?.$Name ?? $null)
            )
        }
    }
    end {
        $valueList | Sort-Object -Unique
    }
}




function Pipe-Pick {
    <#
    .synopsis
        Throw in a pipeline to quickly filter, also saves as $picker, if needed
    .description
    ..notes
        maybe integrate
        <#
            Dev.Nin\_enumerateProperty
            Dev.Nin\_gh_repoList_enumeratePropertyNames
            Dev.Nin\Get-PropertyNameCompleter
            Dev.Nin\iProp
            Dev.Nin\Invoke-PropertyChain
            Dev.Nin\Where-EmptyProperty
            Ninmonkey.Console\ConvertTo-PropertyList
            Ninmonkey.Console\Select-NinProperty
            '@ | SplitStr -SplitStyle Newline | Resolve-CommandName
            | editfunc -PassThru | % file | sort

        #>
    #>
    [Alias(
        'Pick',
        'Out->Picker'
    )]
    # [cmdletbinding()]
    param(
        #Docstring
        [Parameter(ValueFromPipeline, Mandatory)]
        [string]$Text,

        # always pick something
        [Parameter()]
        [switch]$Force
    )
    begin {
    }
    process {
    }
    end {
        if ($Force) {
            $global:picks = $null
        }

        # $choice = $Text | Join-String -sep "`n`n" | fzf -m
        $selected = $Text -join '' | fzf -m # todo: find call code using 'fzf -m', use invoke-ninfzf
        $selected

        $global:picks ??= $selected
        $global:picks
    }
}

if (! $experimentToExport) {
    # Get-ChildItem .. | Select-Object -First 3 | ForEach-Object name
    $files = Get-ChildItem c:\ -dir | ForEach-Object name | s -First 9
    $files | Out->Picker

    #| Out->Picker
}
