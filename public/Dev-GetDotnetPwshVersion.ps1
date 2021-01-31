
function Dev-GetDotnetPwshVersion {
    <#
    .synopsis
        get dotnet runtime version
    .example

        PS> Dev-GetDotnetPwshVersion

            [Runtime.InteropServices.RuntimeInformation]::FrameworkDescription]:
            .NET 5.0.0
            [Environment::Version]:

            Major  Minor  Build  Revision
            -----  -----  -----  --------
            5      0      0      -1
    #>
    Label '[Runtime.InteropServices.RuntimeInformation]::FrameworkDescription]'
    [Runtime.InteropServices.RuntimeInformation]::FrameworkDescription

    Label '[Environment::Version]'
    [Environment]::Version
}
