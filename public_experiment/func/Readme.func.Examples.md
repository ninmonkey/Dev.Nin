# example 

```ps1
$p = 'C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\bar\bat'
$p | % tostring
hr

$P | _fmt_FilepathWithoutUsernamePrefix
$P | _fmt_FilepathWithoutUsernamePrefix -ReplaceWith 'C => ' | _fmt_FilepathForwardSlash
$P | _fmt_FilepathWithoutUsernamePrefix -ReplaceWith 'C: => ' | _fmt_FilepathForwardSlash
$P | _fmt_FilepathWithoutUsernamePrefix -ReplaceWith '🐒' | _fmt_FilepathForwardSlash '->'

```
outputs

```ps1
C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\bar\bat
-----------------------------------
^\Powershell\bar\bat
C => /Powershell/bar/bat
C: => /Powershell/bar/bat
🐒->Powershell->bar->bat
```
