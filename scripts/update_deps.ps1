clear-host

$path_scripts =  $PSScriptRoot
$path_root    = split-path -Parent -Path $path_scripts

$ini_parser = join-path $PSScriptRoot 'helpers/ini.ps1'
. $ini_parser
write-host 'ini.ps1 imported'

$path_system_details = join-path $path_scripts 'system_details.ini'
if ( test-path $path_system_details ) {
    $iniContent = Get-IniContent $path_system_details
    $CoreCount_Physical = $iniContent["CPU"]["PhysicalCores"]
    $CoreCount_Logical  = $iniContent["CPU"]["LogicalCores"]
}
elseif ( $IsWindows ) {
	$CPU_Info = Get-CimInstance –ClassName Win32_Processor | Select-Object -Property NumberOfCores, NumberOfLogicalProcessors
	$CoreCount_Physical, $CoreCount_Logical = $CPU_Info.NumberOfCores, $CPU_Info.NumberOfLogicalProcessors

	new-item -path $path_system_details -ItemType File
    "[CPU]"                             | Out-File $path_system_details
    "PhysicalCores=$CoreCount_Physical" | Out-File $path_system_details -Append
    "LogicalCores=$CoreCount_Logical"   | Out-File $path_system_details -Append
}
write-host "Core Count - Physical: $CoreCount_Physical Logical: $CoreCount_Logical"

$path_ue            = join-path $path_root 'UE'
$path_ue_git        = join-path $path_ue   'git'
$ue_repo_url        = 'https://github.com/EpicGames/UnrealEngine.git'
$ue_branch_5_4      = '5.4'
$ue_branch_release  = 'release'
$ue_branch_main     = 'ue5-main'
$ue_origin_offical  = 'EpicGames'

$git_commit_depth = 1

$flag_branch             = '--branch'
$flag_commit_depth       = '--depth'
$flag_init               = '--init'
$flag_jobs               = '--jobs'
$flag_origin             = '--origin'
$flag_progress           = '--progress'
$flag_recursive          = '--recursive'
$flag_shallow_submodules = '--shallow-submodules'
$flag_single_branch      = '--single-branch'

if ((test-path $path_ue) -eq $false)
{
	new-item -Type Directory $path_ue
}

push-location $path_ue

function invoke-git {
    param (
        $command
    )
	write-host $command
    & git @command
	# 2>&1 | ForEach-Object {
    #     $color = 'Cyan'
    #     switch ($_){
    #         { $_ -match "error"   } { $color = 'Red'    ; break }
    #         { $_ -match "warning" } { $color = 'Yellow' ; break }
    #     }
    #     Write-Host "`t $_" -ForegroundColor $color
    # }
}

if ((test-path $path_ue_git) -eq $false)
{
	$clone_5_4 = @()
	$clone_5_4 += 'clone'
	$clone_5_4 += $flag_progress
	$clone_5_4 += @($flag_origin, $ue_origin_offical)
	$clone_5_4 += @($flag_branch, $ue_branch_5_4)
	$clone_5_4 += $ue_repo_url
	$clone_5_4 += @($flag_commit_depth, $git_commit_depth)
	$clone_5_4 += $flag_single_branch
	$clone_5_4 += @($flag_jobs, $CoreCount_Physical)
	$clone_5_4 += $flag_shallow_submodules
	$clone_5_4 += $path_ue
	invoke-git $clone_5_4

	$init_submodules = @()
	$init_submodules += 'submodule'
	$init_submodules += 'update'
	$init_submodules += $flag_init
	$init_submodules += @($flag_commit_depth, $git_commit_depth)
	$init_submodules += $flag_recursive
	$init_submodules += @($flag_jobs, $CoreCount_Physical)
	$init_submodules += $flag_single_branch
	invoke-git $init_submodules
}

$fgitdep_cache      = '--cache'
$fgitdep_dryrun     = '--dry-run'
$fgitdep_include    = '--include'
$fgitdep_exclude    = '--exclude'
$fgitdep_no_cache   = '--no-cache'
$path_gitdeps_cache = "C:/dev/epic/GitDeps"

