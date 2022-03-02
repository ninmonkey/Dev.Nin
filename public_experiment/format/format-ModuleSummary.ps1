#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Format-ModuleSummary'
    )
    $experimentToExport.alias += @(
        'fmt->ModuleSummary'  # 'Format-ModuleSummary'
    )
}



function Format-ModuleSummary {
    <#
    .synopsis
        double items in the pipeline
    .notes
        future: use formatting
    .example
        PS> Get-Module | fmt->ModuleSummary
    .example
        PS> Get-Module | Get-Random 3 | fmt->ModuleSummary
    .example

        🐒> 'Pansies', 'posh-git', 'PSScriptTools', 'EditorServicesCommandSuite' | Get-Module | fmt->ModuleSummary | ft

            Name                       Author                                     Tags
            ----                       ------                                     ----
            Pansies                    Joel Bennett                               {ANSI, EscapeSequences, VirtualTerminal,
            posh-git                   Keith Dahlby, Keith Hill, and contributors {git, prompt, tab, tab-completion…}
            PSScriptTools              Jeff Hicks                                 {scripting, logging, functions, filename…
            EditorServicesCommandSuite Patrick Meinecke                           {Editor, EditorServices, VSCode, Editor…}
    .link
        Dev.Nin\Format-ModuleSummary
    .link
        Dev.Nin\Write-TypeSummaryColors
    #>
    [Alias('fmt->ModuleSummary')]
    [CmdletBinding()] #
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )

    begin {
        # $Config = @{
        #     WithColor = $true
        # }
        # $Color = @{
        #     FgDim  = 'gray70'
        #     Fg     = 'gray100'
        #     FgBold = 'orange'
        # }
        $Config.PropertyList = @(
            'Name'
            'Author'
            'Tags'
            'Description'
            'HelpInfoUri'
            'PrivateData'
            'ReleaseNotes'
        )
    }
    process {
        $InputObject | Select-Object -Property $Config.PropertyList
    }
    end {

    }
}




if (! $experimentToExport) {
    # ...
}
