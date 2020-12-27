## one line from `code --status`
```powershell
# a single line of the 'code --status log'
@'
"C:\Program Files\PowerShell\7\pwsh.exe" -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Import-Module 'c:\Users\cppmo_000\.vscode\extensions\ms-vscode.powershell-preview-2020.9.0\modules\PowerShellEditorServices\PowerShellEditorServices.psd1'; Start-EditorServices -HostName 'Visual Studio Code Host' -HostProfileId 'Microsoft.VSCode' -HostVersion '2020.9.0' -AdditionalModules @('PowerShellEditorServices.VSCode') -BundledModulesPath 'c:\Users\cppmo_000\.vscode\extensions\ms-vscode.powershell-preview-2020.9.0\modules' -EnableConsoleRepl -StartupBanner '=====> PowerShell Preview Integrated Console v2020.9.0 <=====
'@ -split '\s+\-' -join "`n-"
```

### transformed

```powershell
"C:\Program Files\PowerShell\7\pwsh.exe"
-NoProfile
-NonInteractive
-ExecutionPolicy Bypass
-Command "Import-Module 'c:\Users\cppmo_000\.vscode\extensions\ms-vscode.powershell-preview-2020.9.0\modules\PowerShellEditorServices\PowerShellEditorServices.psd1'; Start-EditorServices
-HostName 'Visual Studio Code Host'
-HostProfileId 'Microsoft.VSCode'
-HostVersion '2020.9.0'
-AdditionalModules @('PowerShellEditorServices.VSCode')
-BundledModulesPath 'c:\Users\cppmo_000\.vscode\extensions\ms-vscode.powershell-preview-2020.9.0\modules'
-EnableConsoleRepl
-StartupBanner '=====> PowerShell Preview Integrated Console v2020.9.0 <=====
```

## example: `code --status`

```log

Version:          Code 1.52.1 (ea3859d4ba2f3e577a159bc91e3074c5d85c0523, 2020-12-16T16:34:46.910Z)
OS Version:       Windows_NT x64 10.0.19041
CPUs:             Intel(R) Core(TM) i7-8700K CPU @ 3.70GHz (12 x 3696)
Memory (System):  15.93GB (5.73GB free)
VM:               0%
Screen Reader:    no
Process Argv:     --crash-reporter-id f3df5559-4f8f-40f1-a82d-226b60a68c16
GPU Status:       2d_canvas:                  enabled
                  flash_3d:                   enabled
                  flash_stage3d:              enabled
                  flash_stage3d_baseline:     enabled
                  gpu_compositing:            enabled
                  multiple_raster_threads:    enabled_on
                  oop_rasterization:          disabled_off
                  opengl:                     enabled_on
                  protected_video_decode:     unavailable_off
                  rasterization:              enabled
                  skia_renderer:              disabled_off_ok
                  video_decode:               enabled
                  vulkan:                     disabled_off
                  webgl:                      enabled
                  webgl2:                     enabled

