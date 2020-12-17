function Format-Template {
    <#
    .synopsis
        hashtable template
    .notes
        use a better verb?
    #>
}


function Dev-GetHelpFromType {
    [Alias('TypeHelp')]
    <#
    .synopsis
        look up .net TypeName
    .notes
        improvements:
        - [ ] pipe array so that duplicate types are removed
        - [ ] autocomplete $MemberName
        - [ ] inspect [ReflectedType] ?
        - [ ] select -First or First count ?
            see 'Find-Member'
    .example
        $Sample = @{ 'a' = 'b' }
        # 20, $Sample | Dev-GetHelpFromType -Debug
        $Sample | Dev-GetHelpFromType -Debug
        $Sample | Dev-GetHelpFromType -MemberName Keys -Debug
    #>
    param(
        # object to get type of
        [Parameter(
            Mandatory, ValueFromPipeline)]
        [AllowEmptyString()]
        [object]$InputObject,

        # member or property name
        [Parameter(Position = 0)]
        [Alias('Name')]
        [String]$MemberName,

        # Returns urls instead of opening the browser
        [Parameter()][switch]$PassThru
    )

    begin {
        $UrlTemplate = @{
            'Default' = 'https://docs.microsoft.com/en-us/dotnet/api/{0}' # system.io.fileinfo
        }

        $ValidDocVersions = @(
            'net-5.0'
            'netcore-3.1'
            'netframework-4.8'
        )
        $ItemCount = 0
        #todo: handle already typeinfo instance being passed
        $UrlList = @()
    }

    process {
        Write-Warning "WIP: Finish"
        $ItemCount++
        if ((! $PassThru) -and $ItemCount -gt 3) {
            # throttle spam
            throw "TooManyResults: Throttle to prevent accidental browser spam. This should, fallback to ShouldProcess. and/or increase impact level"
        }
        if ($InputObject -is [type]) {
            $typeInstance = $InputObject
        } elseif ($InputObject -is [string]) {
            $typeInstance = $InputObject -as [type]
        } else {
            $typeInstance = $InputObject.GetType()
        }

        # verify drop assembly info
        $NormalName = $typeInstance.Namespace, $typeInstance.Name -join '.'
        $Url = $UrlTemplate.Default -f $NormalName
        if (! [string]::IsNullOrWhiteSpace( $MemberName )) {
            $Url += '{0}.{1}' -f ( $Url, $MemberName )
        }
        $UrlList += $Url

        $meta = @{
            InputObject = $InputObject ? ($InputObject | Format-TypeName) : $InputObject
            NormalName  = $NormalName
            PSTypeNames = $InputObject.PSTypeNames | Join-String -Separator ', ' -prop { $_ | Format-TypeName }
            Url         = "<$Url>"
        }

        $meta | Format-HashTable -Title 'meta' | Out-String -Width 9999 | Write-Debug

    }
    end {

        foreach ($Url in $UrlList) {
            if (! $PassThru) {
                Start-Process $Url
            } else {
                "<$Url>"
            }
        }

    }
}

'afds' | Dev-GetHelpFromType -PassThru

if ($false -and $DevTest) {

    $Sample = @{ 'a' = 'b' }
    # 20, $Sample | Dev-GetHelpFromType -Debug
    $Sample | Dev-GetHelpFromType -Debug
    $Sample | Dev-GetHelpFromType -MemberName Keys -Debug
}
H1 '1'
20, 'a' | Dev-GetHelpFromType -MemberName Keys -Debug -PassThru
H1 '2'
20, 'a', 'a' | Dev-GetHelpFromType -Debug -PassThru


# lazy eval so that initial import doesn't take a long time
$_cachedHelpTopics = $null

