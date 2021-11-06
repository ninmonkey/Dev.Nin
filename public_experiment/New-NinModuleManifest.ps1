$experimentToExport.function += @(
    'New-NinModuleManifest'
)
# $experimentToExport.alias += 'Re', 'ReLiteral'

function New-NinModuleManifest {
    <#
    .synopsis
        boilerplate module creation
    .description
        .
    .notes
        . todo: implement
    .example
        $pattern = re 'something' -AsRipGrep
        rg @('-i', $Pattern)
    .notes
        todo
    .outputs

    #>
    # [alias('')]
    [CmdletBinding(PositionalBinding = $false, SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        # Text to convert to a literal
        [Alias('Name')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$ModuleName,

        # relative path to start in
        [Alias('Path')]
        [Parameter()][string]$BasePath = '.',

        # Description Field
        [Parameter()]
        [string]$Description = 'description',

        # Description Field
        # suggest completer: VirtualTerminal, ANSI, EscapeSequences, Color, PSScriptAnalyzer, Dotnet, Class, Member, Reflection
        [Parameter()]
        [string[]]$Tags = @('')
    )
    begin {
    }
    process {

        $UserBasePath = Get-Item $BasePath
        $ModuleBasePath = Join-Path $UserBasePath $ModuleName
        if (Test-Path $ModuleBasePath) {
            # todo: throw $PSCmdlet
            Write-Error "Path already exists: '$ModuleBasePath'"
            return
        }
        if ($PSCmdlet.ShouldProcess("'$ModuleBasePath'", 'Create Module Directory')) {
            New-Item -Path $ModuleBasePath -ItemType Directory
        }

        # $ManifestPath = Join-Path $ModuleBasePath "$Module.psd1"

        <#

        UserBasePath = '.'
        ManifestPath_FullName          C:\Users\cppmo_000\Documents\2021\Powershell\My_Github\micro.modules\C:\Users\cppmo_000\Documents\2021\Powershell\My_Github\micro.modules\business
        ModuleBasePath                 C:\Users\cppmo_000\Documents\2021\Powershell\My_Github\micro.modules\business
        ModuleBasePath: C:\Users\cppmo_000\Documents\2021\Powershell\My_Github\micro.modules\business
        ModuleName                     business
        MyInvocation                   System.Management.Automation.InvocationInfo
        newModuleManifestSplat         {ProjectUri, Copyright, Description, ModuleVersion…}
        null
        PSBoundParameters              {}
        PSCmdlet                       System.Management.Automation.PSScriptCmdlet
        PSCommandPath
        PSDebugContext                 System.Management.Automation.PSDebugContext
        PSItem
        PSScriptRoot
        RootModulePath                 business.psm1
        RootModulePath_FullName        C:\Users\cppmo_000\Documents\2021\Powershell\My_Github\micro.modules\C:\Users\cppmo_000\Documents\2021\Powershell\My_Github\micro.modules\business
        Tags                           {}
        true                           True
        UserBasePath                   C:\Users\cppmo_000\Documents\2021\Powershell\My_Github\micro.modules

        #>


        # make usable and then load it

        $ManifestName = "${ModuleName}.psd1"
        $RootModuleName = "${ModuleName}.psm1"
        $ManifestPath_FullName = (Join-Path $ModuleBasePath $ManifestName)
        $RootModulePath_FullName = (Join-Path $ModuleBasePath $ModuleBasePath)
        $newModuleManifestSplat = @{
            Path          = $ManifestName
            RootModule    = $RootModuleName
            Author        = 'Jake Bolton' # (github.com/ninmonkey/dotfiles_git)'
            ModuleVersion = '0.0.1'
            Description   = $Description
            Tags          = $Tags
            ProjectUri    = 'https://github.com/ninmonkey/{0}' -f @($ModuleName)
            LicenseUri    = 'https://github.com/ninmonkey/{0}/blob/master/LICENSE' -f @($ModuleName)
            CompanyName   = 'ninmonkeys.com'
            Copyright     = '(c){0} Jake Bolton. All rights reserved.' -f @( (Get-Date).Year )
        }
        if ([string]::IsNullOrWhiteSpace($Tags)) {
            $newModuleManifestSplat.Remove('Tags')
        }

        if (Test-Path $ManifestPath_FullName) {
            # todo: throw $PSCmdlet
            Write-Error "Path already exists: '$ManifestPath_FullName'"
            return
        }
        if (Test-Path $RootModulePath_FullName) {
            # todo: throw $PSCmdlet
            Write-Error "Path already exists: '$RootModulePath_FullName'"
            return
        }

        # $newModuleManifestSplat | Format-Table

        if ($PSCmdlet.ShouldProcess("'$ManifestPath_FullName'", 'Write New Manifest?')) {
            New-ModuleManifest @newModuleManifestSplat
            # New-Item -Path $RootModulePath_FullName -ItemType File
        }

        Get-ChildItem . -Recurse

        New-Text -fg orange 'NYI: Initialize git repo' | Join-String
        Read-Host 'Ready? '
        Test-ModuleManifest -Path $ManifestName

    }
    end {}
}
