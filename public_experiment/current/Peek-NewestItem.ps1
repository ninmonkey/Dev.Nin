#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        # 'old_Peek->NewestItem'
        'Peek-NewestItem'
        # 'Pipe-Peek2'
    )
    <#

    # todo: future: 'bat' command can truncate newlines, when peeking
    # like the output form several of: which have tons of empty newlines:
        https://docs.microsoft.com/en-gb/azure/azure-monitor/essentials/metrics-supported
    #>


    $experimentToExport.alias += @(
        'Peek->NewestItem' # 'Peek-NewestItem'
        'Pipe->Peek2' # 'Pipe-Peek2'
        # 'Out->Peek' # 'Pipe-Peek2
    )
    # old batch of names
    # functions
    # '_Peek-NewestItem'
    # '_PeekAfterJoinLinesMaybe'
    # 'Peek->NewestItem'
    # alias
    # 'Peek'
    # 'PeekNew'
    # 'pipe->Peek', 'Out-Peek', 'Out->Peek'
}


# function Peek->NewestItem {
#     <#
#     .synopsis
#         find newest, preview them in bat
#     .description
#         .
#     .notes
#         future:
#             - [ ]
#     .example
#         🐒>
#     #>
#     # [alias(
#     #     'Str', 'JoinStr',
#     #     'Csv', 'NL',
#     #     'Prefix', 'Suffix',
#     #     'QuotedList', #single/double
#     #     'UL', 'Checklist'
#     # )]
#     # [OutputType([String])]
#     # [Alias('Peek')]
#     [CmdletBinding(PositionalBinding = $false)]
#     param(

#     )

#     begin {
#     }
#     process {
#         $OutputMode = 'newest'
#         Write-Information "Mode: '$OutputMode'"
#         switch ($OutputMode) {
#             'newest' {
#                 _Peek-NewestItem
#             }
#             default {
#                 throw "Unhandled mode: '$outputMode'"
#             }
#         }
#     }
#     end {
#     }
# }

function Peek-Invoke {
    <#
    .synopsis
        find files, like an EverythingSearch, but also preview them in Bat
    .description
       Maybe this is Peek.Preview and Filter->Newest or ?Newest comes
       todo:
        - [ ] #6 #1
        - [ ] fix naming: 'bad name, does not represent function.'
            Newest should be a filter like
            ?Newest
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
        Dev.Nin\Peek-Invoke
    .link
        Dev.Nin\Find-DevFdFind
    .link
        Dev.Nin\Invoke-FdFind
    #>

    [Alias(
        'Peek-Invoke'
        # 'Pipe->PeekNewest'
    )]
    [CmdletBinding()]
    param(
        [Parameter(
            ParameterSetName = 'FromPipeline',
            Mandatory, ValueFromPipeline
        )]
        [object]$InputObject,



        [Parameter(Position = 0)]
        [ArgumentCompletions(
            '2weeks', '2days', '2hours'
        )]
        [string]$When = '2weeks',

        [Parameter(Position = 1)]
        [ArgumentCompletions(
            'Changed_Within'
        )]
        [string]$What = 'Changed_Within'

    )
    begin {

    }
    process {
        <# old version uses

                fd -e ps1 $whatStr $When --color=always
                | fzf -m --preview "$previewCommand"

                $previewCommand = 'bat --color=always --style=numbers --line-range=:200 {}' #| Join-String -SingleQuote
                51   │

                otes
                #$search | fzf -m --preview 'bat --color=always --style=numbers --line-range=:50 {}'
                d -e ps1 --color=always | fzf -m --preview 'bat --color=always --style=numbers --line-range=:50 {}'

        #>
        $binFd = Get-NativeCommand 'fd'
        $binFzf = Get-NativeCommand 'fzf'
        $previewCommand = 'bat --color=always --style=numbers --line-range=:200 {}' #| Join-String -SingleQuote

        $whatStr = switch ($What) {
            'Changed_Within' {
                '--changed-within'
            }
            default {
                '--changed-within'
            }
        }

        & fd.exe -e ps1 $whatStr $When --color=always
        | & fzf.exe -m --preview "$previewCommand"
    }
    end {
    }
}


function Pipe-Peek2 {
    <#
    .synopsis
        peek
    .description
       basic idea is
        #$search | fzf -m --preview 'bat --color=always --style=numbers --line-range=:50 {}'
    .example
        Get-ChildItem -File . | First 3 | _PeekAfterJoinLinesMaybe
    .example
        newestItem🔎 Code-Workspace💻
        | StripAnsi | To->RelativePath
        | pipe->Peek

          .
    .outputs
          [string | None]

    #>
    [Alias(
        'Pipe->Peek2' # 'Pipe-Peek2
        # 'Out->Peek'
    )]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(
            ParameterSetName = 'FromPipeline',
            Mandatory, Position = 0,
            ValueFromPipeline
        )]
        [object]$InputObject,

        [Parameter(
            ParameterSetName = 'FromPath',
            Mandatory
        )]
        [string]$BasePath

        # [Parameter(Position=0)]
        # # stdin
        # [Alias('Text')]
        # [Parameter(Mandatory, Position = 0)]
        # [string[]]$InputText
        # Not sure if I need
        # $textLines = [list[string]]::new()
    )

    begin {
        $Config = @{
            AlwaysSkipDirectory = $true
        }
    }
    end {
        # $Input
        # Get-ChildItem .
        switch ($PSCmdlet.ParameterSetName) {
            'FromPipeline' {
                $Source = $Input
                break
            }
            'FromPath' {
                $Source = fd -e ps1 --changed-within 2weeks --color=always
                break
            }
            default {
                throw "unhandled set: '$($PSCmdlet.ParameterSetName)"
            }
        }
        $items = $input
        | Where-Object {
            if ($Config.AlwaysSkipDirectory) {
                if (Test-IsDirectory $_) {
                    $false; return;
                }
            }
            $true; return;
        }


        # $items
        # $source
        # | To->RelativePath


        switch ($OutputMode) {
            # 'diff' {
            #     fzf -m --preview 'bat --color=always --style=changes,grid,rule --line-range=:200 {}'
            #     break
            # }
            default {
                $items
                # | fzf -m --preview 'bat --color=always --style=numbers --line-range=:200 {}'
                # was:
                # | fzf.exe -m --preview 'bat --color=always --style=snip,header,numbers --line-range=:200 {}'
                | fzf -MultiSelect -PreviewCommand 'bat --color=always --style=snip,header,numbers --line-range=:200 {}'
            }
        }


    }
}


# if (! $experimentToExport) {

# }
