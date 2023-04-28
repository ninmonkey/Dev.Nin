BeforeAll {
    Import-Module Dev.Nin #-Force
}

Describe 'Filter-ByTypeName' {
    Describe 'IncludeTypes' {
        BeforeAll {
            $today = Get-Date
        }
        It -Pending ' <Sample> is <IsType>, <NotType> was <Expected>' -ForEach @(
            @{
                # 'a', 23, 5 | Filter-ByTypeName -IsType 'int'
                Sample   = @(
                    'a', 23, 'cat'
                )
                IsType   = @(
                    'int', 'cat'
                )
                NotType  = @(
                )
                Expected = @(
                    'a', 23, 'cat'
                )
            }
            @{
                Sample   = @(
                    [System.ConsoleColor]'red'
                )
                IsType   = @(
                    [System.ConsoleColor]
                )
                NotType  = @(
                )
                Expected = @(
                    [System.ConsoleColor]'red'
                )
            }
        ) {
            $Sample
            | Filter-ByTypeName -IsType $IsType -IsNotType $NotType
            | Should -Be $Expected

        }
        It 'hardCoded' {
            $now = Get-Date

            45, 'foo', $now
            | Filter-ByTypeName -IsType 'int', 'datetime'
            | Should -Be @(45, $now)
        }
        It 'hardCoded' {

            45, 'foo', (Get-Date)
            | Filter-ByTypeName -IsType 'int', 'datetime'
            | Should -BeOfType 'int', 'datetime'
            # | Should -BeExactly @(45, )

        }
    }

    Describe 'ExcludeTypes' -Skip {

    }
    Describe 'IncludeTypes and ExcludeTypes' -Skip {

    }
}
