# Import any necessary registry keys, ie: location of windows 10 sdk
# No guarantee that there will be any necessary registry keys, ie: tvOS
Get-ChildItem -Path c:\regkeys -File | Foreach {reg import $_.fullname}

# Register the Visual Studio installation so Unity can find it
regsvr32 C:\ProgramData\Microsoft\VisualStudio\Setup\x64\Microsoft.VisualStudio.Setup.Configuration.Native.dll

# Setup Git Credentials
& "c:\steps\set_gitcredential.ps1"

# Activate Unity
& "c:\steps\activate.ps1"

# Build with timeout
$timeoutSeconds = $Env:BUILD_TIMEOUT * 60
$code = {
    # Build the project
    & "c:\steps\build.ps1"
}
Write-Output "$('> Start Job')"
$j = Start-Job -ScriptBlock $code
if (Wait-Job $j -Timeout $timeoutSeconds) {
    Receive-Job $j
    Write-Output "$('> Job Completed')"
} else {
    Write-Output "$('> Job Interrupted')"
}
Remove-Job -force $j

# Free the seat for the activated license
& "c:\steps\return_license.ps1"
