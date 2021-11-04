BeforeAll {
    Import-Module dev.nin -Force     
}

Describe 'Assert-BooleanXOR' {
    It '"<Input1>", <$Input2> Returns "<expected>"' -ForEach @(
        @{ Input1 = $false ; Input2 = $false; Expected = $false }
        @{ Input1 = $false ; Input2 = $true ; Expected = $true }
        @{ Input1 = $true  ; Input2 = $false; Expected = $true }
        @{ Input1 = $true  ; Input2 = $true ; Expected = $false }
    ) {
        $assertBooleanXORSplat = @{
            Input1 = $Input1
            Input2 = $Input2
        }

        Assert-BooleanXOR @assertBooleanXORSplat
    }
}

