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

function Write-Log {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [Parameter(Mandatory=$false)]
        [string]$LogFile = "C:\_daten\build.log"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $Message"
    Add-Content -Path $LogFile -Value $logEntry
}

Write-Log -Message "===================== Script started ====================="

Write-Log -Message "BuildPath: $BuildPath"
Write-Log -Message "BuildSourcePath: $BuildSourcePath"
Write-Log -Message "BuildProjectName: $BuildProjectName"

try {
    Write-Output $BuildPath
    Write-Output $BuildSourcePath
    Write-Output $BuildProjectName

    $FilePath = Join-Path $BuildSourcePath $FileName
    Write-Log -Message "Versionfile: $FilePath"

    $content = Get-Content $FilePath

    $currentMajorVersion = $content | Where-Object { $_ -match "#define VERSION_MAJOR" } | ForEach-Object {$_ -split " " | Select-Object -Last 1}
    $currentMinorVersion = $content | Where-Object { $_ -match "#define VERSION_MINOR" } | ForEach-Object {$_ -split " " | Select-Object -Last 1}
    $currentPatchVersion = $content | Where-Object { $_ -match "#define VERSION_PATCH" } | ForEach-Object {$_ -split " " | Select-Object -Last 1}
    $currentBuildVersion = $content | Where-Object { $_ -match "#define VERSION_BUILD" } | ForEach-Object {$_ -split " " | Select-Object -Last 1}

    $newBuildVersion = [int]$currentBuildVersion + 1

    $newFullVersion = "$($currentMajorVersion).$($currentMinorVersion).$($currentPatchVersion).$($newBuildVersion)"
    $newVersionDate = Get-Date -Format "yyyy-MM-dd"
    $newVersionTime = Get-Date -Format "HH:mm:ss"

    $versionContent = "#define VERSION_MAJOR $currentMajorVersion
#define VERSION_MINOR $currentMinorVersion
#define VERSION_PATCH $currentPatchVersion

// Automatically generated build version. Do not modify.
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
            # $versionContent | Set-Content $(Join-Path $BuildPath $FileName) -ErrorAction Stop
            $versionContent | Set-Content $FilePath -ErrorAction Stop
            
            $success = $true
        } catch {
            $lockedProcesses = @(Get-Process | Where-Object {
                $_.Modules | Where-Object {
                    $_.FileName -eq $FilePath
                } 
            } -ErrorAction SilentlyContinue)

            if ($lockedProcesses.Count -gt 0) {
                $procInfo = $lockedProcesses | ForEach-Object { "$($_.ProcessName) (PID: $($_.Id))" } | Out-String
                Write-Log -Message "    File is locked by: $procInfo"
            } else {
                Write-Log -Message "    Could not determine which process is locking the file."
            }
            Write-Log -Message "    attempt $attempt"
            Start-Sleep -Seconds 20
            $attempt++
        }
    } while (-not $success -and $attempt -lt $maxAttempts)

    if (-not $success) {
        Write-Host "Error: The file could not be written after $maxAttempts attempts."
        Write-Log -Message "Error: The file could not be written after $maxAttempts attempts."
    } else {
        Write-Output "Build version incremented to $($newFullVersion)"
        Write-Log -Message "Build version incremented to $($newFullVersion)"
    }

} catch {
    Write-Error $_.Exception.Message
    Write-Log -Message "Error: $($_.Exception.Message)"
    exit 1
}