#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_ConvertFrom-EventTraceFilename' # ''
    )
    $experimentToExport.alias += @(
        # ''
    )
}

function _ConvertFrom-EventTraceFilename {
    <#
    .synopsis
        Stuff
    .description
       .
    .example
          .
    .notes

    see more:
        - <https://en.wikipedia.org/wiki/Universally_unique_identifier#Format>
        - <https://en.wikipedia.org/wiki/Windows_Registry>
        - <https://en.wikipedia.org/wiki/Uniform_Resource_Name>

        _ isn't valid, but \w makes the regex shorter
    #>
    [CmdletBinding()]
    param(
        # [Alias('Name')]
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Name
    )

    begin {
        # see: also:
        $RegexName = @'
(?x)
(?<Name> #new
.*

)
_
(?<FullId>    #<Guid>


  (?<SomeConst>
   \w+
\-
     .{4}
  )
\-
  (?<TestNumber>
     .{4}
  )
\-
\w{4}
\-
[\w]{12}
)
\.evtx$
'@
    }
    process {
        if ($Name -match $RegexName) {
            $matches.Remove(0)
            $matches['OriginalName'] = $Name
            return [pscustomobject]$matches
        }
        Write-Error "Regex failed on item: '$Name' with regex: '$RegexName'" -Category 'InvalidData'

    }
    end {
    }
}


if (! $experimentToExport) {

    'Application_466F3E48-1EEA-0000-49F3-2947EA1ED801.evtx'
    | _ConvertFrom-EventTraceFilename

    if ($false) {
        'Application_466F3E48-1EEA-0000-49F3-2947EA1ED801.evtx' -match $RegexName
        $RegexName[30..40] | Uni->RuneInfo
        | Add-IndexProperty -Offset 30
        | Format-Table Id, CodeHex, UniCategory, Render
    }
    # ...

}