CPU %	Mem MB	   PID	Process
    1	   115	 25280	code main
    0	    27	  3204	   crashpad-handler
    0	   190	  9688	   window (initial powerquery fetch - from tabular (Workspace) Γü₧ initial powerquery fetch - from tabular.code-workspace Γü₧ powerquery fetch from Tabular)
    0	     6	 19948	     console-window-host (Windows internal process)
    0	    67	 23544	     searchService
    0	   122	 24752	     "C:\Program Files\PowerShell\7\pwsh.exe"
    0	   142	 27388	     extensionHost
    0	    94	  4176	       "C:\Program Files\Microsoft VS Code\Code.exe" "c:\Program Files\Microsoft VS Code\resources\app\extensions\json-language-features\server\dist\node\jsonServerMain" --node-ipc --clientProcessId=27388
    0	     4	 19000	       cmd /s /c "c:\Users\cppmo_000\.vscode\extensions\ms-dotnettools.csharp-1.23.8\.omnisharp\1.37.5\OmniSharp.exe -s "c:\Users\cppmo_000\Documents\2020\Power BI\my_github\Ninmonkey.tabular-editor_experiments\initial powerquery fetch" --hostPID 27388 DotNet:enablePackageRestore=false --encoding utf-8 --loglevel information --plugin c:\Users\cppmo_000\.vscode\extensions\ms-dotnettools.csharp-1.23.8\.razor\OmniSharpPlugin\Microsoft.AspNetCore.Razor.OmniSharpPlugin.dll FileOptions:SystemExcludeSearchPatterns:0=**/.git FileOptions:SystemExcludeSearchPatterns:1=**/.svn FileOptions:SystemExcludeSearchPatterns:2=**/.hg FileOptions:SystemExcludeSearchPatterns:3=**/CVS FileOptions:SystemExcludeSearchPatterns:4=**/.DS_Store FileOptions:SystemExcludeSearchPatterns:5=*.exe FileOptions:SystemExcludeSearchPatterns:6=*.lnk FileOptions:SystemExcludeSearchPatterns:7=*.pbix FileOptions:SystemExcludeSearchPatterns:8=*.zip FileOptions:SystemExcludeSearchPatterns:9=**/__pycache__ FileOptions:SystemExcludeSearchPatterns:10=**/.mypy_cache FileOptions:SystemExcludeSearchPatterns:11=**/*.py[co] FileOptions:SystemExcludeSearchPatterns:12=**/node_modules FileOptions:SystemExcludeSearchPatterns:13=**/venv FormattingOptions:EnableEditorConfigSupport=true RoslynExtensionsOptions:EnableDecompilationSupport=true formattingOptions:useTabs=false formattingOptions:tabSize=4 formattingOptions:indentationSize=4"
    0	     7	  5056	         console-window-host (Windows internal process)
    0	   165	  5912	         c:\Users\cppmo_000\.vscode\extensions\ms-dotnettools.csharp-1.23.8\.omnisharp\1.37.5\OmniSharp.exe  -s "c:\Users\cppmo_000\Documents\2020\Power BI\my_github\Ninmonkey.tabular-editor_experiments\initial powerquery fetch" --hostPID 27388 DotNet:enablePackageRestore=false --encoding utf-8 --loglevel information --plugin c:\Users\cppmo_000\.vscode\extensions\ms-dotnettools.csharp-1.23.8\.razor\OmniSharpPlugin\Microsoft.AspNetCore.Razor.OmniSharpPlugin.dll FileOptions:SystemExcludeSearchPatterns:0=**/.git FileOptions:SystemExcludeSearchPatterns:1=**/.svn FileOptions:SystemExcludeSearchPatterns:2=**/.hg FileOptions:SystemExcludeSearchPatterns:3=**/CVS FileOptions:SystemExcludeSearchPatterns:4=**/.DS_Store FileOptions:SystemExcludeSearchPatterns:5=*.exe FileOptions:SystemExcludeSearchPatterns:6=*.lnk FileOptions:SystemExcludeSearchPatterns:7=*.pbix FileOptions:SystemExcludeSearchPatterns:8=*.zip FileOptions:SystemExcludeSearchPatterns:9=**/__pycache__ FileOptions:SystemExcludeSearchPatterns:10=**/.mypy_cache FileOptions:SystemExcludeSearchPatterns:11=**/*.py[co] FileOptions:SystemExcludeSearchPatterns:12=**/node_modules FileOptions:SystemExcludeSearchPatterns:13=**/venv FormattingOptions:EnableEditorConfigSupport=true RoslynExtensionsOptions:EnableDecompilationSupport=true formattingOptions:useTabs=false formattingOptions:tabSize=4 formattingOptions:indentationSize=4
    0	    70	 27588	     watcherService
    2	    98	 12088	   shared-process
    0	    40	 16256	   utility
    0	   178	 19192	   window (initial powerquery fetch Γü₧ 2020-12-12 -- extract powerquery from model -- iter2.csx)
    0	    66	 12684	     searchService
    0	   133	 14976	     extensionHost
    0	     4	 18716	       cmd /s /c "c:\Users\cppmo_000\.vscode\extensions\ms-dotnettools.csharp-1.23.8\.omnisharp\1.37.5\OmniSharp.exe -s "c:\Users\cppmo_000\Documents\2020\Power BI\my_github\Ninmonkey.tabular-editor_experiments\initial powerquery fetch" --hostPID 14976 DotNet:enablePackageRestore=false --encoding utf-8 --loglevel information --plugin c:\Users\cppmo_000\.vscode\extensions\ms-dotnettools.csharp-1.23.8\.razor\OmniSharpPlugin\Microsoft.AspNetCore.Razor.OmniSharpPlugin.dll FileOptions:SystemExcludeSearchPatterns:0=**/.git FileOptions:SystemExcludeSearchPatterns:1=**/.svn FileOptions:SystemExcludeSearchPatterns:2=**/.hg FileOptions:SystemExcludeSearchPatterns:3=**/CVS FileOptions:SystemExcludeSearchPatterns:4=**/.DS_Store FileOptions:SystemExcludeSearchPatterns:5=*.exe FileOptions:SystemExcludeSearchPatterns:6=*.lnk FileOptions:SystemExcludeSearchPatterns:7=*.pbix FileOptions:SystemExcludeSearchPatterns:8=*.zip FileOptions:SystemExcludeSearchPatterns:9=**/__pycache__ FileOptions:SystemExcludeSearchPatterns:10=**/.mypy_cache FileOptions:SystemExcludeSearchPatterns:11=**/*.py[co] FileOptions:SystemExcludeSearchPatterns:12=**/node_modules FileOptions:SystemExcludeSearchPatterns:13=**/venv FormattingOptions:EnableEditorConfigSupport=true RoslynExtensionsOptions:EnableDecompilationSupport=true formattingOptions:useTabs=false formattingOptions:tabSize=4 formattingOptions:indentationSize=4"
    0	   177	  3152	         c:\Users\cppmo_000\.vscode\extensions\ms-dotnettools.csharp-1.23.8\.omnisharp\1.37.5\OmniSharp.exe  -s "c:\Users\cppmo_000\Documents\2020\Power BI\my_github\Ninmonkey.tabular-editor_experiments\initial powerquery fetch" --hostPID 14976 DotNet:enablePackageRestore=false --encoding utf-8 --loglevel information --plugin c:\Users\cppmo_000\.vscode\extensions\ms-dotnettools.csharp-1.23.8\.razor\OmniSharpPlugin\Microsoft.AspNetCore.Razor.OmniSharpPlugin.dll FileOptions:SystemExcludeSearchPatterns:0=**/.git FileOptions:SystemExcludeSearchPatterns:1=**/.svn FileOptions:SystemExcludeSearchPatterns:2=**/.hg FileOptions:SystemExcludeSearchPatterns:3=**/CVS FileOptions:SystemExcludeSearchPatterns:4=**/.DS_Store FileOptions:SystemExcludeSearchPatterns:5=*.exe FileOptions:SystemExcludeSearchPatterns:6=*.lnk FileOptions:SystemExcludeSearchPatterns:7=*.pbix FileOptions:SystemExcludeSearchPatterns:8=*.zip FileOptions:SystemExcludeSearchPatterns:9=**/__pycache__ FileOptions:SystemExcludeSearchPatterns:10=**/.mypy_cache FileOptions:SystemExcludeSearchPatterns:11=**/*.py[co] FileOptions:SystemExcludeSearchPatterns:12=**/node_modules FileOptions:SystemExcludeSearchPatterns:13=**/venv FormattingOptions:EnableEditorConfigSupport=true RoslynExtensionsOptions:EnableDecompilationSupport=true formattingOptions:useTabs=false formattingOptions:tabSize=4 formattingOptions:indentationSize=4
    0	     7	 14248	         console-window-host (Windows internal process)
    0	   148	 15264	     "C:\Program Files\PowerShell\7\pwsh.exe" -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Import-Module 'c:\Users\cppmo_000\.vscode\extensions\ms-vscode.powershell-preview-2020.9.0\modules\PowerShellEditorServices\PowerShellEditorServices.psd1'; Start-EditorServices -HostName 'Visual Studio Code Host' -HostProfileId 'Microsoft.VSCode' -HostVersion '2020.9.0' -AdditionalModules @('PowerShellEditorServices.VSCode') -BundledModulesPath 'c:\Users\cppmo_000\.vscode\extensions\ms-vscode.powershell-preview-2020.9.0\modules' -EnableConsoleRepl -StartupBanner '=====> PowerShell Preview Integrated Console v2020.9.0 <=====
