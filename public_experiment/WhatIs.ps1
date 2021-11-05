
if ( $experimentToExport ) {
    $experimentToExport.function += @(
        # 'Get-WhatObjectType' ?
        'What-TypeInfo'
    )
    $experimentToExport.alias += @(        
        'WhatIs'
        # 'Find-ObjectProperty'
        # 'New-Sketch'
    )
}
# }
    
    
function What-TypeInfo {
    <#
        .synopsis
            gives type info, in a longer form, it's for interactive use rather that WhatTypeIsObj
        .description
            .
        .example            
        .link
            # Dev.Nin\_enumerateProperty
        .link
            Dev.Nin\iProp
        .link
            Ninmonkey.Console\What-ParameterInfo
        #>
    [Alias('WhatIs')]
    [cmdletbinding()]
    param(
        # any object
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject    
        # # preset column order, and to out-griview
        # [alias('oGv')]
        # [parameter()]
        # [switch]$OutGridView
    )
    process {
        if ($null -eq $InputObject) {
            [pscustomobject]@{
                PSTypeName = 'nin.WhatIsInfo'
                Value      = $null 
            }
        }
        $obj = $InputObject
        $tinfo = ($InputObject)?.GetType()
        
        $meta = [ordered]@{
            PSTypeName = 'nin.WhatIsInfo'
            Value      = $InputObject
            Type       = $tinfo.Name | Format-TypeName -WithBrackets
            FullName   = $tinfo.FullName

            # PSTypeNames = $f.pstypenames | convert 'type' | Format-TypeName -Brackets | str csv
        }
        # Name = 
        # FullName

        # $meta | Format-Dict | wi
        [pscustomobject]$meta

        <#

maybe:

        $parsedInfo = [ordered]@{
            PSTypeName        = 'nin.ParsedTypeName' 

            duties:
                external code/type has 'nin.TypeInfo' and other inspection

                Format-TypeName:
                    least amount of info, and dependencies as possible. 
                    otherwise recursion 

            # RenderName        = # plus, here, it's recursive. visual, maybe not? $tinfo | Format-TypeName -WithBrackets 
            FullName          = $tinfo.FullName
            Name              = $tinfo.Name # would be format style / compute some
            NameSpace         = $tinfo.NameSpace
            OriginalReference = $tinfo
        }

        if ($PassThru) {
            [pscustomobject]$parsedInfo
            return
        }#>
         
    }
}

if (! $experimentToExport ) {

    hr
    $res = What-TypeInfo (Get-Item . ) -infa Continue
    hr
    $res | Format-List 
}