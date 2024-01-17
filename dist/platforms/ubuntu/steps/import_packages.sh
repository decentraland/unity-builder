#!/usr/bin/env bash

# Define the Unity project path
UnityProjectPath="$GITHUB_WORKSPACE/$PROJECT_PATH"

# Define the path to the required Unity package
RequiredPackagesPath="$UnityProjectPath/Assets/RequiredPackages/requiredPackages.unitypackage"

# Check if the required packages file exists
if [[ -f "$RequiredPackagesPath" ]]; then
    # Import the package using Unity command line
    unity-editor -batchmode -quit -nographics \
                 -projectPath "$UnityProjectPath" \
                 -importPackage "$RequiredPackagesPath" \
                 -logFile -

    # Capture the exit code
    UNITY_EXIT_CODE=$?

    # Check for any errors
    if [[ $UNITY_EXIT_CODE -ne 0 ]]; then
        echo "Package import failed with exit code $UNITY_EXIT_CODE"
        exit $UNITY_EXIT_CODE
    else
        echo "Package import succeeded"
    fi
else
    echo "Package file not found at $RequiredPackagesPath, skipping import step."
fi
