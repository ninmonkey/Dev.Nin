
$experimentToExport.function += @(
    'ConvertTo-MarkdownTable_dev.nin'
)
$experimentToExport.alias += @(
    'dev.Convert.MarkdownTable'
    'dev.Convert➝MdTable'
)

function ConvertTo-MarkdownTable_dev.nin {
    <#
    .synopsis
        exports any object as a markdown-table
    .description
        .
    .notes
    todo: push to separat lib: /marking
        future:
            - [ ] autosort some column by default
            - [ ] args to sort columns
    .example
        PS> .
    .link
        Dev.Nin\Str
    #>
    [Alias(
        'dev.Convert.MarkdownTable',
        'dev.Convert➝MdTable'
    )]
    [cmdletbinding()]
    param(
        # any object
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject,

        # Property list selection, and order
        # [alias(')]
        [Parameter(Mandatory)]
        [string[]]$Property,

        # extra config
        [Alias('Config')]
        [Parameter()]
        [hashtable]$Option
    )
    begin {
        $Config = @{
            A = 3
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})
        if ($Config) {
            # $Config =

        }
        $Config | format-dict | Write-Debug
        $Config | format-dict -Options @{} | wi
    }
    process {

    }
    end {
    }
}
