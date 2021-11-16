if ($experimentToExport) {
    $experimentToExport.function += @(
        'Invoke-PropertyChain'
        # 'Dive-PropertyChain'
    )
    $experimentToExport.alias += @(
        'Dive->Member'
    )
}

function Invoke-PropertyChain {
    <#
    .synopsis
        sugar to dive down multiple properties or function calls, consumes null value errors for you
    .description
        consumes null value errors for you
        use case
            1]
                ... | % GetType | % FullName
                    or
                (...).GetType().FullName
    .notes
        future:
            - [ ]
    .example
        🐒> gi . | Dive.Prop '.gettype().Name' -AsIEX
                | Should -be 'DirectoryInfo'
    #>
    # [OutputType([String])]
    [Alias(
        'Dive->Member'
    )]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # what to use
        [Parameter(
            Mandatory, ValueFromPipeline)]
        $InputObject,

        # query to try
        [Parameter(Mandatory, Position = 0)]
        [string]$Query,

        # as Iex instead, make Invoke-Expression Explicit
        [Alias('EvalUnsafe')]
        [parameter(ParameterSetName = 'UsingIEX')]
        [switch]$AsIEX
    )

    begin {}
    process {
        $meta = @{
            Object    = $InputObject
            Query     = $Query
            AsIEX     = $AsIEX
            InputType = $InputObject
        }

        switch ($pscmdlet.ParameterSetName) {
            'UsingIEX' {
                '$InputObject{0}' -f @($Query) | Invoke-Expression
                return
            }

            default {}
        }
        # $meta | format-dict | wi
        $meta | Format-Table | Out-String | wi

        $curTarget = $InputObject
        $Steps = $Query -split '\.'
        $InputObject | Format-TypeName
        $steps | Join-String -sep ' -> ' -op '$InputObject -> ' | Write-Debug
        $Steps | ForEach-Object {
            $curStep = $_
            Write-Debug "Step: '$curStep'"

        }

    }
    end {}
}

if (! $experimentToExport) {
    $lvlDiagnostic = @{
        Debug             = $true
        InformationAction = 'continue'
        Verbose           = $true
    }
    Get-Item . | Dive.Prop '.GetType().FullName' -AsIEX

    Get-Date | ForEach-Object GetType
    | Dive.Prop @lvlDiagnostic fullname -ErrorAction Break

    $x = Get-Item .
    ForEach-Object -InputObject $x -MemberName gettype -infa Continue -Verbose | ForEach-Object name
    $x | Dive.Prop 'gettype.name' -infa Continue -Debug -Verbose

    $t = Get-Item .

    $Expected = 'System.IO.DirectoryInfo'
}
