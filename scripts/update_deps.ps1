clear-host

$path_scripts = $PSScriptRoot
$path_helpers = join-path $path_scripts 'helpers'
$path_root    = split-path -Parent -Path $path_scripts

$ini_parser = join-path $path_helpers 'ini.ps1'
. $ini_parser
write-host 'ini.ps1 imported'

$misc = join-path $path_helpers 'misc.ps1'
. $misc
write-host 'misc.ps1 imported'

$path_ue = join-path $path_root 'UE'

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

if ((test-path $path_ue) -eq $false) {
	new-item -Type Directory $path_ue
}

push-location $path_ue
write-host

$path_ue_git = join-path $path_ue '.git'
# If its a clean project, need to do first-time setup
if ((test-path $path_ue_git) -eq $false)
{
	write-host 'UE not found, pulling...'

	$url_ue_repo        = 'https://github.com/EpicGames/UnrealEngine.git'
	$ue_branch_5_3      = '5.3'
	$ue_branch_5_4      = '5.4'
	$ue_branch_release  = 'release'
	$ue_branch_main     = 'ue5-main'
	$ue_origin_offical  = 'EpicGames'

	$clone_ue = @()
	$clone_ue += 'clone'
	$clone_ue += $flag_progress
	$clone_ue += @($flag_origin, $ue_origin_offical)
	$clone_ue += @($flag_branch, $ue_branch_5_4)
	$clone_ue += $url_ue_repo
	$clone_ue += @($flag_commit_depth, $git_commit_depth)
	$clone_ue += $flag_single_branch
	$clone_ue += @($flag_jobs, $CoreCount_Physical)
	$clone_ue += $flag_shallow_submodules
	$clone_ue += $path_ue
	invoke-git $clone_ue

	$init_submodules = @()
	$init_submodules += 'submodule'
	$init_submodules += 'update'
	$init_submodules += $flag_init
	$init_submodules += @($flag_commit_depth, $git_commit_depth)
	$init_submodules += $flag_recursive
	$init_submodules += @($flag_jobs, $CoreCount_Physical)
	$init_submodules += $flag_single_branch
	invoke-git $init_submodules

	write-host "UE repo updated`n"
}
else {
	write-host "Found existing UE repo, manage manually for updates`n"
}

function Process-UnrealDeps
{
	write-host 'Processing Unreal Deps...'

	$fgitdep_cache      = '--cache'
	$fgitdep_dryrun     = '--dry-runhttps://github.com/EpicGames/UnrealEngine/tree/5.3'
	$fgitdep_include    = '--include'
	$fgitdep_exclude    = '--exclude'
	$fgitdep_no_cache   = '--no-cache'
	$path_gitdeps_cache = "C:/dev/epic/GitDeps"

	$ue_plugin_Avalanche                = 'Engine/Plugins/Editor/Avalanche'
	$ue_plugin_Harmonix                 = 'Engine/Plugins/Experimental/Harmonix'
	$ue_plugin_StormSyncAvalancheBridge = 'Engine/Plugins/Experimental/StormSyncAvalancheBridge'
	$ue_plugin_OnlineSubsystemFacebook  = 'Engine/Plugins/Online/OnlineSubsystemFacebook'
	$ue_plugin_OnlineSubsystemGoogle    = 'Engine/Plugins/Online/OnlineSubsystemGoogle'
	$ue_plugin_GooglePAD                = 'Engine/Plugins/Runtime/GooglePAD'

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

	$exclude_list += $ue_plugin_Avalanche
	$exclude_list += $ue_plugin_Harmonix
	$exclude_list += $ue_plugin_GooglePAD
	$exclude_list += $ue_plugin_StormSyncAvalancheBridge

	$exclude_list += $ue_plugin_OnlineSubsystemFacebook
	$exclude_list += $ue_plugin_OnlineSubsystemGoogle

	$setup_args = @()
	foreach ($entry in $exclude_list) {
		$setup_args += "$fgitdep_exclude=$entry"

		if (verify-path $entry) {
			# remove-item $entry -Recurse
		}
	}
	$setup_args += "$fgitdep_cache=$path_gitdeps_cache"
	# $setup_args += $fgitdep_dryrun

	# $path_setup_log = 'setup_log.txt'
	# $output = Start-Process -FilePath "cmd.exe" -ArgumentList "/c .\Setup.bat $setup_args" -Wait -PassThru -NoNewWindow -RedirectStandardOutput $path_setup_log
	# & .\Setup.bat $setup_arg
	& .\Setup.bat

	# $path_templates = join-path $path_ue 'Templates'
	# remove-item $path_templates -Recurse
	# 'Deleted UE templates (grab them manually if want)'

	write-host "Finished processing unreal deps`n"
}
Process-UnrealDeps

