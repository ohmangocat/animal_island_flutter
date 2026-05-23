param(
  [string]$Flutter = "C:\Dev\tools\flutter_3.41.0\bin\flutter.bat",
  [string]$DocsBaseHref = "/",
  [string]$MobilePreviewBaseHref = "/mobile_preview/"
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$example = Join-Path $root "example"
$mobilePreview = Join-Path $example "mobile_preview"
$mobilePreviewBuild = Join-Path (Join-Path $mobilePreview "build") "web"
$embeddedMobilePreview = Join-Path (Join-Path $example "web") "mobile_preview"

function Normalize-BaseHref {
  param([string]$BaseHref)

  if (-not $BaseHref) {
    return "/"
  }

  $normalized = $BaseHref.Trim()
  if (-not $normalized.StartsWith("/")) {
    $normalized = "/$normalized"
  }
  if (-not $normalized.EndsWith("/")) {
    $normalized = "$normalized/"
  }

  return $normalized
}

if (-not (Test-Path $Flutter) -and -not (Get-Command $Flutter -ErrorAction SilentlyContinue)) {
  throw "Flutter executable not found: $Flutter"
}

$DocsBaseHref = Normalize-BaseHref $DocsBaseHref
$MobilePreviewBaseHref = Normalize-BaseHref $MobilePreviewBaseHref

Write-Host "Docs base href: $DocsBaseHref"
Write-Host "Mobile preview base href: $MobilePreviewBaseHref"

Push-Location $mobilePreview
try {
  & $Flutter pub get
  & $Flutter build web --base-href $MobilePreviewBaseHref --pwa-strategy=none
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
  & $Flutter build web --base-href $DocsBaseHref --pwa-strategy=none
} finally {
  Pop-Location
}

Write-Host "Docs build completed." -ForegroundColor Green
