BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}
Describe 'Resolve-FullTypeName' {
    BeforeEach {
        $Ex_Folder = Get-ChildItem . -Directory -ea stop  | Select-Object -First 1
        $Ex_List = 'John', [uint32], 104.5
    }
    It 'Folder Object' {
        $Ex_folder | Resolve-FullTypeName
        | Should -Be 'System.IO.DirectoryInfo'
    }
    It 'Type Info' {
        $Ex_folder.GetType() | Resolve-FullTypeName
        | Should -Be 'System.IO.DirectoryInfo'
    }
    It 'Passed as Array' {
        , $Ex_List | Resolve-FullTypeName
        | Should -Be 'System.Object[]'
    }
    It 'As items' {
        $Ex_List | Resolve-FullTypeName
        | Should -Not -Be 'System.Object[]'
    }
}

