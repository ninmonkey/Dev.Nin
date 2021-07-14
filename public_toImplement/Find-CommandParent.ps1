
function Find-CommandParent {
    <#
    .synopsis
        Find 1 or more parents of a command name (as a pattern)
    .description
        .
    .example
        PS>
Find-CommandParent -TextLiteral 'join-string'
    .notes
        .
    #>
    param (
        [Parameter(Position = 0, Mandatory)]
        [string]$TextLiteral
        # Parameter pattern. ( in the future. currently it's an exact match)
        # [Parameter(Position = 0, Mandatory)]
        # [string]$Pattern
    )
    begin {
        $AllModules = Get-Module
    }
    process {
        $AllModules | Where-Object {
            $isActive = $false;
            foreach ($item in $AllModules.ExportedCommands.GetEnumerator().keys) {
                # foreach ($item in $AllModules.ExportedCommands.GetEnumerator()) {
                if ($TextLiteral -match $item.key) {
                    $isActive = $true;
                    break;
                }   #{ getenumerator | % Key | rg -i 'join-string'
            }
            return $isActive
        }
    }
    end {}
}
