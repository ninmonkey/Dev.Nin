$experimentToExport.function += @(
    'Peek-NewestItem'
)
$experimentToExport.alias += @(
    'Peek'
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
    [Alias('Peek')]
    [CmdletBinding(PositionalBinding = $false)]
    param(

    )

    begin {}
    process {
        $OutputMode = 'newest'
        switch ($OutputMode) {
            'newest' {
                _Peek-NewestItem
            }
            default {
                "Unhandled mode: '$outputMode'"
            }
        }
    }
    end {}
}
function _Peek-NewestItem {
    <#
    .synopsis
        find files, like an EverythingSearch, but also preview them in Bat
    .description
       basic idea is
    .example
          .
    .outputs
          [string | None]


    .notes
        #$search | fzf -m --preview 'bat --color=always --style=numbers --line-range=:50 {}'
    #fd -e ps1 --color=always | fzf -m --preview 'bat --color=always --style=numbers --line-range=:50 {}'
    .link
        Dev.Nin\Find-FDNewestItem
    .link
        Dev.Nin\Peek-NewestItem
    .link
        Dev.Nin\Find-DevFdFind
    .link
        Dev.Nin\Invoke-FdFind
    #>

    [Alias('peek')]
    [CmdletBinding(PositionalBinding = $false)]
    param(

        # [Alias('Text')]
        # [Parameter(Mandatory, Position = 0)]
        # [string[]]$InputText
    )
    begin {
    }
    process {
        $binFd = Get-NativeCommand 'fd'
        $binFzf = Get-NativeCommand 'fzf'
        $batString = 'bat --color=always --style=numbers --line-range=:50 {}' #| Join-String -SingleQuote

        fd -e ps1 --changed-within 2weeks  --color=always | fzf -m --preview "$batString"
    }
    end {
    }
}


function _PeekAfterJoinLinesMaybe {
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
