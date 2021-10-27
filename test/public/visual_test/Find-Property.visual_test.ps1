Import-Module dev.nin, ninmonkey.console -Force
'see also: ./test/public/visual_test/Format-Dict.visual_test.ps1'


$query = @(
    Get-Item .

    @{'Species' = '🐈'; Lives = 9 }

    'hi world'

    [pscustomobject]@{ 'Something' = 3; 'Bar' = (0..4) }

) | iterProp -infa Continue