$ue_plugins_surgo = join-path $path_ue 'Engine\Plugins\Surgo'
verify-path $ue_plugins_surgo

function setup-fmod
{
	$ue_module_FMODStudio        = join-path $path_ue '\Engine\Plugins\FMODStudio'
	$ue_module_FMODStudioNiagara = join-path $path_ue '\Engine\Plugins\FMODStudioNiagara'

	$url_fmod = 'https://github.com/fmod/fmod-for-unreal.git'

	$clone_repo = @()
	$clone_repo += 'clone'
	$clone_repo += $flag_progress
	$clone_repo += @($flag_origin, 'fmod')
	$clone_repo += @($flag_branch, 'master')
	$clone_repo += $url_steamaudio
	$clone_repo += $flag_single_branch
	$clone_repo += @($flag_jobs, $CoreCount_Physical)
	$clone_repo += $ue_module_SteamAudio
	invoke-git $clone_repo
}
# setup-fmod

function setup-steamaudio
{
	$ue_plugin_Steam                = join-path $path_ue 'Engine\Plugins\Runtime\Steam'
	$ue_plugin_SteamAudio           = join-path $path_ue 'Engine\Plugins\Runtime\Steam\SteamAudio'
	$ue_plugin_SteamAudioFMODStudio = join-path $path_ue 'Engine\Plugins\Runtime\Steam\SteamAudioFMODStudio'

	if ($false) {
		if (verify-git $ue_plugin_SteamAudio ) {
			write-host "Steam Audio repo found, manage manually for updates`n"
			return
		}

		write-host 'Grabbing Steam Audio repo'
		remove-item -Path "$ue_plugin_SteamAudio\*" -Recurse -Confirm:$false

		$url_steamaudio = 'https://github.com/ValveSoftware/steam-audio.git'

		$clone_repo = @()
		$clone_repo += 'clone'
		$clone_repo += $flag_progress
		$clone_repo += @($flag_origin, 'ValveSoftware')
		$clone_repo += @($flag_branch, 'master')
		$clone_repo += $url_steamaudio
		$clone_repo += $flag_single_branch
		$clone_repo += @($flag_jobs, $CoreCount_Physical)
		$clone_repo += $ue_plugin_SteamAudio
		invoke-git $clone_repo
	}
	else {
		write-host 'Grabbing Steam Audio zip'
		remove-item -Path $ue_plugin_SteamAudio -Recurse -Confirm:$false

		$url_steamaudio      = 'https://github.com/ValveSoftware/steam-audio/releases/download/v4.5.3/steamaudio_unreal_4.5.3.zip'
		$path_steamaudio_zip = join-path $ue_plugin_Steam 'steamaudio_unreal_4.5.3.zip'
		grab-zip $url_steamaudio $path_steamaudio_zip $ue_plugin_Steam

		# Engine\Plugins\Runtime\Steam\steamaudio_unreal\unreal\SteamAudio
		$path_steamaudio_unreal            = join-path $ue_plugin_Steam 'steamaudio_unreal'
		$path_steamaudio_unreal_SteamAudio = join-path $path_steamaudio_unreal 'unreal\SteamAudio'
		# $ue_binaries_SteamFMODStudio = join-path $path_steamaudio_unreal 'FMODStudio'
		# remove-item -Type Directory $ue_binaries_SteamFMODStudio -Recurse -Confirm:$false
		move-item -Path $path_steamaudio_unreal_SteamAudio -Destination $ue_plugin_Steam -Confirm:$false
		remove-item $path_steamaudio_unreal -Recurse -Confirm:$false
		remove-item $path_steamaudio_zip             -Confirm:$false
	}
	write-host
}
setup-steamaudio

