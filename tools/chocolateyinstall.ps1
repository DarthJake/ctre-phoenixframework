﻿$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url         = 'https://github.com/CrossTheRoadElec/Phoenix-Releases/releases/download/v5.19.4.1/CTRE_Phoenix_Framework_v5.19.4.1.exe'
$fileName    = 'CTRE_Phoenix_Framework_v5.19.4.1.exe'
$checksum = '1EA016D735A7002CB9CE7979006EE8B2B0D4BA953FC3E29898DD63D311D29B46'

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