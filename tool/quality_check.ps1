$ErrorActionPreference = "Stop"

param(
  [string]$Flutter = "C:\Dev\tools\flutter_3.41.0\bin\flutter.bat",
  [switch]$SkipBuild,
  [switch]$SkipPublishDryRun
)

$root = Split-Path -Parent $PSScriptRoot
$example = Join-Path $root "example"
$mobilePreview = Join-Path $example "mobile_preview"
$mobilePreviewBuild = Join-Path $mobilePreview "build\web"
$embeddedMobilePreview = Join-Path $example "web\mobile_preview"

function Invoke-Step {
  param(
    [string]$Name,
    [string]$WorkingDirectory,
    [scriptblock]$Command
  )

  Write-Host ""
  Write-Host "==> $Name" -ForegroundColor Cyan
  Push-Location $WorkingDirectory
  try {
    & $Command
  } finally {
    Pop-Location
  }
}

if (-not (Test-Path $Flutter)) {
  throw "Flutter executable not found: $Flutter"
}

Invoke-Step "Root pub get" $root { & $Flutter pub get }
Invoke-Step "Root analyze" $root { & $Flutter analyze }
Invoke-Step "Root test" $root { & $Flutter test }

if (-not $SkipPublishDryRun) {
  Invoke-Step "Pub publish dry run" $root { & $Flutter pub publish --dry-run }
}

Invoke-Step "Example pub get" $example { & $Flutter pub get }
Invoke-Step "Example analyze" $example { & $Flutter analyze }
Invoke-Step "Example test" $example { & $Flutter test }

Invoke-Step "Mobile preview pub get" $mobilePreview { & $Flutter pub get }
Invoke-Step "Mobile preview analyze" $mobilePreview { & $Flutter analyze }
Invoke-Step "Mobile preview test" $mobilePreview { & $Flutter test }

if (-not $SkipBuild) {
  Invoke-Step "Build mobile preview web" $mobilePreview {
    & $Flutter build web --base-href /mobile_preview/ --pwa-strategy=none
  }

  if (Test-Path $embeddedMobilePreview) {
    Remove-Item -LiteralPath $embeddedMobilePreview -Recurse -Force
  }
  New-Item -ItemType Directory -Force -Path $embeddedMobilePreview | Out-Null
  Copy-Item -Path (Join-Path $mobilePreviewBuild "*") -Destination $embeddedMobilePreview -Recurse -Force

  Invoke-Step "Build docs web" $example { & $Flutter build web --pwa-strategy=none }
}

Write-Host ""
Write-Host "Quality check completed." -ForegroundColor Green
