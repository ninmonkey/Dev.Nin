# C:\Users\cppmo_000\Documents\2021\Powershell\buffer\2021-07
$experimentToExport.function += 'New-DevFileSketchItem'
$experimentToExport.alias += 'NewBufferItem'



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
    [Alias('NewBufferItem')]
    [cmdletbinding(PositionalBinding = $false)]
    param (
        # Name
        [Alias('Name')]
        [Parameter(Mandatory, Position = 0)]
        [string]$PathName,

        # Labels
        [Parameter(Position = 1)]
        [ValidateSet('—', '•', '⁞', '⇢', '⇽', '⇾', '┐', '⚙', '🌎', '🎨', '🐛', '💡', '📋', '📹', '🔑', '🔥', '🕷', '🕹', '🖥')]
        [string[]]$Label,

        # PassThru
        [Parameter()][switch]$PassThru

        # completer
    )
    begin {
        $Config = @{
            # Root Path. Could Change language
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
