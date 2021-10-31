$experimentToExport.function += @(
    'Peek-NewestItem'
    'Peek'
)
$experimentToExport.alias += @(
)

function Peek-NewestItem {
    <#
    .synopsis
        find newest, preview them in bat
    .description
        .
    .notes
        future:
            - [ ]
    .example
        🐒>
    #>
    # [alias(
    #     'Str', 'JoinStr',
    #     'Csv', 'NL',
    #     'Prefix', 'Suffix',
    #     'QuotedList', #single/double
    #     'UL', 'Checklist'
    # )]
    # [OutputType([String])]
    [CmdletBinding(PositionalBinding = $false)]
    param(

    )

    begin {}
    process {

    }
    end {}
}


function Peek {
    <#
    .synopsis
        peek
    .description
       basic idea is
        #$search | fzf -m --preview 'bat --color=always --style=numbers --line-range=:50 {}'
    .example
          .
    .outputs
          [string | None]

    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # stdin
        [Alias('Text')]
        [Parameter(Mandatory, Position = 0)]
        [string[]]$InputText
    )

    begin {
        # Not sure if I need
        $textLines = [list[string]]::new()
    }
    process {
        $Name | ForEach-Object {
            $textLines.Add( $_ )
        }
    }
    end {
        $textLines
    }
}
