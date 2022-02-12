#Requires -Version 7.0
if ($experimentToExport) {
    $experimentToExport.function += @(
        'Invoke-PwshAsBase64'
    )
    $experimentToExport.alias += @(

    )
}


function Invoke-PwshAsBase64 {
    <#
    .synopsis
        invoke a Pwsh script block in a subprocess
    .description
        [Console]
            print output to console

        [NewWindow]
            spawns a visible new window

        [Hidden]
            Subprocess, not visible, doesn't print output
    .example
          PS>

            $x = { 0..4 | Join-String -sep '-' }
            & $x
            Invoke-PwshAsBase64 -Mode Console -ScriptBlock $x -InformationAction Continue -Verbose
    .outputs
          [string | None]

    #>
    [CmdletBinding(PositionalBinding)]
    param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [ScriptBlock]$ScriptBlock,



        # preset configurations: regular hidden mode, console when you want the results, and new window
        [Parameter()]
        [ValidateSet('Hidden', 'Console', 'NewWindow')]
        [string]$Mode = 'Console',

        ## overrides

        # requires prof?
        [Parameter()]
        [switch]$LoadUserProfile,

        # preset configurations: regular hidden mode, console when you want the results, and new window
        [Parameter()]
        [System.Diagnostics.ProcessWindowStyle]$WindowStyle # 'Normal', 'Hidden', 'Minimized', 'Maximized'

    )

    begin {

    }
    process {
        # return
        #I'm not sure whether my console utf8 takes over priory of probably c# default encoding?
        # $byte_str = [System.Text.Encoding]::UTF8.GetBytes($ScriptBlock.ToString())
        $byte_str = [System.Text.Encoding]::Unicode.GetBytes($ScriptBlock.ToString())
        $EncodedCommand = [Convert]::ToBase64String($byte_str)

        switch ($Mode) {

            'Hidden' {
                $startSplat = @{
                    ArgumentList    = @(
                        '-Nop',
                        '-encodedcommand', $EncodedCommand
                    )
                    WindowStyle     = 'Hidden'
                    FilePath        = 'pwsh'
                    LoadUserProfile = $false
                    NoNewWindow     = $false
                }
            }
            'Console' {
                $startSplat = @{
                    ArgumentList    = @(
                        '-Nop',
                        '-encodedcommand', $EncodedCommand
                    )
                    NoNewWindow     = $true
                    FilePath        = 'pwsh'
                    LoadUserProfile = $false
                }
            }
            'NewWindow' {
                $startSplat = @{
                    ArgumentList    = @(
                        '-Nop',
                        '-encodedcommand', $EncodedCommand
                    )
                    NoNewWindow     = $false
                    FilePath        = 'pwsh'
                    LoadUserProfile = $false
                }
            }

            default {
                throw "Unhandled mode: '$Mode'"
            }
        }
        $startSplat | format-dict | wi # before
        $startSplat.LoadUserProfile = $false

        if ( $PSBoundParameters.ContainsKey('WindowStyle') ) {
            $startSplat.WindowStyle = $WindowStyle
        }
        if ( $PSBoundParameters.ContainsKey('LoadUserProfile') ) {
            $startSplat.LoadUserProfile = $LoadUserProfile
        }
        # throw 'left off here, see if lack of params shows up in a psboundparams ttest'

        $PSBoundParameters | format-dict | Write-Information
        # overrides
        # if ( $WindowStyle ) {
        # if ( $null -ne $WindowStyle ) {
        # }
        # if ( $null -ne $LoadUserProfile) {
        #     $startSplat.LoadUserProfile = $LoadUserProfile


        # }

        # LoadUserProfile

        $startSplat | format-dict | wi # fafter

        Start-Process @startSplat

        $ScriptBlock | bat -l ps1 | Write-Information
        $EncodedCommand | Endcap Bold | Write-Information
    }

    # "'$PSCommandPath': Alarm_asBackground: Starts repeating timer, at 15m"
    # $finalCmd = 'alarm -relativeTimeString {0} -message ''{1}'' $repeat:{2}' -f @(
    #     '15m', 'bump', '$true'
    # )
    # New-BurntToastNotification -Text "Starting: '$finalCmd'"
    # Start-Process -path 'pwsh' -WindowStyle Hidden -ArgumentList @(
    #     '-Command'
    #     # "alarm -RelativeTimeString 1s -Message 'bump'"
    #     $finalCmd
    # )

    # # if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
    # $ScriptBlock | bat -l ps1 | Write-Information
    # # }

    end {
        $NameList
    }
}


if ( ! $experimentToExport) {
    # $cmd = { 0..4 | str ul }
    # Invoke-PwshAsBase64 $cmd -infa Continue -Debug -Verbose
    # err -Clear
    # Import-Module Dev.Nin -Force

    $x = { 0..4 | Join-String -sep '-' }
    & $x
    # Invoke-PwshAsBase64 -Mode Console -ScriptBlock $x -Debug -Verbose #-LoadUserProfile:$false
    #Invoke-PwshAsBase64 -Mode Console -ScriptBlock { 0..4 | str ul }

}