' -LogLevel 'Diagnostic' -LogPath 'c:\Users\cppmo_000\.vscode\extensions\ms-vscode.powershell-preview-2020.9.0\logs\1609012341-2efd3eac-51e5-46cc-b171-28d2ed7000ca1609012177203\EditorServices.log' -SessionDetailsPath 'c:\Users\cppmo_000\.vscode\extensions\ms-vscode.powershell-preview-2020.9.0\sessions\PSES-VSCode-25280-788678' -FeatureFlags @() "
    0	     6	 16756	     console-window-host (Windows internal process)
    0	     6	 18528	     console-window-host (Windows internal process)
    0	   127	 23420	     "C:\Program Files\PowerShell\7\pwsh.exe"
    0	    12	 26872	     watcherService 
    0	     7	 12624	       console-window-host (Windows internal process)
    0	    86	 19792	   window (Process Explorer)
    2	   131	 22712	   gpu-process
    9	   181	 26976	   window (Ninmonkey.Console - module (Workspace) Γü₧ Write-ConsoleLabel.ps1 Γü₧ public)
    0	   136	  7952	     extensionHost
    0	     6	 10048	     console-window-host (Windows internal process)
    0	    12	 14732	     watcherService 
    0	     7	 14820	       console-window-host (Windows internal process)
    0	   161	 16584	     "C:\Program Files\PowerShell\7\pwsh.exe" -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Import-Module 'c:\Users\cppmo_000\.vscode\extensions\ms-vscode.powershell-preview-2020.9.0\modules\PowerShellEditorServices\PowerShellEditorServices.psd1'; Start-EditorServices -HostName 'Visual Studio Code Host' -HostProfileId 'Microsoft.VSCode' -HostVersion '2020.9.0' -AdditionalModules @('PowerShellEditorServices.VSCode') -BundledModulesPath 'c:\Users\cppmo_000\.vscode\extensions\ms-vscode.powershell-preview-2020.9.0\modules' -EnableConsoleRepl -StartupBanner '=====> PowerShell Preview Integrated Console v2020.9.0 <=====
