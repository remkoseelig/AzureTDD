#!/bin/bash
set -e

export TAG=$1

if [[ -z $TAG ]];
then
    export TAG="*"
fi

# Execute the PowerShell Pester tests
pwsh -Command ./Invoke-Tests.ps1 -Tag "${TAG}"

# Return PowerShell result
exit $?
