# Not a standalone script meant to be used at minimum with update_deps.ps1 in Surgo/Scripts.

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

function verify-git { param( $path )
	return test-path (join-path $path '.git')
}

function verify-path { param( $path )
	if (test-path $path) {return $true}

	new-item -ItemType Directory -Path $path
	return $false
}


function grab-zip { param( $url, $path_file, $path_dst )
	Invoke-WebRequest -Uri  $url       -OutFile         $path_file
	Expand-Archive    -Path $path_file -DestinationPath $path_dst
}
