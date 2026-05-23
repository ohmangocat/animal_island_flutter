param(
  [Parameter(Mandatory = $true)]
  [ValidatePattern('^\d+\.\d+\.\d+([+-][0-9A-Za-z.-]+)?$')]
  [string]$Version,

  [string]$Flutter = "C:\Dev\tools\flutter_3.41.0\bin\flutter.bat",

  [string]$Date = (Get-Date -Format "yyyy-MM-dd"),

  [string]$PubHostedUrl = "https://pub.dev",

  [string[]]$Changes = @(),

  [switch]$BuildDocs,
  [switch]$SkipChecks,
  [switch]$SkipDryRun,
  [switch]$Publish
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Read-TextFile {
  param([string]$Path)
  return [System.IO.File]::ReadAllText($Path)
}

function Write-TextFile {
  param(
    [string]$Path,
    [string]$Content
  )
  [System.IO.File]::WriteAllText($Path, $Content, $utf8NoBom)
}

function Get-NewLine {
  param([string]$Content)
  if ($Content.Contains("`r`n")) {
    return "`r`n"
  }
  return "`n"
}

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
    if ($LASTEXITCODE -ne 0) {
      throw "$Name failed with exit code $LASTEXITCODE"
    }
  } finally {
    Pop-Location
  }
}

function Invoke-PubHostedStep {
  param([scriptblock]$Command)

  $previousPubHostedUrl = [Environment]::GetEnvironmentVariable("PUB_HOSTED_URL", "Process")
  try {
    if ($PubHostedUrl) {
      $env:PUB_HOSTED_URL = $PubHostedUrl
      Write-Host "PUB_HOSTED_URL=$PubHostedUrl"
    } else {
      Remove-Item Env:PUB_HOSTED_URL -ErrorAction SilentlyContinue
      Write-Host "PUB_HOSTED_URL cleared for this step"
    }

    & $Command
  } finally {
    if ($null -eq $previousPubHostedUrl) {
      Remove-Item Env:PUB_HOSTED_URL -ErrorAction SilentlyContinue
    } else {
      $env:PUB_HOSTED_URL = $previousPubHostedUrl
    }
  }
}

function Update-PubspecVersion {
  $path = Join-Path $root "pubspec.yaml"
  $content = Read-TextFile $path
  $match = [regex]::Match($content, '(?m)^version:\s*(\S+)\s*$')
  if (-not $match.Success) {
    throw "Cannot find version in pubspec.yaml"
  }

  $script:PreviousVersion = $match.Groups[1].Value
  $content = [regex]::Replace(
    $content,
    '(?m)^version:\s*\S+\s*$',
    "version: $Version",
    1
  )
  Write-TextFile $path $content

  Write-Host "pubspec.yaml: $script:PreviousVersion -> $Version"
}

function Update-ReadmeVersions {
  $readmePaths = @(
    "README.md",
    "README.en.md",
    "example\README.md"
  )

  foreach ($relativePath in $readmePaths) {
    $path = Join-Path $root $relativePath
    if (-not (Test-Path $path)) {
      continue
    }

    $content = Read-TextFile $path
    $updated = $content

    if ($script:PreviousVersion) {
      $updated = $updated.Replace($script:PreviousVersion, $Version)
    }

    $updated = [regex]::Replace(
      $updated,
      '(animal_island_flutter:\s*\^)\d+\.\d+\.\d+([+-][0-9A-Za-z.-]+)?',
      { param($m) $m.Groups[1].Value + $Version }
    )
    $updated = [regex]::Replace(
      $updated,
      '(\^?)0\.1\.2',
      { param($m) $m.Groups[1].Value + $Version }
    )

    if ($updated -ne $content) {
      Write-TextFile $path $updated
      Write-Host "${relativePath}: dependency/version references updated"
    }
  }
}

function Update-Changelog {
  $path = Join-Path $root "CHANGELOG.md"
  if (-not (Test-Path $path)) {
    throw "CHANGELOG.md not found"
  }

  $content = Read-TextFile $path
  $newline = Get-NewLine $content
  $versionHeaderPattern = "(?m)^##\s+$([regex]::Escape($Version))(\s+-\s+.+)?\s*$"

  $normalized = [regex]::Replace(
    $content,
    "(?m)^## Unreleased[ \t]*\r?\n(?=##\s+)",
    "## Unreleased$newline$newline",
    1
  )

  if ([regex]::IsMatch($normalized, $versionHeaderPattern)) {
    if ($normalized -ne $content) {
      Write-TextFile $path $normalized
    }
    Write-Host "CHANGELOG.md: $Version section already exists"
    return
  }

  if ($Changes.Count -eq 0) {
    throw "CHANGELOG.md has no $Version section. Pass -Changes @('change 1', 'change 2') to create it."
  }

  $bullets = ($Changes | ForEach-Object { "- $_" }) -join $newline
  $section = "## $Version - $Date$newline$newline$bullets$newline$newline"
  $updated = [regex]::Replace(
    $normalized,
    "(?m)^## Unreleased\s*\r?\n(?:\r?\n)?",
    "## Unreleased$newline$newline$section",
    1
  )

  if ($updated -eq $normalized) {
    throw "Cannot find '## Unreleased' in CHANGELOG.md"
  }

  Write-TextFile $path $updated
  Write-Host "CHANGELOG.md: added $Version section"
}

if (-not (Test-Path $Flutter)) {
  throw "Flutter executable not found: $Flutter"
}

Update-PubspecVersion
Update-ReadmeVersions
Update-Changelog

if (-not $SkipChecks) {
  Invoke-Step "Flutter analyze" $root { & $Flutter analyze }
  Invoke-Step "Flutter test" $root { & $Flutter test }
}

if ($BuildDocs) {
  $buildDocs = Join-Path $root "tool\build_docs.ps1"
  Invoke-Step "Build docs and mobile preview" $root {
    powershell -ExecutionPolicy Bypass -File $buildDocs -Flutter $Flutter
  }
}

if (-not $SkipDryRun) {
  Invoke-Step "Pub publish dry run" $root {
    Invoke-PubHostedStep { & $Flutter pub publish --dry-run }
  }
}

if ($Publish) {
  Invoke-Step "Pub publish" $root {
    Invoke-PubHostedStep { & $Flutter pub publish --force }
  }
} else {
  Write-Host ""
  Write-Host "Dry-run flow completed. Re-run with -Publish to publish to pub.dev." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Release script completed for version $Version." -ForegroundColor Green
