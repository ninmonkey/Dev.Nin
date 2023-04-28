#Requires -Version 7

#requres_binary

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Peek-PreviewCommandName'
    )
    $experimentToExport.alias += @(
        'Peek->CmdName' # 'Peek-PreviewCommandName'
        # 'Peek->CommandName' # 'Peek-PreviewCommandName'
    )
}

function _invokeFzfPreview {
    # aka Peek->File
    param()

}

function Peek-PreviewCommandName {
    <#
    .synopsis
        This will return descriptions of commands, for use in a parameter completer
    .description
       .
    .example
          .
    .outputs


    #>
    # [AliasTodo]: tags as 'requiresBinary' as metadata
    # [attribute]: crazyProifleAliasName ?
    [Alias(
        # 'Peek->CommandName',
        'Peek->CmdName'
    )]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [object[]]$Names
    )

    begin {
        $items = [list[object]]::new()
    }
    process {
        # $items.

    }
    end {


        # $query ??= Get-Command assert-*
        # $query | Sort-Object Module, Name
        # | editfunc -PassThru -ea ignore | ForEach-Object file
        # | To->RelativePath | Sort-Object -Unique
        # | fzf.exe --preview 'bat -l ps1 --color=always {}'
    }
}

if (! $experimentToExport) {
    # ...
}
