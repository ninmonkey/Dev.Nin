using namespace Management.Automation

$experimentToExport.function += @(
    'Join-NinString'
)
# $experimentToExport.alias += @(
#     'joinStr'
# )
function Join-NinString {
    <#
    .synopsis
        simplify 'inline grepping'
    .description
       This is for cases where you had to use

       ... | ?{ $_ -Join  $regex } | ...
    .notes
        should have the option to silently pipe nulls. ( Get-Content split enumerates some null values on extra newlines)

        todo:
            - [ ] Should it write-error when input is not a string?
    .example
          .
    .outputs
          [string]

    #>
    [alias('JoinStr')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Parametertype: Use a [object] so it can write warnings when a non-string type maybe accidentally was used?
        #   array or not? that can change how patterns will match
        #   when there's only access to one line
        <# (copied 'Format-ControlChar')
        format unicode strings, making them safe.
            Null is allowed for the user's conveinence.
            allowing null makes it easier for the user to pipe, like:
            'gc' without -raw or '-split' on newlines
        #>
        [alias('Text', 'Lines')]
        [Parameter(Mandatory, ValueFromPipeline)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [string[]]$InputText,

        # Text
        [Alias('Separator', 'Text')]
        [Parameter(Mandatory, Position = 0)]
        [string]$JoinText = "`n"
    )
    begin {
        $textList = [list[string]]::new()
        Write-Warning 'NYI'
    }
    process {
        $InputObject | ForEach-Object {
            $textList.Add( $_ )
        }
    }
    end {

    }
}
