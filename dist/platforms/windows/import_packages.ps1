# import_package.ps1
# Imports Unity packages from the specified directory

$UnityExecutable = "C:\Program Files\Unity\Hub\Editor\$Env:UNITY_VERSION\Editor\Unity.exe"
$UnityProjectPath = "$Env:GITHUB_WORKSPACE\$Env:PROJECT_PATH"
$RequiredPackagesPath = "$UnityProjectPath\Assets\RequiredPackages\requiredPackages.unitypackage"

# Import the package using Unity command line
& $UnityExecutable -batchmode -quit -nographics `
                    -projectPath $UnityProjectPath `
                    -importPackage $RequiredPackagesPath `
                    -logfile | Out-Host

# Check for any errors
if ($LastExitCode -ne 0) {
    Write-Output "Package import failed with exit code $LastExitCode"
    exit $LastExitCode
} else {
    Write-Output "Package import succeeded"
}
