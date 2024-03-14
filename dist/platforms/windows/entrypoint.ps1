# Call a function, and exit on total timeout, or no output in a period of time
function SafeCall($Code, $NoOutputTimeout, $Timeout) {
    $NoOutputChecks = $Timeout / $NoOutputTimeout
    $Process = Start-Job -ScriptBlock $code

    $NoOutputChecks

    $i = 0
    While ($true) {
        if ($i -eq $NoOutputChecks) {
            Write-Output "$('SafeCall> Process cancelled by total timeout.')"
            Break
        }
        $i += 1

        if (Wait-Job $Process -Timeout $NoOutputTimeout) {
            Write-Output "$('SafeCall> Process Finished')"
            Receive-Job $Process
            Break
        } else {
            $Output = Receive-Job $Process
            $Output
            if ($Output.Length -gt 0) {
                Write-Output "$('SafeCall> There is output. Keep Going.')"
            } else {
                Write-Output "$('SafeCall> No output. Cancelling process.')"
                Break
            }
        }
    }

    Write-Output "$('SafeCall> Process finish state: ')$($Process.State)"
    $Process.State

    Remove-Job -force $Process
}

# Import any necessary registry keys, ie: location of windows 10 sdk
# No guarantee that there will be any necessary registry keys, ie: tvOS
Get-ChildItem -Path c:\regkeys -File | Foreach {reg import $_.fullname}

# Register the Visual Studio installation so Unity can find it
regsvr32 C:\ProgramData\Microsoft\VisualStudio\Setup\x64\Microsoft.VisualStudio.Setup.Configuration.Native.dll

$timeoutSeconds = 60 * 60

# Setup Git Credentials
& "c:\steps\set_gitcredential.ps1"

# Activate Unity
$ActivateCode = {
    & "c:\steps\activate.ps1"
}

# Build with timeout
$BuildCode = {
    # Build the project
    & "c:\steps\build.ps1"
}

# Free the seat for the activated license
$ReturnLicenseCode = {
    & "c:\steps\return_license.ps1"
}

SafeCall $ActivateCode 1200 $timeoutSeconds
SafeCall $BuildCode 3600 $timeoutSeconds
SafeCall $ReturnLicenseCode 1200 $timeoutSeconds
