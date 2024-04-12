$path_scripts = $PSScriptRoot
$path_helpers = join-path $path_scripts 'helpers'
$path_root    = split-path -Parent -Path $path_scripts
$path_ue      = join-path $path_root 'UE'

$UbaAgent = join-path $path_ue 'Engine\Binaries\Win64\UnrealBuildAccelerator\x64\UbaAgent.exe'

$uba_quic       = '-quic'
$uba_host       = '-host'
$uba_listen     = '-listen'
$uba_name       = '-name'
$uba_no_poll    = '-no_poll'
$uba_store_raw  = '-storeraw'
$uba_max_cpu    = '-maxcpu'
$uba_mul_cpu    = '-mulcpu'
$uba_memwait    = '-maxwait'
$uba_zone       = '-zone'


$args = @()
# $args += "$uba_host=192.168.1.148"
$args += $uba_listen
# $args += "$uba_mul_cpu=2.0"
# $args += $uba_quic
# $args += $

& $UbaAgent $args
