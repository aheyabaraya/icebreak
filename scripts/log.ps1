param(
  [string]$Flutter = 'flutter'
)

$ErrorActionPreference = 'Stop'

Write-Host "flutter:"
& $Flutter --version
Write-Host ""
Write-Host "dart:"
& $Flutter dart --version
Write-Host ""
Write-Host "doctor:"
& $Flutter doctor -v