' -LogLevel 'Diagnostic' -LogPath 'c:\Users\cppmo_000\.vscode\extensions\ms-vscode.powershell-preview-2020.9.0\logs\1609012352-7028f068-150b-43fd-b861-dbcc38c877a31609012349768\EditorServices.log' -SessionDetailsPath 'c:\Users\cppmo_000\.vscode\extensions\ms-vscode.powershell-preview-2020.9.0\sessions\PSES-VSCode-25280-395973' -FeatureFlags @() "
    0	     6	 25912	     console-window-host (Windows internal process)
    0	   127	 27100	     "C:\Program Files\PowerShell\7\pwsh.exe"
    0	    69	 27540	     searchService

Workspace Stats: 
|  Window (Ninmonkey.Console - module (Workspace) Γü₧ Write-ConsoleLabel.ps1 Γü₧ public)
|  Window (initial powerquery fetch Γü₧ 2020-12-12 -- extract powerquery from model -- iter2.csx)
|  Window (initial powerquery fetch - from tabular (Workspace) Γü₧ initial powerquery fetch - from tabular.code-workspace Γü₧ powerquery fetch from Tabular)
|    Folder (initial powerquery fetch): 7 files
|      File types: csx(2) json(1) code-workspace(1) md(1)
|      Conf files: settings.json(1)
|    Folder (initial powerquery fetch): 7 files
|      File types: csx(2) json(1) code-workspace(1) md(1)
|      Conf files: settings.json(1)
|    Folder (tabular-editor-scripts): 15 files
|      File types: csx(9) gitignore(1) md(1)
|      Conf files:
|    Folder (Ninmonkey.Console): 118 files
|      File types: ps1(86) md(3) json(2) ps1xml(2) gitattributes(1)
|                  gitignore(1) yml(1) png(1) code-workspace(1) psd1(1)
|      Conf files: launch.json(1)
|      Launch Configs: PowerShell(2)
|    Folder (TabularEditor): 748 files
|      File types: cs(440) png(60) resx(42) md(30) bmp(8) csproj(7) config(7)
|                  txt(6) bim(6) gif(4)
|      Conf files: csproj(7) sln(1)

```