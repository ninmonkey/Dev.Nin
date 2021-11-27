$Source = gi -ea stop 'C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin\public_experiment\cmd-code\__init__.ps1'

[object[]]$requiresInit = @()
ls -Directory | %{
   h1 $_  ; $cur = $_
   try {
       gi "$_/__init__.ps1" -ea stop
   } catch {
      $requiresInit += $cur
   }
}

$requiresInit | %{
  Copy-Item $source $_ -Whatif
}
