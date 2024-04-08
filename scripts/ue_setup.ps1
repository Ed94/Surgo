# UE setup.bat Translated

# Figure out if we should append the -prompt argument
$argumentList = @()
if ($null -ne $PROMPT_ARGUMENT) {
    $argumentList += $PROMPT_ARGUMENT
}
$argumentList += $args

$path_GitDependencies = ".\Engine\Binaries\DotNET\GitDependencies\win-x64\GitDependencies.exe"
$syncDeps = Start-Process -FilePath $path_GitDependencies -ArgumentList $argumentList -NoNewWindow -Wait -PassThru
if ($syncDeps.ExitCode -ne 0) {
    Write-Host "UE - Error: Failed to sync dependencies" -ForegroundColor Red
    # Error happened. Wait for a keypress before quitting.
    Read-Host -Prompt "Press Enter to continue"
    exit
}

$hooksDir = ".\.git\hooks"
if (Test-Path $hooksDir) {
    Write-Host "UE: Registering git hooks..."
    Set-Content -Path "$hooksDir\post-checkout" -Value "#!/bin/sh`nEngine/Binaries/DotNET/GitDependencies/win-x64/GitDependencies.exe $($args -join ' ')"
    Set-Content -Path "$hooksDir\post-merge"    -Value "#!/bin/sh`nEngine/Binaries/DotNET/GitDependencies/win-x64/GitDependencies.exe $($args -join ' ')"
}

Write-Host "UE: Installing prerequisites..."
Start-Process -FilePath "Engine\Extras\Redist\en-us\UEPrereqSetup_x64.exe" -ArgumentList "/quiet", "/norestart" -Wait

$path_engine_ver_selector = ".\Engine\Binaries\Win64\UnrealVersionSelector-Win64-Shipping.exe"
if (Test-Path $path_engine_ver_selector) {
    Start-Process -FilePath $path_engine_ver_selector -ArgumentList "/register" -NoNewWindow -Wait
}

Write-Host "UE: Setup complete!" -ForegroundColor Green
