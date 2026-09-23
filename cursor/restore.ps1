[CmdletBinding()]
param(
    [switch]$SkipExtensions
)

$ErrorActionPreference = "Stop"

$CursorUserDir = Join-Path $env:APPDATA "Cursor\User"
$CursorHome = Join-Path $env:USERPROFILE ".cursor"
$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupDir = Join-Path $env:USERPROFILE "CursorConfigBackups\$Timestamp"

if (Get-Process Cursor -ErrorAction SilentlyContinue) {
    Write-Warning "Cursor 正在运行。建议关闭全部 Cursor 窗口后再继续。"
}

New-Item $BackupDir -ItemType Directory -Force | Out-Null
New-Item $CursorUserDir -ItemType Directory -Force | Out-Null
New-Item $CursorHome -ItemType Directory -Force | Out-Null

foreach ($FileName in @("settings.json", "keybindings.json")) {
    $CurrentFile = Join-Path $CursorUserDir $FileName
    if (Test-Path $CurrentFile) {
        Copy-Item $CurrentFile (Join-Path $BackupDir $FileName) -Force
    }

    $SharedFile = Join-Path $PSScriptRoot $FileName
    if (Test-Path $SharedFile) {
        Copy-Item $SharedFile $CurrentFile -Force
    }
}

$CurrentSnippets = Join-Path $CursorUserDir "snippets"
$SharedSnippets = Join-Path $PSScriptRoot "snippets"
if (Test-Path $CurrentSnippets) {
    Copy-Item $CurrentSnippets (Join-Path $BackupDir "snippets") -Recurse
}
if (Test-Path $SharedSnippets) {
    if (Test-Path $CurrentSnippets) {
        Remove-Item $CurrentSnippets -Recurse -Force
    }
    Copy-Item $SharedSnippets $CurrentSnippets -Recurse
}

$CurrentRules = Join-Path $CursorHome "rules"
$SharedRules = Join-Path $PSScriptRoot "rules"
if (Test-Path $CurrentRules) {
    Copy-Item $CurrentRules (Join-Path $BackupDir "rules") -Recurse
}
if (Test-Path $SharedRules) {
    if (Test-Path $CurrentRules) {
        Remove-Item $CurrentRules -Recurse -Force
    }
    Copy-Item $SharedRules $CurrentRules -Recurse
}

if (-not $SkipExtensions) {
    if (-not (Get-Command cursor -ErrorAction SilentlyContinue)) {
        throw "未找到 cursor 命令，无法安装扩展。可使用 -SkipExtensions 跳过。"
    }

    $ExtensionsFile = Join-Path $PSScriptRoot "extensions.txt"
    foreach ($Extension in Get-Content $ExtensionsFile) {
        $Extension = $Extension.Trim()
        if ($Extension) {
            & cursor --install-extension $Extension
            if ($LASTEXITCODE -ne 0) {
                Write-Warning "扩展安装失败：$Extension"
            }
        }
    }
}

Write-Host "Cursor 配置恢复完成。原配置备份在：$BackupDir"
Write-Host "请重新启动 Cursor，并单独配置本机专属的服务地址和登录凭据。"
