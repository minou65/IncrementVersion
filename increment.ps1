[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $BuildPath,
    [Parameter()]
    [String]
    $BuildSourcePath,
    [Parameter()]
    [String]
    $BuildProjectName,
    [Parameter()]
    [String]
    $FileName = "version.h"
)

try{
    Write-Output $BuildPath
    Write-Output $BuildSourcePath
    Write-Output $BuildProjectName

    $FilePath = Join-Path $BuildSourcePath $FileName

    $content = Get-Content $FilePath
    $first = $content.IndexOf('"')
    $last = $content.LastIndexOf('"')

    $version = $content.Substring($first + 1, $last - $first - 1).Split('.')  
    $version[3] = [int]$version[3] + 1  

    $NewVersion = $version -join '.'

    $Output = '#define VERSION "' + $NewVersion + '"'
    
    $Output | Set-Content $FilePath
    $Output | Set-Content $(Join-Path $BuildPath $FileName)


    Write-Output "Version incremented to $($NewVersion)"
}
catch{
    Write-Error $_.Exception.Message
    exit 1
}