function _old_get-DocsDotnet {
    <#
    .synopsis
    search docs for dotnet/powershell
    .notes
        reference urls:

        query parameters:
            view = 'netcore-3.1', 'net-5.0', etc...

        by classname:
        by enumname:
            https://docs.microsoft.com/en-us/dotnet/api/system.io.fileinfo
            https://docs.microsoft.com/en-us/dotnet/api/system.io.fileattributes
    #>

    param (
        # TypeInstance or name
        [Parameter(Mandatory, Position = 0)]
        $InputObject
    )

    $PSBoundParameters | Format-Table |  Out-String -w 9999 | Write-Debug

    if ($InputObject -is 'String') {
        $TypeInfo = $InputObject -as 'Type'
        if (! $TypeInfo ) {
            Write-Error "Could not convert to typename: '$InputObject'"
            return
        }
    }
    if ($InputObject -is 'type') {
        $TypeInfo = $InputObject
    } else {
        $TypeInfo = $InputObject.GetType()
    }

    $FullName = $TypeInfo.Namespace, $TypeInfo.Name -join '.'
    Label "Goto: $FullName" -fg Yellow

    $metaDebug = @{
        'FullName'              = $TypeInfo.Namespace, $TypeInfo.Name -join '.'
        'NameColor'             = $TypeInfo | Label 'tinfo' -fg orange
        'InputObject.GetType()' = $InputObject | Format-TypeName
        'TypeInfo'              = $TypeInfo
    }

    $metaDebug |  Write-Debug


    # @{
    #     'ParameterSetName'  = $PSCmdlet.ParameterSetName
    #     'PSBoundParameters' = $PSBoundParameters
    # } | Format-Table |  Out-String | Write-Debug




    $InputObject.GetType().Name | Write-Debug
    "InputObject: '$TypeName'" | New-Text -fg 'green' | Write-Debug
    "TypeInfo: '$TypeInfo'" | New-Text -fg 'green' | Write-Debug
}


if ($true -and $TERM_DEBUG) {
    $type_gcm = Get-Command | Select-Object -First 1
    $type_file = Get-ChildItem . -File | Select-Object -First 1

    H1 ' literal: FileInfo'
    _get-DocsDotnet 'System.IO.FileInfo' -Debug

    H1 'fromObject: FileInfo'
    _get-DocsDotnet $type_file.GetType() -Debug

    H1 'fromObject: gcm'
    _get-DocsDotnet $type_gcm.GetType() -Debug
    # _get-DocsDotnet 'fake.FileInfo' -Debug
    # _get-DocsDotnet 'System.IO.FileInfo' -Debug
}
function Dev-GetDocs {
    <#
    .description
        later will be split into multiple commands
        or user configurable locations
    #>

    param(
        # Main Query
        [Parameter(Position = 1)]
        [string]$Query,

        # Which preset to search?
        [Parameter(Mandatory, Position = 0)]
        [ValidateSet(
            '.Net',
            '.Net Core',
            '.Net Types',
            'Excel',
            'Power Query',
            # 'About_Powershell',
            'DAX.guide',
            'PowerShell',
            'Ps1',
            'Power BI',
            'VS Code | Docs',
            'VS Code | Dev Docs',
            # 'Github Code Search',
            # 'Github Project',
            # 'Github User',
            # 'Google',
            'Windows Terminal'
        )]
        [string]$Type,

        # Optional regex pattern for some commands
        [parameter()]
        [string]$Pattern
    )
    Write-Warning 'add: should-process before invoke (refactor to the Out-Browser command)'

    $QueryIsEmpty = [string]::IsNullOrWhiteSpace( $Query )
    $PatternIsEmpty = [string]::IsNullOrWhiteSpace( $Pattern )
    $Breadcrumb = '➟'
    $UriList = @{
        'ExcelFormula' = 'https://support.microsoft.com/en-us/office/formulas-and-functions-294d9486-b332-48ed-b489-abe7d0f9eda9?ui=en-US&rs=en-US&ad=US#ID0EAABAAA=More_functions'
    }

    if ($null -eq $script:_cachedHelpTopics) {
        $script:_cachedHelpTopics = Get-Help -Name 'about_*' | Select-Object -ExpandProperty Name | Sort-Object
    }

    switch ($Type) {
        'Excel' {
            Write-AnsiHyperlink $UriList.ExcelFormula "Excel_${Breadcrumb}_Formulas_and_functions" -AsMarkdown
        }
        'Ps1' {}
        'PowerShell' {

            if ( $Query -like 'about' -or $QueryIsEmpty ) {
                $helpTopics = $_cachedHelpTopics

                if ($PatternIsEmpty) {
                    return $helpTopics
                } else {
                    $helpTopics | Where-Object {
                        $_.Name -match $Pattern
                    }
                    return
                }


            }

            Write-Warning "Nyi: Query '$Type' | Where-Object '$Pattern'"
            break
        }
        # { '.Net' -or

        # }

        # @{
        #     Type  = $Type
        #     Query = $Query
        # } | Format-Table | Out-String | Write-Debug
        default {
            Write-Error "Nyi: '$Type'"
        }
    }
}

# Docs Excel

# Get-Docs 'About_Arrays' PowerShell -Debug -Verbose
# Get-Docs