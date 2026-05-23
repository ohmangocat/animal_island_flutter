param(
  [string]$Flutter = "C:\Dev\tools\flutter_3.41.0\bin\flutter.bat"
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$example = Join-Path $root "example"
$mobilePreview = Join-Path $example "mobile_preview"
$mobilePreviewBuild = Join-Path $mobilePreview "build\web"
$embeddedMobilePreview = Join-Path $example "web\mobile_preview"

if (-not (Test-Path $Flutter)) {
  throw "Flutter executable not found: $Flutter"
}

Push-Location $mobilePreview
try {
  & $Flutter pub get
  & $Flutter build web --base-href /mobile_preview/ --pwa-strategy=none
} finally {
  Pop-Location
}

if (Test-Path $embeddedMobilePreview) {
  Remove-Item -LiteralPath $embeddedMobilePreview -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $embeddedMobilePreview | Out-Null
Copy-Item -Path (Join-Path $mobilePreviewBuild "*") -Destination $embeddedMobilePreview -Recurse -Force

Push-Location $example
try {
  & $Flutter pub get
  & $Flutter build web --pwa-strategy=none
} finally {
  Pop-Location
}

Write-Host "Docs build completed." -ForegroundColor Green
