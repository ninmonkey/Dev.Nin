BeforeAll {
    # . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
    Import-Module 'Dev.Nin' -Force
}
Describe 'Resolve-TypeName' {
    BeforeEach {
        $Ex_Folder = Get-ChildItem . -Directory -ea stop | Select-Object -First 1
        $Ex_List = 'John', [uint32], 104.5
    }
    It 'Folder Object' {
        $Ex_folder | Resolve-TypeName
        | Should -Be 'System.IO.DirectoryInfo'
    }
    It 'Type Info' {
        $Ex_folder.GetType() | Resolve-TypeName
        | Should -Be 'System.IO.DirectoryInfo'
    }
    It 'Passed as Array' {
        , $Ex_List | Resolve-TypeName
        | Should -Be 'System.Object[]'
    }
    It 'As items' {
        $Ex_List | Resolve-TypeName
        | Should -Not -Be 'System.Object[]'
    }
}
