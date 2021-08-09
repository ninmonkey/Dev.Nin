
$experimentToExport.function += @(
    '_Find-NativeCommand'
)
$experimentToExport.alias += @(

)


function _Find-NativeCommand {
    <#
  .synopsis
        Find Native commands, sorted by LastWriteTime
  .example
       🐒> _Find-NativeCommand | select -First 20

            CommandType     Name                                               Version    Source
            -----------     ----                                               -------    ------
            Application     code-insiders.cmd                                  0.0.0.0    C:\Users\cppmo_000\AppData\Loca…
            Application     cargo-fmt.exe                                      0.0.0.0    C:\Users\cppmo_000\.cargo\bin\c…
            Application     cargo-miri.exe                                     0.0.0.0    C:\Users\cppmo_000\.cargo\bin\c…
            Application     clippy-driver.exe                                  0.0.0.0    C:\Users\cppmo_000\.cargo\bin\c…
            Application     rls.exe                                            0.0.0.0    C:\Users\cppmo_000\.cargo\bin\r…
            Application     rustup.exe                                         0.0.0.0    C:\Users\cppmo_000\.cargo\bin\r…
            Application     cargo-clippy.exe                                   0.0.0.0    C:\Users\cppmo_000\.cargo\bin\c…
  #>

    [cmdletbinding()]
    param(
    )
    process {

        $sortSplat = @{
            # Top        = 10
            Descending = $true
            Property   = { (Get-Item -LiteralPath $_.Source).LastWriteTime }
        }

        Get-Command -CommandType Application | Sort-Object @sortSplat
    }
}
