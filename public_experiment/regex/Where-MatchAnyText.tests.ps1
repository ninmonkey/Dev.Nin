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
    It 'FromOriginal' -Pending {
        # $ErrorActionPreference = 'stop'

        $samples = 'cat', 'at', 'dog', '34'
        $regex = 'at', '\d+'
        $expect = 'cat', 'at', '34'


        $res = $samples | Where-MatchAnyText -pattern $regex
        $res -join ', '

        $samples | Where-MatchAnyText -pattern $regex
        | Should -Be $expect


        hr
        # Where-MatchAnyText -InputText $samples -pattern $regex -Debug -ea break
        Where-MatchAnyText -InputText $samples[0] -pattern $regex -Debug
        hr
        # ...
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
