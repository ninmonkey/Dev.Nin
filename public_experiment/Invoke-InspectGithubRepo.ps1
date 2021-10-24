#Requires -Module pansies
#Requires -Version 7.0.0

$experimentToExport.function += @(
    'Invoke-InspectGithubRepo'
)
# $experimentToExport.alias += @()
function Invoke-InspectGithubRepo {
    <#
    .synopsis
        queries some git info
    .notes

    #>
    # [Alias('WriteTextColor', 'Write-Color')]
    [cmdletbinding(PositionalBinding = $false)]
    param(
        # # When colors can be close
        [alias('Cache')]
        [Parameter()]
        [switch]$ForceCache
        # Foreground [rgbcolor]
        # [Alias('Fg', 'Color')]
        # [ValidateNotNullOrEmpty()]
        # [Parameter(
        #     Mandatory, Position = 0,
        #     ValueFromPipelineByPropertyName
        # )]
        # [PoshCode.Pansies.RgbColor]
        # $ForegroundColor,

        # # $Color = [rgbcolor]::new(164, 220, 255),
        # # $ForegroundColor = [rgbcolor]::FromRGB((Get-Random -Max 0xFFFFFF)),

        # # Background [RgbColor]
        # [Alias('Bg')]
        # [ValidateNotNullOrEmpty()]
        # [Parameter(Position = 1)]
        # # $Color = [rgbcolor]::new(164, 220, 255),
        # [PoshCode.Pansies.RgbColor]
        # $BackgroundColor, #= #[rgbcolor]::FromRGB((Get-Random -Max 0xFFFFFF)),

        # [Alias('InputObject')]
        # [Parameter(Mandatory, ValueFromPipeline)]
        # [AllowEmptyString()]
        # [ValidateNotNull()]
        # # [ValidateNotNullOrEmpty()]
        # [string]$Text,


    )
    begin {
        $PSBoundParameters | format-dict
        $binGh = Get-NativeCommand 'gh'
        $ghArgs = @(
            'repo'
            'list'
            'dfink'
            "--json='updatedAt,url,nameWithOwner,primaryLanguage,description,forkCount,parent,stargazerCount,watchers,isFork,isPrivate,languages,latestRelease,licenseInfo,mentionableUsers,projects,pushedAt,updatedAt,viewerHasStarred,viewerPermission,viewerSubscription'"
        )

    }
    process {

    }
    end {

    }
}

# @'
# gh repo list dfink --json='updatedAt,url,nameWithOwner,primaryLanguage,description,forkCount,parent,stargazerCount,watchers,isFork,isPrivate,languages,latestRelease,licenseInfo,mentionableUsers,projects,pushedAt,updatedAt,viewerHasStarred,viewerPermission,viewerSubscription'
# '@

# 'sdfos'
# hr 2
