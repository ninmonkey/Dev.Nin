BeforeAll {

    if ($false -and 'use pester') {

        $exampleList = @(
            [pscustomobject]@{
                Name = 'Bob'
                Id   = 0
                Guid = 0
            }
            [pscustomobject]@{
                Name = 'Bob'
                Id   = 10
                Guid = 1
            }
            [pscustomobject]@{
                Name = 'Ben'
                Id   = 10
                Guid = 2
            }
        )

        $Manual = @{}
        $Manual.Name_DESC_Id_DESC = @(
            @{ expression = 'Name'; Descending = $true }
            @{ expression = 'Id'; Descending = $true }
        )
        $Manual.Name_ASC_Id_DESC = @(
            @{ expression = 'Name'; Descending = $false }
            @{ expression = 'Id'; Descending = $true }
        )
        $Manual.Name_DESC = @(
            @{ expression = 'Name'; Descending = $false }
        )
        function _runSortTest {
            # Format results from testing
            param(
                # Sort-Object property list
                [Parameter(Mandatory, Position = 0)]
                [hashtable[]]$PropList
            )
            # $PropList.GetEnumerator() | Join-String { $_.Key } -Separator ' '
            # $PropList | Format-HashTable
            H1 'Sort Test:'
            # $PropList.GetEnumerator() | ForEach-Object {
            #     @{ $_.expression = ($_.Descending) ? 'Desc' : 'Asc' }
            # } | Format-HashTable

            Format-HashTableList $PropList | Label 'sort hash' -fg magenta

            $exampleList | Sort-Object -Property $PropList | Format-Table
            # hr

        }
    }
}

Describe 'Sort-NinObject' {
    It 'NYI' {
        $False | Should -Be $True

        if ($false) {
            try {
                $exampleList | Sort-NinObject 'Guid', 'Id'
            }
            catch {
                Write-Warning 'Sort-NinObject NYI'
            }

            if ($FinalPesterTest) {
                # test for non-existing properties
                $exampleList | Sort-NinObject 'Guid', 'Id', 'NonExisting' -DescendingProperty 'id', 'guid', 'other'

                # test for non-existing sort order
                $exampleList | Sort-NinObject 'Guid', 'Id'  -DescendingProperty 'id', 'guid', 'NonExisting'
            } Write-Warning 'dont forget pester'
            if ($DebugTestMode) {
                H1 'Sort-NinObject' -fg red

                $sortSplat = @{
                    InformationAction = 'Continue'
                    Debug             = $false
                    SortByProperty    = @(
                        'Cat'
                    )
                }
                # $exampleList | Sort-NinObject -InformationAction Continue -SortByProperty Name -Debug
                $exampleList | Sort-NinObject @sortSplat
                Hr
                $exampleList | Sort-NinObject @sortSplat -SortByProperty Name
            }
            # $t.GetEnumerator() | ForEach-Object {
            #     @{ $_.expression = $_.Descending }
            # } | Format-HashTable
            # | Join-string -sep ', ' -DoubleQuote {
            #     $_.Expression, $_.Descending -join ''
            # }

            # $t.GetEnumerator() | ForEach-Object {
            #     @{a = $_.key; b = $_.Value }
            #     $x = 3
            # }
            #| Join-String { $_.Key, $_.Value -join ':' } -Separator ' '


            if ($DebugTestMode) {
                Hr
                H1 'Manual Sort' -fg red
                $exampleList
                _runSortTest $Manual.Name_DESC_Id_DESC
                _runSortTest $Manual.Name_DESC
                _runSortTest $Manual.Name_ASC_Id_DESC
            }

            if ($false) {
                $files = Get-ChildItem | Sort-Object Name

                $files
                | Format-Table Name, Length, LastWriteTime

                $files
                | Sort-Object Length
                | Format-Table Name, Length, LastWriteTime
            }

        }

    }
}
