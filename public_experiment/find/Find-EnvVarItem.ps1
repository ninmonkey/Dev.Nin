$experimentToExport.function += 'Find-EnvVarItem'
$experimentToExport.alias += 'findEnvPattern'

function Find-EnvVarItem {
    <#
    .synopsis
        find related Env vars by searching keys or values with a regex or literal
    .description
    .example
        🐒> _findEnvPattern dotfile

            Nin_Dotfiles                   C:\Users\cppmo_000\Documents\2021\dotfiles_git

        🐒> _findEnvPattern dotfile -PassThru

            Name                           Value
            ----                           -----
            Nin_Dotfiles                   C:\Users\cppmo_000\Documents\2021\dotfiles_git

    .example
        🐒> _findEnvPattern "$Env:USERPROFILE" -PassThru | % Name

        APPDATA
        GIT_ASKPASS
        LOCALAPPDATA
        Nin_Dotfiles
        Nin_Home
        Nin_PSModulePath
        OneDrive
        OneDriveConsumer
        Path
        PSModulePath
        USERPROFILE
        VSCODE_GIT_ASKPASS_MAIN
        VSCODE_GIT_ASKPASS_NODE

    .example
        🐒> findEnvPattern $Env:USERPROFILE -PassThru

        Name                           Value
        ----                           -----
        APPDATA                        C:\Users\cppmo_000\AppData\Roaming
        LOCALAPPDATA                   C:\Users\cppmo_000\AppData\Local
        Nin_Dotfiles                   C:\Users\cppmo_000\Documents\2021\dotfiles_git
        Nin_Home                       C:\Users\cppmo_000\Documents\2021
        Nin_PSModulePath               C:\Users\cppmo_000\Documents\2021\Powershell\My_Github
        NinNow                         C:\Users\cppmo_000\Documents\2021
        OneDrive                       C:\Users\cppmo_000\SkyDrive
        OneDriveConsumer               C:\Users\cppmo_000\SkyDrive
        Path                           C:\Program Files\PowerShell\7;C:\Program Files\Alacritty\;C
        PSModulePath                   C:\Users\cppmo_000\Documents\2021\Powershell\My_Github;C:\U
        USERPROFILE                    C:\Users\cppmo_000

    .outputs


    #>
    [alias('findEnvPattern')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Pattern as a literal, unless -Regex is specified
        [Parameter(Mandatory, Position = 0)]
        [string[]]$Text,

        # todo: clean: Better to use -Text and -Pattern args for regex/text instead of a switch to toggle
        [Alias('Regex')]
        [Parameter()][switch]$AsRegex,

        # otherwise also colorize match
        [Parameter()][switch]$PassThru

    )

    begin {}
    process {
        # todo: clean: Use "Join-Regex -pattern p -lit l"
        Label 'As Regex?' ($true -eq $AsRegex)
        $regexLiteral = $Text
        | Join-String -sep '|' -p { '({0})' -f [regex]::Escape( $_) }

        $regexOr = $Text
        | Join-String -sep '|' -p { '({0})' -f $_ }

        $FinalRegex = ($AsRegex) ? $Text : $regexLiteral

        Write-Debug "`$Regex = $FinalRegex"
        $regexor

        $query = Get-ChildItem env: | Where-Object Value -Match $FinalRegex
        if ($PassThru) {
            $query
            return
        }

        # Todo: Refactor using Write-HighightConsoleText
        $query | rg -i $FinalRegex
        # todo: clean: add STDIN to 'Invoke-NativeCommand'
        # $query | Invoke-NativeCommand -CommandName 'rg' -ArgumentList @(
        #     '-i'
        #     $FinalRegex
        # )
    }
    end {}
}
