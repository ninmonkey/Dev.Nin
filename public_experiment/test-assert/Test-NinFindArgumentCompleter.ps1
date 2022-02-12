$experimentToExport.function += 'Test-NinFindArgumentCompleter'
$experimentToExport.alias += @(
    'DevTool->💻-GetHiddenArgumentCompleter'
    'Dev->GetArgCompleter[ImpliedReflection]'
    'Dev->GetArgCompleter_ImpliedReflection'
)


function Test-NinFindArgumentCompleter {
    <#
    .synopsis
        find existing arg completers
    .description
        .

    #>
    [alias(
        'DevTool->💻-GetHiddenArgumentCompleter',
        'Dev->GetArgCompleter[ImpliedReflection]',
        'Dev->GetArgCompleter_ImpliedReflection'
    )]
    [CmdletBinding(
        PositionalBinding = $false,
        ConfirmImpact = 'High',
        SupportsShouldProcess)]
    param(

    )
    process {

        <#
        from docs: The 'Enable-ImpliedReflection' function replaces the Out-Default cmdlet with a proxy function that invokes Add-PrivateMember on every object outputted to the console.
        #>
        if ($PSCmdlet.ShouldProcess('Enable Implied-Reflection', 'High Impact Import')) {
            # Import-Module ClassExplorer
            Enable-ImpliedReflection -Force
            Write-Warning 'ImpliedReflection: Enabled'
            # [object[]]$completerList = $ec._context.CustomArgumentCompleters.GetEnumerator()
            [object[]]$completerList = $ec._context.CustomArgumentCompleters
            $completerList
        }


    }

}
