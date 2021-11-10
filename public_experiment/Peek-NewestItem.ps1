#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_Peek-NewestItem'
        
        '_PeekAfterJoinLinesMaybe'
        'Peek-NewestItem'
    )
    $experimentToExport.alias += @(
        'Peek'
        'PeekNew'
        'pipe->Peek', 'Out-Peek', 'Out->Peek'
    )
}


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
        Write-Information "Mode: '$OutputMode'"
        switch ($OutputMode) {
            'newest' {
                _Peek-NewestItem
            }
            default {
                throw "Unhandled mode: '$outputMode'"
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

    [Alias('PeekNew')]
    [CmdletBinding(PositionalBinding = $false)]
    param(        
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
        fd -e ps1 $whatStr $When --color=always
        | fzf -m --preview "$previewCommand"
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
        Get-ChildItem -File . | First 3 | _PeekAfterJoinLinesMaybe
    .example
        newestItem🔎 Code-Workspace💻
        | StripAnsi | To->RelativePath
        | pipe->Peek

          .
    .outputs
          [string | None]

    #>
    [Alias('pipe->Peek', 'Out-Peek', 'Out->Peek')]
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
                | fzf -m --preview 'bat --color=always --style=snip,header,numbers --line-range=:200 {}'
            }
        }
        
            
    }
}


if (! $experimentToExport) {
    # ...
    Get-ChildItem -File . | First 3 | _PeekAfterJoinLinesMaybe
}