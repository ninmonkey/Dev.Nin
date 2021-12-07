#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Find-ParameterSetInfo'
    )
    $experimentToExport.alias += @(
        # 'A'
        'Inspect->ParamSet'
    )
}

function Find-ParameterSetInfo {
    <#
        .synopsis
            .
        .notes
            .todo:
                cleaner custom styles for paramsets as a whole, and as individual
        .example
            PS> Inspect->ParamSet -CommandName 'str' -ListNames
        .example
            PS> Inspect->ParamSet -CommandName 'str' -ParameterName 'InputObject' -PassThru -ListNames
        .link
            Dev.Nin\What-ParameterInfo
        .link
            Dev.Nin\Get-DevParameterInfo
        .link
            PSFrameWork\Test-PSFParameterBinding
        .link
            PSScriptTools\PSScriptTools\Get-ParameterInfo
        .link
            ClassExplorer\Get-Parameter
        .link
            Indented.ScriptAnalyzerRules\Resolve-ParameterSet
        .link
            PSScriptTools\PSScriptTools\Get-ParameterInfo
        .link
            Dev.Nin\Find-CommandWithParameterAlias
        .link
            Configuration\AvoidParameterAttributeDefaultValues
        #>
    # [outputtype( [string[]] )]
    [Alias('Inspect->ParamSet')]
    [cmdletbinding()]
    param(
        # alias or command name
        # todo, future: parameter names *based on* position 0
        [parameter(Mandatory, Position = 0)]
        [string]$CommandName,

        # todo, future: autosuggest names *based on* position 0
        [parameter(Mandatory, Position = 1)]
        [ArgumentCompletions('__AllParameterSets', '*')]
        [string[]]$ParameterName = '*',

        # Return custom type
        [Parameter()][switch]$PassThru,

        # enumerate param names
        [Parameter()][switch]$ListNames,

        # extra options
        [Parameter()][hashtable]$Options
    )
    begin {
        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        # [hashtable]$Config = @{
        #     AlignKeyValuePairs = $true
        #     Title              = 'Default'
        #     DisplayTypeName    = $true
        # }
        # $Config = Join-Hashtable $Config ($Options ?? @{})
    }
    process {
        # whether it's a string or 'cmdinfo', it resolves
        $CommandName = $CommandName | Resolve-CommandName
        $qSetName = Indented.ScriptAnalyzerRules\Resolve-ParameterSet -CommandName $CommandName -ParameterName $ParameterName

        $qElements = (Get-Command $CommandName ).ParameterSets | Where-Object Name -EQ $qSetName

        if ($ListNames) {
            $qelements | ForEach-Object Parameters | ForEach-Object Name | Sort-Object -Unique
            return
        }
        if ($PassThru) {
            $qElements
            return
        }

        $sSetName
        if ($qSetName) {
            Get-Command $CommandName | PSScriptTools\Get-ParameterInfo
            | Where-Object { $_.ParameterSets -contains $qSetName }
        }

        h1 "Params from set: '$qSetName'"
        $qElements | ForEach-Object Parameters | Format-List

        h1 "SetNamed: '$qSetName'"
        $qElements | Format-Table

        $qElements.parameters | iter->prop
        | Format-Table Name, Value, TypeNameOfValue

        $qElements.parameters | Select-Object -First 1 | Format-List
        $qelements | ForEach-Object {
            $_.Name
        }

    }

    end {
    }
}

if (! $experimentToExport) {
    # ...
}
