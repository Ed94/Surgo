Clear-Host

$path_scripts = $PSScriptRoot
$path_helpers = join-path $path_scripts 'helpers'
$path_root    = split-path -Parent -Path $path_scripts
$path_ue      = join-path $path_root 'UE'
$path_project = join-path $path_root 'Project'

$ue_editor = join-path $path_ue 'Engine\Binaries\Win64\UnrealEditor.exe'

$surgo_uproject = join-path $path_project 'Surgo.uproject'

$feditor_log = '-log'

& $ue_editor $surgo_uproject $feditor_log
