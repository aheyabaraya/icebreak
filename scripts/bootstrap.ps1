param(
  [string]$LogPath
)

$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')

function Resolve-Flutter {
  $cmd = Get-Command flutter -ErrorAction SilentlyContinue
  if ($cmd) { return $cmd.Source }

  $local = Join-Path $repoRoot 'tooling\flutter\bin\flutter.bat'
  if (Test-Path $local) { return $local }

  throw "flutter not found. Install Flutter and add to PATH, or place it at $local"
}

$flutter = Resolve-Flutter
$dart = (Split-Path -Parent $flutter) + '\\dart.bat'

$ts = Get-Date -Format 'yyyyMMdd_HHmm'
if (-not $LogPath) {
  $LogPath = Join-Path $repoRoot ("docs\\logs\\install_${ts}.md")
}

New-Item -ItemType Directory -Path (Split-Path -Parent $LogPath) -Force | Out-Null
"# Bootstrap Log ${ts}`n`n- Timestamp: $(Get-Date -Format o)`n- Repo: $repoRoot`n- Flutter: $flutter`n" | Set-Content -Encoding utf8 $LogPath

function Run-Logged {
  param([string]$Title, [scriptblock]$Block)
  Add-Content -Encoding utf8 $LogPath "## $Title"
  Add-Content -Encoding utf8 $LogPath '```text'
  # Tee-Object defaults to UTF-16 in Windows PowerShell; capture as string and append as UTF-8.
  $out = (& $Block 2>&1 | Out-String)
  Write-Host $out -NoNewline
  Add-Content -Encoding utf8 $LogPath $out
  Add-Content -Encoding utf8 $LogPath '```'
  Add-Content -Encoding utf8 $LogPath ''
}

Run-Logged "$flutter --version" { & $flutter --version }
if (Test-Path $dart) {
  Run-Logged "$dart --version" { & $dart --version }
}
Run-Logged "$flutter doctor -v" { & $flutter doctor -v }

Push-Location (Join-Path $repoRoot 'apps\mobile')
try {
  Run-Logged 'flutter pub get' { & $flutter pub get }
  Run-Logged 'flutter pub deps --style=compact' { & $flutter pub deps --style=compact }
  Run-Logged 'flutter analyze' { & $flutter analyze }
}
finally {
  Pop-Location
}

Write-Host "Wrote log: $LogPath"
