BeforeAll {
    Import-Module Dev.Nin -Force

    function Where-MatchAnyRegex {
        <#
        .synopsis
            When you want to filter for any match, and you don't care which matched
        #>

        [Alias('?RegexAny', '?RegexAny🔍')]
        [cmdletbinding()]
        param(

            # Regex
            [Alias('Regex')]
            [Parameter(Mandatory, Position = 0)]
            [string[]]$Pattern,

            # sample text
            [Alias('Text')]
            [Parameter(Mandatory, Position = 1, ValueFromPipeline)]
            [string]$InputText

            # todo: [Parameter(Mandatory, ParameterSetName='ByProperty', Position = 0)]
            # search property of an object instead of text
            # [string]$Property,
        )
        process {
            $AnyMatches = $false
            Write-Debug "Evaluate: '$InputText' -match '$curRegex'"
            foreach ($curRegex in $Pattern) {
                if ($InputText -match $curRegex) {
                    Write-Debug "First match: '$InputText' matches '$curRegex'"
                    $AnyMatches = $true
                    break
                }
            }
            if ($AnyMatches) {
                $InputText
            }
        }
    }
}

Describe 'Where-MatchAnyRegex' {
    BeforeAll {
        # $ErrorActionPreference = 'stop'
        $Sample = @{
            HugeList = 'Attributes', 'BaseName', 'CreationTime', 'CreationTimeUtc', 'Exists', 'Extension', 'FullName', 'LastAccessTime', 'LastAccessTimeUtc', 'LastWriteTime', 'LastWriteTimeUtc', 'LinkType', 'Mode', 'ModeWithoutHardLink', 'Name', 'Parent', 'PSChildName', 'PSDrive', 'PSIsContainer', 'PSParentPath', 'PSPath', 'PSProvider', 'Root', 'Target'
            Simple   = 'Target', 'Path', 'PSPath', 'Name', 'BaseName'
        }

    }
    It 'blank' {
        # $ErrorActionPreference = break
        $res = $Sample.Simple | Where-MatchAnyRegex -ov 'res' -pattern -Debug 'name'
        $Sample.Simple | Where-MatchAnyRegex -Pattern -Debug 'name'
    }
}

#     BeforeAll {
#         $SampleEmptyAliasList = Get-Alias * | Where-Object { [string]::IsNullOrWhiteSpace( $_.Source  ) }
#     }
#     It 'Hardcode failure to remember status' {
#         Get-Alias * | Where-EmptyProperty -property Source
#         $true | Should -Be $false -Because 'compare vs known filter'
#     }
# }


# $patterns = 'end', 'posi'
# $patterns = 'posi', '.*'
# $names ; hr;


# hr
