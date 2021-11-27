BeforeAll {
    Import-Module Dev.Nin -Force


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
