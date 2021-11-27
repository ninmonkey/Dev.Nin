#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Out-Error'                
    )
    $experimentToExport.alias += @(
        'Pipe->Error'
    )
}

function Out-Error {
    <#
    .synopsis
        find newest, preview them in bat
    .description
        .
    .notes
        .
    .example
        PS> Out-Error 4
    .example
        PS> $Error[0..3] | Out-Error
        
    .example
        🐒>
    #>

    [Alias('Pipe->Error')]
    [CmdletBinding(PositionalBinding = $false, DefaultParameterSetName = 'FromInput')]
    param(
        [alias('Max')]
        [Parameter(
            Position = 0, ParameterSetName = 'FromNewest'
        )]
        [int]$Count = 3,

        # actuall errors
        [Parameter(
            ValueFromPipeline,
            ParameterSetName = 'FromInput'
        )]
        [object[]]$InputObject
    )
 
    begin {
    }
    end {
        if ($Count -gt 0) {

        }
        $template = @(            
            'Viewing: '
            '[{0}]' -f @(
                if ($Count) {
                    [math]::Min( $Count, $global:error.Count )
                } else {
                    'All'
                }
                
            )
            | Write-Color green

            ' of '
            '[{0}] ' -f @(
                $global:Error.count ?? 0
            )
            | Write-Color darkgreen
            ' errors'
        ) -join ''

        $template | wi 
             
        switch ($PSCmdlet.ParameterSetName) {
            'FromNewest' {
                # $getErrorSplat['Newest'] = $count
                $getErrorSplat['Newest'] = [math]::Min( $Count, $global:error.Count )
                "${fg:red}"
                Get-Error @getErrorSplat | less 
                break
            }
            'FromInput' {
                # $getErrorSplat['InputObject'] = $InputObject
                # Get-Error @getErrorSplat 
                $InputObject
                | Get-Error
                | Less
                break
            }
            
            default {
                throw "Unhandled ParameterSet: $($PSCmdlet.ParameterSetName)"
            }
        }  
    }    
}


if (! $experimentToExport) {
    # ...
 
}