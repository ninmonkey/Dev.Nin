if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'What-ParameterInfo'
    )
    $experimentToExport.alias += @(        
        'What-Param'
    )
}

function What-ParameterInfo {
    <#
        .synopsis
            inspect parameters of functions
        .description
            .
        .example
            # Main Usage:
            
            PS> What-Param ls
            PS> What-Param ls -ByParameterSetName
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
            🐒> What-ParameterInfo mv -ByParameterSetName

                ParameterSet: __AllParameterSets

                    Name        Aliases Mandatory Position ValueFromPipeline ValueFromPipelineByPropertyName Type                                         IsDynamic ParameterSet      
                    ----        ------- --------- -------- ----------------- ------------------------------- ----                                         --------- ------------      
                    Credential              False Named                False                            True System.Management.Automation.PSCredential        False __AllParameterSets
                    Destination             False 1                    False                            True System.String                                    False __AllParameterSets
                    Exclude                 False Named                False                           False System.String[]                                  False __AllParameterSets
                    Filter                  False Named                False                           False System.String                                    False __AllParameterSets
                    Force                   False Named                False                           False System.Management.Automation.SwitchParameter     False __AllParameterSets
                    Include                 False Named                False                           False System.String[]                                  False __AllParameterSets
                    PassThru                False Named                False                           False System.Management.Automation.SwitchParameter     False __AllParameterSets

                ParameterSet: LiteralPath

                    Name        Aliases   Mandatory Position ValueFromPipeline ValueFromPipelineByPropertyName Type            IsDynamic ParameterSet
                    ----        -------   --------- -------- ----------------- ------------------------------- ----            --------- ------------
                    LiteralPath PSPath,LP      True Named                False                            True System.String[]     False LiteralPath

                ParameterSet: Path

                    Name Aliases Mandatory Position ValueFromPipeline ValueFromPipelineByPropertyName Type            IsDynamic ParameterSet
                    ---- ------- --------- -------- ----------------- ------------------------------- ----            --------- ------------
                    Path              True 0                     True                            True System.String[]     False Path
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
        [switch]$PassThru,

        # sort by sets
        [parameter()]
        [switch]$ByParameterSetName
    )
    begin {}
    process {
        
        $target = $InputObject | Resolve-CommandName
        $info = $target | PSScriptTools\Get-ParameterInfo       
        if ($ByParameterSetName) {
            $info = $info | Sort-Object 'ParameterSet', 'Name'
        }

        if ($PassThru) {
            $info            
            return 
        }
        $formatTableSplat = @{
            AutoSize = $true
            Property = '*'
        }
        if ($ByParameterSetName) {
            $formatTableSplat['GroupBy'] = 'ParameterSet'
        }

        $info | Format-Table @formatTableSplat 
        
    }
    end {}
       
}

if (! $experimentToExport ) {

    What-Param 'ls'
}