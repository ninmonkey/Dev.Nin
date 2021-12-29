# allows script to be ran alone, or, as module import
if (! $DebugInlineToggle ) {
    $experimentToExport.function += @(
        'Test-IsNotBlank'
    )
    $experimentToExport.alias += @(
        #     'TextProcessing📚.IsNotBlank'
        'Assert-IsNotBlank' # currently one function
    )
}


function Test-IsNotBlank {
    <#
    .synopsis
        asserts, todo: Maybe throw ann error too?
    .description
        Returns true if [string] is "truthy"
    .link
        Where-IsNotBlank
    .link
        [string]::IsNullOrWhiteSpace
    .outputs
        boolean
    #>
    [Alias('
        !Blank',
        'text->IsNotBlank',
        'Assert-IsNotBlank'
        # 'Validation🕵.IsNotBlank',
    )]
    [outputtype([bool])]
    [cmdletbinding()]
    param(
        # Input text line[s]
        [AllowEmptyString()]
        [AllowNull()]
        [AllowEmptyCollection()]
        [Parameter(
            Mandatory, Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string[]]$InputText,

        # throw exception?
        [switch]$AlwaysThrow
    )
    process {
        [bool]$IsBlank = [string]::IsNullOrWhiteSpace( $InputText )

        if ($AlwaysThrow -and $IsBlank) {
            Write-Error -ea stop -Message 'Value was blank' -TargetObject $InputText
            return $false
        }
        ! $IsBlank
        return
    }
}
