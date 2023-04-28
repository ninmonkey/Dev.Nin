#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'ConvertFrom-NativeGitStatus'
        'Peek-GitChanges'
    )
    $experimentToExport.alias += @(
        'Git->NativeGitStatus' # 'ConvertFrom-NativeGitStatus'
        'Git->PeekChanges' # 'Peek-GitChanges'
        # 'Peek->GitChanges' # 'Peek-GitChanges'
        # 'Git->PeekChanges' # 'Peek-GitChanges'

    )
}

enum GitStatusState {
    Untracked = 1
    U = 1
    # '??' = 1
    Modified = 2
    M = 2
    Deleted = 3
    D = 3
    Ignored = 4
    I = 4
    # '!!' = 4
}


# '??' = 1 # Can't easily declare an enum value named '??'

# todo: create argument transformation which always handles '??'
# and, auto-converts to the long-name versions
<#

        n the following table, these three classes are shown in separate sections, and these characters are used for X and Y fields for the first two sections that show tracked paths:

        ' ' = unmodified

        M = modified

        T = file type changed (regular file, symbolic link or submodule)

        A = added

        D = deleted

        R = renamed

        C = copied (if config option status.renames is set to "copies")

        U = updated but unmerged




        man git-status:

            X          Y     Meaning
            -------------------------------------------------
                [AMD]   not updated
            M        [ MTD]  updated in index
            T        [ MTD]  type changed in index
            A        [ MTD]  added to index
            D                deleted from index
            R        [ MTD]  renamed in index
            C        [ MTD]  copied in index
            [MTARC]          index and work tree matches
            [ MTARC]    M    work tree changed since index
            [ MTARC]    T    type changed in work tree since index
            [ MTARC]    D    deleted in work tree
                    R    renamed in work tree
                    C    copied in work tree
            -------------------------------------------------
            D           D    unmerged, both deleted
            A           U    unmerged, added by us
            U           D    unmerged, deleted by them
            U           A    unmerged, added by them
            D           U    unmerged, deleted by us
            A           A    unmerged, both added
            U           U    unmerged, both modified
            -------------------------------------------------
            ?           ?    untracked
            !           !    ignored
            -------------------------------------------------

    #>


function ConvertFrom-NativeGitStatus {
    <#
            .synopsis
                .parse 'git status' into structured information
            .notes
                .
            .example
                PS> Verb-Noun -Options @{ Title='Other' }
            #>
    # [outputtype( [string[]] )]
    [Alias('Git->NativeGitStatus')]
    [cmdletbinding()]
    param(
        # docs
        [Alias('PSPath', 'Path')]
        [parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [object]$BasePath,

        # extra options
        [Parameter()][hashtable]$Options
    )
    begin {
        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        [hashtable]$Config = @{

        }
        $Config = Join-Hashtable $Config ($Options ?? @{})
    }
    process {
        try {
            $RootDir = Get-Item -ea stop $BasePath
        } catch {
            $PSCmdlet.ThrowTerminatingError(
                <# errorRecord: #> $_)
            return
            # $psc
        }
        [object[]]$gitArgs = @(
            'status'
            '.'
            '--porcelain'
        )
        Push-Location -Path $RootDir -StackName 'devNinGit'
        $re = @{
            FileStatusRecord = @'
(?x)
            ^
            \s?
            (?<Status>\S+)
            \s+
            (?<RelativePath>.+)
            $
'@
        }
        Invoke-NativeCommand -CommandName 'git' -Args $gitArgs | ForEach-Object {
            if ($_ -match $re.FileStatusRecord ) {
                $Matches.Remove(0)
                [pscustomobject]$matches
            } else {
                Write-Warning "Failed regex on: '$_'"
            }
        } | ForEach-Object {
            $cur = $_
            $tryCoerce = if ($_.Status -eq '??') {
                # trying to set '??' to an enum is tricky, future arg transformation
                [GitStatusState]::Modified
            } else {
                [GitStatusState]$_.Status
            }
            $MaybePath = Join-Path $BasePath $_.RelativePath
            $maybeI = Get-Item $maybePath -ea SilentlyContinue
            $meta = @{
                'Status'                 = $tryCoerce
                'FullName'               = '..testing..'
                'MaybePath'              = $maybePath
                'LastWriteTime'          = ($maybeI)?.LastWriteTime ?? '[null]'
                'MaybeI'                 = $maybeI
                'Size'                   = ($MaybeI)?.Length | Format-FileSize
                'Length'                 = ($MaybeI)?.Length
                'DeltaLines'             = '...wip'
                'DeltaBytes'             = '...wip'
                'LastCommittedWriteTime' = '...'
            }
            [pscustomobject]$Meta
        }

        Pop-Location -StackName 'devNinGit'
    }
    end {
    }
}

function Peek-GitChanges {
    # finish me now
    [Alias('Git->PeekChanges')]
    param()
    throw @'
idea:
    - [ ]  display changed files in git
    - [ ]  pipe to fzf
    - [ ]  --preview to peek at the files
    - [ ] save selection of files
    - [ ] 'git add' those files
'@
}
