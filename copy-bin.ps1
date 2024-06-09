[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $SourceFilePath,
    [Parameter(Mandatory=$true)]
    [String]
    $DestinationFilePath
)
try{
    Copy-Item -Path $SourceFilePath -Destination $DestinationFilePath -Force
    Write-Output "File copied successfully"
}
catch{
    Write-Output "Error: $_"
    exit 1
}