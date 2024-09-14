[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $BuildPath,
    [Parameter(Mandatory=$true)]
    [String]
    $BuildSourcePath,
    [Parameter()]
    [String]
    $BuildProjectName,
    [Parameter(Mandatory=$false)]
    [String]
    $FileName = "version.h"
)

try{
    Write-Output $BuildPath
    Write-Output $BuildSourcePath
    Write-Output $BuildProjectName
    
    $FilePath = Join-Path $BuildSourcePath $FileName

    $content = Get-Content $FilePath

    $isOldStyle = ($null -eq $($content | Select-String -Pattern '#define VERSION_BUILD'))

    if ($isOldStyle) {
        $first = $content.IndexOf('"')
        $last = $content.LastIndexOf('"')
    
        $version = $content.Substring($first + 1, $last - $first - 1).Split('.')  
        $currentMajorVersion = [int]$version[0]
        $currentMinorVersion = [int]$version[1] 
        $currentPatchVersion = [int]$version[2]
        $currentBuildVersion = [int]$version[3] 
    } else {
        $currentMajorVersion = $content | Where-Object { $_ -match "#define VERSION_MAJOR" } | ForEach-Object {$_ -split " " | Select-Object -Last 1}
        $currentMinorVersion = $content | Where-Object { $_ -match "#define VERSION_MINOR" } | ForEach-Object {$_ -split " " | Select-Object -Last 1}
        $currentPatchVersion = $content | Where-Object { $_ -match "#define VERSION_PATCH" } | ForEach-Object {$_ -split " " | Select-Object -Last 1}
        $currentBuildVersion = $content | Where-Object { $_ -match "#define VERSION_BUILD" } | ForEach-Object {$_ -split " " | Select-Object -Last 1}
    }

    $newBuildVersion = [int]$currentBuildVersion + 1

    $newFullVersion = "$($currentMajorVersion).$($currentMinorVersion).$($currentPatchVersion).$($newBuildVersion)"
    $newVersionDate = Get-Date -Format "yyyy-MM-dd"
    $newVersionTime = Get-Date -Format "HH:mm:ss"

    $versionContent = "#define VERSION_MAJOR $currentMajorVersion
#define VERSION_MINOR $currentMinorVersion
#define VERSION_PATCH $currentPatchVersion
#define VERSION_BUILD $newBuildVersion
#define VERSION_DATE `"$newVersionDate`"
#define VERSION_TIME `"$newVersionTime`"
#define VERSION `"$newFullVersion`"
#define VERSION_STR `"$newFullVersion ($newVersionDate $newVersionTime)`""

    $maxAttempts = 5
    $attempt = 0
    $success = $false

    do {
        try {
            $versionContent | Set-Content $(Join-Path $BuildPath $FileName) -ErrorAction Stop
            $versionContent | Set-Content $FilePath -ErrorAction Stop
            $success = $true
        } catch {
            Start-Sleep -Seconds 1
            $attempt++
        }
    } while (-not $success -and $attempt -lt $maxAttempts)

    if (-not $success) {
         Write-Host "Error: The file could not be written after $maxAttempts attempts."
    } else {
        Write-Output "Build version incremented to $($newFullVersion)"
    }

}
catch{
    Write-Error $_.Exception.Message
    exit 1
}