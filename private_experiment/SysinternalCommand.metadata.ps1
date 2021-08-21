# & {
$Metadata = @(
    @{
        Name           = 'Autoruns'
        Uri            = 'https://docs.microsoft.com/en-us/sysinternals/downloads/autoruns'
        Description    = 'View and edit startups defined in the registry, files, etc.'
        # HelpCommand    = Invoke-NativeCommand 'Autorunsc64' -ArgumentList @('--help')
        Help           = @(
            'https://www.howtogeek.com/school/sysinternals-pro/lesson6/'
        )
        ExampleCommand = @(
        )

    }
    @{
        Name        = 'VMMap'
        Uri         = 'https://docs.microsoft.com/en-us/sysinternals/downloads/vmmap'
        Description = 'RAM . Process virtual and physical memory analysis utility'
    }
    @{
        Name           = 'Streams'
        Uri            = 'https://docs.microsoft.com/en-us/sysinternals/downloads/streams'
        # HelpCommand    = Invoke-NativeCommand 'streams64' -ArgumentList @('-nobanner', '/?')
        Help           = @(
            'https://www.howtogeek.com/school/sysinternals-pro/lesson6/'
        )
        ExampleCommand = @(
        )

    }
    @{
        Name           = 'Handle'
        Uri            = 'https://docs.microsoft.com/en-us/sysinternals/downloads/handle'
        # HelpCommand    = Invoke-NativeCommand 'handle' -ArgumentList @('--help')
        ExampleCommand = @(
            # 'handle -p code'
            # 'handle windows\system'
        )
    }
    @{
        Name           = 'ListDlls'
        Uri            = 'https://docs.microsoft.com/en-us/sysinternals/downloads/listdlls'
        # HelpCommand    = Invoke-NativeCommand 'listdlls64' -ArgumentList @('--help')
        ExampleCommand = @(
            # 'Listdlls64.exe 7172'
            # 'Listdlls64.exe spotify'
        )
    }
    @{
        Name           = 'ProcessMonitor'
        Uri            = 'https://docs.microsoft.com/en-us/sysinternals/downloads/procmon'
        Help           = @(
            'https://adamtheautomator.com/procmon/',
            'https://www.howtogeek.com/school/sysinternals-pro/lesson1'
            'https://www.howtogeek.com/school/sysinternals-pro/lesson2'
            'https://www.howtogeek.com/school/sysinternals-pro/lesson3'
            'https://www.howtogeek.com/school/sysinternals-pro/lesson4'
            'https://www.howtogeek.com/school/sysinternals-pro/lesson5'
        )
        ExampleCommand = @(
            # 'Autoruns64'
            # 'Autorunssc64'
            # 'Procmon64'
        )
    }
    #
) | ForEach-Object { [pscustomobject]$_ }

Set-ModuleMetada -key 'Sysinternal' -Value $Metadata
# }
