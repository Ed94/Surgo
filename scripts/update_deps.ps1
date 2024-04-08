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

if ((test-path $path_ue) -eq $false)
{
	new-item -Type Directory $path_ue

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

& .\setup.bat
& .\GenerateProjectFiles.bat

pop-location # $path_ue