function setup-imgui
{
	$ue_plugin_VesCodesImGui = join-path $path_ue 'Engine\Plugins\Surgo\UE_ImGui'
	$ue_plugin_ImGui         = join-path $path_ue 'Engine\Plugins\Surgo\UnrealImGui'
	$ue_plugin_ImGuiTools    = join-path $path_ue 'Engine\Plugins\Surgo\UnrealImGuiTools'

	$add_VesCodesImGui    = $true
	$add_UnrealImGui      = $false
	$add_UnrealImGuiTools = $false

	# if ($add_VesCodesImGui -and (-not (verify-git $ue_plugin_VesCodesImGui)))
	if ($add_VesCodesImGui)
	{
		write-host 'Grabbing VesCodes ImGui repo'
		verify-path $ue_plugin_VesCodesImGui
		$url_VesCodesImGui = 'https://github.com/Ed94/UE_ImGui.git'

		$clone_imgui = @()
		$clone_imgui += 'clone'
		$clone_imgui += $flag_progress
		$clone_imgui += @($flag_origin, 'Ed94')
		$clone_imgui += @($flag_branch, 'Main')
		$clone_imgui += $url_VesCodesImGui
		$clone_imgui += $flag_single_branch
		$clone_imgui += @($flag_jobs, $CoreCount_Physical)
		$clone_imgui += $ue_plugin_VesCodesImGui
		invoke-git $clone_imgui

		$path_engine_thirdparty        = Join-Path $path_ue 'Engine/Source/Thirdparty'
		$path_VescodesImGui_thirdparty = join-path $ue_plugin_VesCodesImGui 'Source/Thirdparty'

		Move-Item -Path "$path_VescodesImGui_thirdparty\*" -Destination $path_engine_thirdparty -Confirm:$false
		Remove-Item -Path $path_VescodesImGui_thirdparty -Recurse -Confirm:$false
	}

	if ($add_UnrealImGui -and (-not (verify-git $ue_plugin_ImGui)))
	{
		write-host 'Grabbing UnrealImGui repo'
		verify-path $ue_plugin_ImGui
		$url_UnrealImGui = 'https://github.com/Ed94/UnrealImGui.git'

		$clone_imgui = @()
		$clone_imgui += 'clone'
		$clone_imgui += $flag_progress
		$clone_imgui += @($flag_origin, 'Ed94')
		$clone_imgui += @($flag_branch, 'master')
		$clone_imgui += $url_UnrealImGui
		$clone_imgui += $flag_single_branch
		$clone_imgui += @($flag_jobs, $CoreCount_Physical)
		$clone_imgui += $ue_plugin_ImGui
		invoke-git $clone_imgui
	}

	if ($add_UnrealImGuiTools -and (-not (verify-git $ue_plugin_ImGuiTools)))
	{
		write-host 'Grabbing UnrealImGuiTools repo'
		verify-path $ue_plugin_ImGuiTools
		$url_UnrealImGuiTools = 'https://github.com/nakdeyes/UnrealImGuiTools.git'

		$clone_imguitools = @()
		$clone_imguitools += 'clone'
		$clone_imguitools += $flag_progress
		$clone_imguitools += @($flag_origin, 'nakdeyes')
		$clone_imguitools += @($flag_branch, 'main')
		$clone_imguitools += $url_UnrealImGuiTools
		$clone_imguitools += $flag_single_branch
		$clone_imguitools += @($flag_jobs, $CoreCount_Physical)
		$clone_imguitools += $ue_plugin_ImGuiTools
		invoke-git $clone_imguitools
	}

	write-host
}
setup-imgui

function setup-cog
{
	$ue_plugin_Cog = join-path $path_ue 'Engine\Plugins\Surgo\Cog'
	if ($false) {
		write-host 'Grabbing Cog repo'
		if (verify-git $ue_plugin_Cog) {return}
		verify-path $ue_plugin_Cog

		$url_Cog = 'https://github.com/arnaud-jamin/Cog.git'

		$clone_cog = @()
		$clone_cog += 'clone'
		$clone_cog += $flag_progress
		$clone_cog += @($flag_origin, 'arnaud-jamin')
		$clone_cog += @($flag_branch, 'main')
		$clone_cog += $url_Cog
		$clone_cog += $flag_single_branch
		$clone_cog += @($flag_jobs, $CoreCount_Physical)
		$clone_cog += $ue_plugin_Cog
		invoke-git $clone_cog
	}
	else {
		write-host 'Grabbing Cog zip'
		$url_Cog      = 'https://github.com/Ed94/Cog/releases/download/latest/Cog.zip'
		$path_cog_zip = join-path $ue_plugins_surgo 'Cog.zip'

		grab-ip $url_Cog $path_cog_zip $ue_plugins_surgo
		remove-item $path_cog_zip -Confirm:$false
	}
	write-host
}
setup-cog

function setup-tracy
{
	# TODO(Ed): Eventually add
	$url_ue_tracy = 'https://github.com/Nesquick0/TracyUnrealPlugin.git'
}
# setup_tracy

& .\GenerateProjectFiles.bat

pop-location # $path_ue