$ue_module_Avalanche                = 'Engine/Plugins/Editor/Avalanche'
$ue_module_Harmonix                 = 'Engine/Plugins/Experimental/Harmonix'
$ue_module_GooglePAD                = 'Engine/Plugins/Experimental/GooglePAD'
$ue_module_StormSyncAvalancheBridge = 'Engine/Plugins/Experimental/StormSyncAvalancheBridge'
$ue_module_OnlineSubsystemFacebook  = 'Engine/Plugins/Online/OnlineSubsystemFacebook'
$ue_module_OnlineSubsystemGoogle    = 'Engine/Plugins/Online/OnlineSubsystemGoogle'

$exclude_list  = @()
$exclude_list += 'WinRT'
$exclude_list += 'Mac'
$exclude_list += 'MacOSX'
$exclude_list += 'osx'
$exclude_list += 'osx64'
$exclude_list += 'osx32'
$exclude_list += 'Android'
$exclude_list += 'IOS'
$exclude_list += 'TVOS'
$exclude_list += 'HTML5'
$exclude_list += 'PS4'
$exclude_list += 'XboxOne'
$exclude_list += 'Switch'
$exclude_list += 'Dingo'
$exclude_list += 'GoogleVR'
$exclude_list += 'LeapMotion'
$exclude_list += 'HoloLens'

# $exclude_list += 'Engine/Plugins/Editor/DisplayClusterLaunch'

# $exlcude_list += 'Engine/Plugins/Experimental/AR'
$exclude_list += $ue_module_Avalanche
$exclude_list += $ue_module_Harmonix
$exclude_list += $ue_module_GooglePAD
# $exclude_list += 'Engine/Plugins/Experimental/LiveLinkOvernDisplay'
# $exclude_list += 'Engine/Plugins/Experimental/MeshModelingToolset'
# $exclude_list += 'Engine/Plugins/Experimental/Mutable'
# $exclude_list += 'Engine/Plugins/Experimental/ResonanceAudio'
# $exclude_list += 'Engine/Plugins/Experimental/OpenCV'
$exclude_list += $ue_module_StormSyncAvalancheBridge

# $exclude_list += 'Engine/Plugins/Runtime/nDisplay'
# $exclude_list += 'Engine/Plugins/Runtime/nDisplayModularFeatures'

# $exclude_list += 'Engine/Source/Thirdparty/CEF3'

# $exclude_list += 'Engine/Plugins/Runtime/LiveLinkOvernDisplay'

# LiveLinkXR is in here...
# $exclude_list += 'VirtualProduction'
# $exclude_list += 'VirtualProductionUtilities'

# $exclude_list += 'Engine/Plugins/VirtualProduction'

# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/CameraCalibration'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/CameraCalibrationCore'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/CompositePlane'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/DataCharts'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/DMX'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/EpicStageApp'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/ICVFX'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/ICVFXTesting'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/LedWallCalibration'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/LensComponent'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/LevelSnapshots'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/LiveLinkCamera'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/LiveLinkFreeD'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/LiveLinkInputDevice'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/LiveLinkInputLens'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/LiveLinkMasterLockit'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/LiveLinkPrestonMDR'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/LiveLinkVRPN'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/LiveLinkXR'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/MultiUserTakes'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/RemoteControl'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/RemoteControlInterception'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/RemoteControlProtocolIDMX'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/RemoteControlProtocolIMIDI'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/RemoteControlProtocolIOSC'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/RemoteControlWebInterface'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/Rivermax'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/SequencePlaylists'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/StageMonitoring'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/Switchboard'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/Takes'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/TextureShare'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/TimedDataMonitor'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/VirtualCamera'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/VirtualCameraCore'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/VPRoles'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProduction/VPSettings'
# $exclude_list += 'Engine/Plugins/Experimental/VirtualProductionUtilities'

$exclude_list += $ue_module_OnlineSubsystemFacebook
$exclude_list += $ue_module_OnlineSubsystemGoogle

$setup_args = @()
foreach ($entry in $exclude_list) {
	$setup_args += "$fgitdep_exclude=$entry"
	# remove-item $entry -Recurse
}
$setup_args += "$fgitdep_cache=$path_gitdeps_cache"
# $setup_args += $fgitdep_dryrun


$path_setup_log = 'setup_log.txt'
& .\Setup.bat $setup_args
# $output = Start-Process -FilePath "cmd.exe" -ArgumentList "/c .\Setup.bat $setup_args" -Wait -PassThru -NoNewWindow -RedirectStandardOutput $path_setup_log

& .\GenerateProjectFiles.bat


$path_templates = join-path $path_ue 'Templates'
remove-item $path_templates

pop-location # $path_ue
