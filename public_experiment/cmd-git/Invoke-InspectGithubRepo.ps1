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
        # empty the cache
        [alias('ClearCache')]
        [Parameter()]
        [switch]$ForceCache,

        [Alias('Owner')]
        [ValidateNotNullOrEmpty()]
        [Parameter(Position = 0)]
        [string]$OwnerName
        # $Color = [rgbcolor]::new(164, 220, 255),




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
        # $OwnerName ??= 'dfinke'
        $PSBoundParameters | format-dict
        # $binGh = Get-NativeCommand 'gh'
        # $ghArgs = @(
        #     'repo'
        #     'list'
        #     if ($OwnerName) {
        #         # $OwnerName
        #     }
        #     "--json='url,nameWithOwner,primaryLanguage,description,forkCount,parent,stargazerCount,watchers,isFork,isPrivate,languages,latestRelease,licenseInfo,mentionableUsers,projects,pushedAt,viewerHasStarred,viewerPermission,viewerSubscription'"
        # )


        $ExportPath = 'temp:\lastGH.json'
    }
    process {
        if ( ! $Cache ) {

            $cmd = @'
gh repo list dfinke --source -L 3 --json='nameWithOwner,url,description,homepageUrl,name,pullRequests,updatedAt,viewerHasStarred,viewerSubscription,watchers'
'@
            & $cmd
            hr 2
            & $cmd
            | Set-Content temp:\lastgt.json
            'wrote: Temp:\lastgt.json'
        }

        Get-Content Temp:\lastgt.json

        Get-Content -Path $ExportPath
        # & $binGh @ghArgs | Set-Content -Path $ExportPath
    }
    end {

        # Write-Warning 'broken'
    }
}

# @'
# gh repo list dfink --json='updatedAt,url,nameWithOwner,primaryLanguage,description,forkCount,parent,stargazerCount,watchers,isFork,isPrivate,languages,latestRelease,licenseInfo,mentionableUsers,projects,pushedAt,updatedAt,viewerHasStarred,viewerPermission,viewerSubscription'
# '@

# 'sdfos'
# hr 2
