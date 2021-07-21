C:\Users\cppmo_000\Documents\2021\Powershell\buffer\2021-07

function New-DevFileSketchItem {
    <#
    .synopsis
        create and open a new file, like
            C:\Users\cppmo_000\Documents\2021\Powershell\buffer\2021-07
    .description
        create a new file name using the pattern

        future:
            - [ ] Get-DevFileSketchItem:  version of the func that quickly grabs files from there
            - [ ] Edit-DevFileSketchItem: version of the func that quickly grabs files from there
    .example
        PS>
    .notes
        .
    #>
    param (

    )
    begin {
        $Config = @{
            RootPath = Get-Item -ea stop "$Env:UserProfile\Documents\2021\Powershell\buffer"
            # $Env:UserProfile\Documents\2021\Powershell\buffer\2021-07
        }
        $Template = @{
            ShortFilename = ''
        }


    }
    process {}
    end {}
}
