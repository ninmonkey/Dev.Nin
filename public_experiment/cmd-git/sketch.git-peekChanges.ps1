#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        # 'F'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

function Peek->GitChanges {
    param()
    @'
idea:
    - [ ]  display changed files in git
    - [ ]  pipe to fzf
    - [ ]  --preview to peek at the files
    - [ ] save selection of files
    - [ ] 'git add' those files
'@
}


if (! $experimentToExport) {
    # ...
}