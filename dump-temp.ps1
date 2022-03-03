
$SpecialStr = @{
    'reset' = '[reset]'
    'undo'  = '[undo] nyi state push pop'
}

while ($curDepth -le $MaxDepth) {
    $curDepth++

    $Destination = @(
        @(
            $SpecialStr.reset
            fd -t d -t d
        ) | fzf | Select-Object -First 1 | Get-Item
    )
    # $Destination = @(
    #     # '[reset]'
    #     # '[undo]'
    #     $Destination
    # )

    $Mode =

    switch ($Mode) {

    }

    Get-Location | ConvertTo-RelativePath -BasePath $orginalRoot
    | write-color 'orange'
    hr
