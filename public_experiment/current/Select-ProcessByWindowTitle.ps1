#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Select-ProcessByWindowTitle'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

function Select-ProcessByWindowTitle {
    <#
    .synopsis
        By the title name, get all of (get-process)'s stats on it
    .description
        By the title name, get all of (get-process)'s stats on it
    .example
          .
    .outputs
          object
    
    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # [Parameter(Mandatory, Position = 0)]
        # [string]$Name
    )
    
    begin {
     
    }
    process {
        # $Name | ForEach-Object {
        #     $NameList.Add( $_ )
        # }
        # $windowEnumeration = Get-OpenWindow
        Write-Warning 'temp: title is hard coded'

        # Get-OpenWindow * | Where-Object Title -Match 'code|insider|power'
        # 0        | ForEach-Object { Get-Process -PID $_.ProcessID }

        $actual = Get-OpenWindow * | Where-Object Title -Match 'code|insider|power'
        | ForEach-Object { Get-Process -PID $_.ProcessID }
        | Where-Object name -NotMatch 'firefox|explorer'

        $actual | Format-List Name, *Command*

        if ($false) {
            
            $selectedTitle = $windowEnumeration | ForEach-Object Title | Sort-Object
            | Out-Fzf -MultiSelect
    
            $windowEnumeration.Title | str ul
            | Write-Information
    
            $processId = $windowEnumeration
            | Where-Object { @($windowEnumeration.Title) -contains $_.title }
            $processId
        }       
    }
    end {
        
    }
}

if (! $experimentToExport) {
    # ...
    #     Select-ProcessByWindowTitle
}