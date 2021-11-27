BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
    # Import-Module Dev.Nin -Force
}

Describe 'Where-EmptyProperty' {
    BeforeAll {
        $SampleEmptyAliasList = Get-Alias *
        | Where-Object {
            [string]::IsNullOrWhiteSpace( $_.Source  )
        }
    }
    It 'Hardcode failure to remember status' {
        Get-Alias * | Where-EmptyProperty -property Source
        $true | Should -Be $false -Because 'compare vs known filter'
    }
}
