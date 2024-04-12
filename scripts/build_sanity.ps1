Clear-Host

$path_scripts = $PSScriptRoot
$path_helpers = join-path $path_scripts 'helpers'
$path_root    = split-path -Parent -Path $path_scripts
$path_ue      = join-path $path_root 'UE'
$path_project = join-path $path_root 'Project'

$feditor_log = '-log'

$fubt_project      = '-project'
$fubt_projectfiles = '-projectfiles'
$fubt_game         = '-game'
$fubt_engine       = '-engine'
$fubt_progress     = '-progress'

$ue_editor = join-path $path_ue Engine\Binaries\Win64\UnrealEditor.exe
$UAT       = join-path $path_ue '\Engine\Build\BatchFiles\RunUAT.bat'
$UBT       = join-path $path_ue 'Engine\Binaries\DotNET\UnrealBuildTool\UnrealBuildTool.exe'

$surgo_uproject = join-path $path_project 'Surgo.uproject'


$UAT_BuildCookRun = 'BuildCookRun'
$UAT_BuildGame    = 'BuildGame'
$UAT_BuildTarget  = 'BuildTarget'

$fUAT_unattended                   = '-unattended'
$fUAT_configuration                = '-configuration'
$fUAT_no_tools                     = '-notools'
$fUAT_no_xge                       = '-NoXGE'
$fUAT_disable_unity                = '-DisableUnity'
$fUAT_for_unity_builds             = '-ForceUnity'

$fUAT_target_platform              = '-targetplatform'
$fUAT_server_target_platform       = '-servertargetplatform'

$fUAT_package_target               = '-package'
$fUAT_skip_package_target          = '-skippackage'
$fUAT_never_package_target         = '-neverpackage'

$fUAT_project                      = '-project'

$fUAT_clean                        = '-clean'
$fUAT_build                        = '-build'

$fUAT_cook                         = '-cook'
$fUAT_cook_on_the_fly_streaming    = '-cookontheflystreaming'

$fUAT_cook_all                     = '-CookAll'
$fUAT_cook_maps_only               = '-CookMapsOnly'

$fUAT_stage_prequisites            = '-prereqs'
$fUAT_stage                        = '-stage'
$fUAT_run                          = '-run'

$fUAT_rehydrate_assets             = '-rehydrateassets' # Downloads assets that are only referenced virtually
$fUAT_archive                      = '-archive'
$fUAT_skip_cook                    = '-skipcook'
$fUAT_skip_cook_on_the_fly         = '-skipcookonthefly'
$fUAT_skip_stage                   = '-skipstage'
$fUAT_generate_pak                 = '-pak'
$fUAT_pak_align_for_memory_mapping = '-PakAlignForMemoryMapping'

$fUAT_map_to_run                   = '-map'
$fUAT_server_map_additional_params = '-AdditionalServerMapParams'

$fUAT_distibute = '-distribute'
$fUAT_deploy    = '-deploy'

# Build-Cook-Run combo
$fUAT_bcr_server_target = '-dedicatedserver'
$fUAT_bcr_client_target = '-client'
$fUAT_run_just_server   = '-noclient'
$fUAT_client_open_log   = '-logwindow'
$fUAT_skip_server       = '-skipserver'

# Push-Location $path_ue
Push-Location $path_project

$UAT_args = @()
$UAT_args += $UAT_BuildCookRun
$UAT_args += "$fUAT_project=$surgo_uproject"
$UAT_args += $fUAT_build
$UAT_args += $fUAT_cook
$UAT_args += $fUAT_cook_all
$UAT_args += $fUAT_stage

& $UAT $UAT_args

Pop-Location
