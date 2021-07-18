$experimentToExport.function += @(
    'Import-ModuleAll'
)
$experimentToExport.alias += @(
    're'
)

function Import-ModuleAll {
    <#
    .synopsis
        interactive use, simpify reload all

        warning: does not appear to reload current sessions scope.
        .... at least not for Help -Example pages.
    .description
        may need to declare / save / export as to the current scope?
    .example
        PS> re
    .example
        re
        stuff
    .outputs

    #>
    [alias('re')]
    [CmdletBinding(PositionalBinding = $false)]
    param(

    )

    begin {}
    process {
        $importModuleSplat = @{
            Force = $true
            Name  = 'Dev.Nin', 'ninmonkey.console'
        }

        Import-Module @importModuleSplat *>$0 | Out-Null
    }
    end {
        Write-Warning 'may not actually reload in the current scope'
    }
}

# ${global:Import-ModuleAll} = Import-ModuleAll
