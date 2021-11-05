if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'What-ParameterInfo'
    )
    $experimentToExport.alias += @(        
        'What-Param'
    )
}
# }
# gcm x | Get-ParameterInfo | ft -AutoSize *
    
function What-ParameterInfo {
    <#
        .synopsis
            inspect parameters of functions
        .description
            .
        .example
                🐒> What-ParameterInfo mv -PassThru | Select-Object Name, Type

            
                Name        Type
                ----        ----
                Path        System.String[]
                LiteralPath System.String[]
                Destination System.String
                Force       System.Management.Automation.SwitchParameter
                Filter      System.String
                Include     System.String[]
                Exclude     System.String[]
                PassThru    System.Management.Automation.SwitchParameter
                Credential  System.Management.Automation.PSCredential
        .example
            PS> What-Param 'ls'
            PS> 'ls', 'mv' | What-Param
            PS> gi function:'x' | What-Param -PassThru | ft *
        .link
            System.Reflection.ParameterInfo
        .link
            # Dev.Nin\_enumerateProperty
        .link
            Ninmonkey.Console\Resolve-CommandName
        .link
            Ninmonkey.Console\What-TypeInfo
        .link
            PSScriptTools\Get-ParameterInfo
        #>
    [Alias('What-Param')]
    [cmdletbinding()]
    param(
        # any object
        [Alias('Name', 'CommandName')]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string[]]$InputObject,
        # # preset column order, and to out-griview
        # [alias('oGv')]
        
        # return as objects
        [parameter()]
        [switch]$PassThru
    )
    begin {}
    process {
        $target = $InputObject | Resolve-CommandName
        $info = $target | PSScriptTools\Get-ParameterInfo       
        if ($PassThru) {
            $info            
            return 
        }
        $info | Format-Table * -AutoSize | Write-Information
    }
    end {}
       
}

if (! $experimentToExport ) {

    # hr
    # $res = What-TypeInfo (Get-Item . ) -infa Continue
    # hr
    # $res | Format-List 
    What-Param 'ls'
    What-Param 'prompt'
}