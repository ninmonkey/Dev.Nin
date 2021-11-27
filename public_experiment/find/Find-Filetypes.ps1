using namespace Management.Automation

$experimentToExport.function += @(
    'Find-Filetype'
    'Get-FileTypeExtension'
)
$experimentToExport.alias += @(
    'LsExt'
    'Completion->FileExtensionType'
)

function _get-ExtensionsList {
    param(
        [Alias('PSPath')]
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [String]$Path = '.',
        [int]$Depth = 3
    )
    $e = Get-ChildItem -Path $Path -File -Depth $Depth -Force -ea SilentlyContinue
    | ForEach-Object Extension | Sort-Object -Unique
    $e
    # fd -t f -d 1 | ForEach-Object {
    #     if ($_ -match '(?<rest>)(?<ext>\.[^\.]*?$)') {
    #         $Matches.'ext'
    #     }
    # } #| Sort-Object -Unique
}

function Find-FileType {
    <#
    .synopsis
        Find extension types quickly using fdfind
    .description

    .notes
        todo:
        - [ ]
    .link
        Dev.Nin\Find-FDNewestItem
    .link
        Get-FileTypeExtension
    .example
        🐒> Find-Filetypes
    .outputs
        string[]

    #>
    [Alias('LsExt')]
    [OutputType( [string[]] )]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Alias('PSPath')]
        [Parameter(Position = 0, ValueFromPipelineByPropertyName)]
        [String]$Path = '.',

        # Regex patterns
        [Alias('Depth')]
        [Parameter()]
        [int]$MaxDepth = 9,

        [Alias('Type')]
        [ArgumentCompletions('.ps1', '.md', '.pq')]
        [Parameter(Mandatory, position = 1)]
        [string[]]$FileType
    )

    begin {

        Write-Warning 'next: use arg completer to populate'

    }
    process {
        # _get-ExtensionsList -Path $Path -Depth $MaxDepth
        # $arg_extList = $FileType | %{ ,@('-e', '.ps1') }
        # Import-Module Dev.Nin -Force
        # $sel ??= ExtLs -Select
        $arg_extList = $FileType | ForEach-Object { @('-e', $_ ) }
        $arg_extList | ConvertTo-Json
        $arg_default = @(
            '-d'
            $MaxDepth
            '-t'
            'f'
        )
        [string[]]$finalArgs_list = $arg_default + $arg_extList
        'invoke'
        $finalArgs_list | Join-String -sep ' ' -op 'invoke: fd '
        Invoke-NativeCommand 'fd' -ArgumentList $finalArgs_list

    }
    end {
    }
}
function Get-FileTypeExtension {
    <#
    .synopsis
        enumerate file extensions used. populates 'Find-FileType's argument completer
    .description

    .notes
        todo:
        - [ ]
    .link
        Dev.Nin\Find-FDNewestItem
    .link
        Find-FileType
    .example
        🐒> Get-FileTypeExtension
    .example
        🐒> Get-FileTypeExtension

            .code-workspace
            .csv
            .gif
            .gitattributes
            .gitignore
            .json
            .lnk
            .log
            .md
        
    .outputs
        string[]

    #>
    [Alias(
        'Completion->FileExtensionType'
    )]
    [OutputType( [string[]] )]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Alias('PSPath')]
        [Parameter(Position = 0, ValueFromPipelineByPropertyName)]
        [String]$Path = '.',

        # Regex patterns
        [Alias('Depth')]
        [Parameter()]
        [int]$MaxDepth = 3,

        # list and select choices
        [Parameter()][switch]$Select
    )

    begin {
        # Write-Warning 'currently relative CWD'
        # Write-Warning 'not working, or .gitignore etc are missing relative CWD'


    }
    process {
        [object[]]$listing = _get-ExtensionsList -Path $Path -Depth $MaxDepth
        if (! $Select) {
            $listing
            return
        }

        $listing | Fzf -m


    }
    end {
    }
}
