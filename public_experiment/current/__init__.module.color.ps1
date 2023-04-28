#Requires -Version 7

# throw "Should Be '$PSCommandPath'"

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'New-ColorFromTemplate'
    )
    $experimentToExport.alias += @(
        'cDump' #New-ColorFromTemplate
        'Color->Template'

    )

}

# C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin\public_experiment\current\module_GenerateColor\__init__.ps1
# . (Get-Item (Join-Path $PSSCriptRoot 'module_GenerateColor/colors_gray.ps1'))
#     . (Get-Item (Join-Path $PSSCriptRoot 'module_GenerateColor/colors_colorspace.ps1'))

Write-Warning "validate color->Colorspace is exporting. old src: '$PSCommandPath'"


# return
if ($false -and 'old obsolete paths') {
    'colors_gray', 'colors_colorspaces' | ForEach-Object {
        $curScript = $_
        Write-Warning "Iter: $_"
        $fullpath = (Join-Path $PSSCriptRoot "module_GenerateColor/${curScript}.ps1")
        Write-Warning "fullpath: '$fullpath'"
        if (! (Test-Path $fullpath)) {
            Write-Error "Missing file?: '$fullpath'"

            Write-Warning ". `$fullpath: '$fullpath'"
            . (Get-Item $fullPath)
        }
    }
}

# # 'colors_gray', 'colors_colorspaces'
# $subModulePath = Join-Path $PSSCriptRoot 'module_GenerateColor'
# throW "loadSub '$PSCommandPath'"

# Get-ChildItem $subModulePath -Recurse:$false *.ps1 | ForEach-Object {

# } ?{
#     $_.Name -notmatch 'tests.ps1$'
# } | sort '__init__'
# | ForEach-Object {
#     $curScript = $_

#     $fullpath = (Join-Path $PSSCriptRoot "module_GenerateColor/${curScript}.ps1")
#     if (! (Test-Path $fullpath)) {
#         Write-Error "Missing file: '$fullpath'"
#     }
#     . (Get-Item $fullPath)
# }



# function __importSubdirColors {
#     # return # test -nop
#     # 'colors_gray', 'colors_colorspaces' | ForEach-Object {
#     foreach ($_ in 'colors_gray', 'colors_colorspaces') {
#         $curScript = $_
#         $fullpath = (Join-Path $PSSCriptRoot "module_GenerateColor/${curScript}.ps1")
#         if (! (Test-Path $fullpath)) {
#             Write-Error "Missing file: '$fullpath'"
#         }
#         . (Get-Item $fullPath)

#     }
#     # throw "didn't dotsource into the current env because of For3each?"
#     # foreach($file in '')
#     # . (Get-Item (Join-Path $PSSCriptRoot 'module_GenerateColor/colors_gray.ps1'))
#     # . (Get-Item (Join-Path $PSSCriptRoot 'module_GenerateColor/colors_colorspace.ps1'))
# }


# if (! $experimentToExport) {
#     # ...
# } else {
#     __importSubdirColors
# }

# if ( $experimentToExport ) {
#     Write-Warning '     importing...'
#     __importSubdirColors
# } else {
#     Write-Warning '     [error] failed !'

# }
