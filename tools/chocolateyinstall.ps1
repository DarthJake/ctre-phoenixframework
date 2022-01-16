$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url         = 'https://github.com/CrossTheRoadElec/Phoenix-Releases/releases/download/v5.20.2.2/CTRE_Phoenix_Framework_v5.20.2.2.exe'
$fileName    = 'CTRE_Phoenix_Framework_v5.20.2.2.exe'
$checksum = '1eb77964aaec71f0e362a36681b2aa8b8f993f45afa7490c97a17c152ce3d128'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'CTRE Phoenix Framework*'
  fileType       = 'EXE'
  Url            = $url
  file           = $fileName
  checksum       = $checksum
  checksumType   = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0, 1223) # 1223 because there is a bug with the installer and /S right now
}

$ahkExe = "AutoHotKey" # This is a reference to the global AHK exe
$ahkFile = Join-Path $toolsDir "ctre-phoenixframeworkInstall.ahk"
Write-Debug "Running: $ahkExe `"$ahkFile`"$ahkParameters"
$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList "`"$ahkFile`" $ahkParameters" -Verb RunAs -PassThru

$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

Install-ChocolateyPackage  @packageArgs #https://docs.chocolatey.org/en-us/guides/create/mount-an-iso-in-chocolatey-package