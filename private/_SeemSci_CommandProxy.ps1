function Get-CommandEx {
    <#
    .notes
        from: <https://gist.github.com/SeeminglyScience/9983f6f39e96cb853e05d97b704c371e>
        and the discord thread:
            <https://discord.com/channels/180528040881815552/446156137952182282/857071604219641907>

    #>
    [CmdletBinding(DefaultParameterSetName = 'CmdletSet', HelpUri = 'https://go.microsoft.com/fwlink/?LinkID=2096579')]
    param(
        [Parameter(ParameterSetName = 'AllCommandSet', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        ${Name},


        [Parameter(ParameterSetName = 'CmdletSet', ValueFromPipelineByPropertyName = $true)]
        [string[]]
        ${Verb},

        [Parameter(ParameterSetName = 'CmdletSet', ValueFromPipelineByPropertyName = $true)]
        [string[]]
        ${Noun},

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Microsoft.PowerShell.Commands.ModuleSpecification[]]
        ${FullyQualifiedModule},

        [Parameter(ParameterSetName = 'AllCommandSet', ValueFromPipelineByPropertyName = $true)]
        [Alias('Type')]
        [System.Management.Automation.CommandTypes]
        ${CommandType},

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [int]
        ${TotalCount},

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [switch]
        ${Syntax},

        [switch]
        ${ShowCommandInfo},

        [Parameter(Position = 1, ValueFromRemainingArguments = $true)]
        [Alias('Args')]
        [AllowEmptyCollection()]
        [AllowNull()]
        [System.Object[]]
        ${ArgumentList},

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [switch]
        ${All},

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [switch]
        ${ListImported},

        [ValidateNotNullOrEmpty()]
        [string[]]
        ${ParameterName},

        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSTypeName[]]
        ${ParameterType},

        [Parameter(ParameterSetName = 'AllCommandSet')]
        [switch]
        ${UseFuzzyMatching},

        [Parameter(ParameterSetName = 'AllCommandSet', ValueFromPipelineByPropertyName = $true)]
        [switch]
        ${UseAbbreviationExpansion})

    begin {
        $PSBoundParameters['Module'] = 'ClassExplorer'
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer)) {
                $PSBoundParameters['OutBuffer'] = 1
            }

            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Core\Get-Command', [System.Management.Automation.CommandTypes]::Cmdlet)
            $scriptCmd = { & $wrappedCmd @PSBoundParameters }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($PSCmdlet)
        }
        catch {
            throw
        }
    }

    process {
        try {
            $steppablePipeline.Process($_)
        }
        catch {
            throw
        }
    }

    end {
        try {
            $steppablePipeline.End()
        }
        catch {
            throw
        }
    }
    <#

    .ForwardHelpTargetName Microsoft.PowerShell.Core\Get-Command
    .ForwardHelpCategory Cmdlet

    #>
}
