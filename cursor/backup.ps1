[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$CursorUserDir = Join-Path $env:APPDATA "Cursor\User"
$CursorHome = Join-Path $env:USERPROFILE ".cursor"
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

if (-not (Test-Path $CursorUserDir)) {
    throw "未找到 Cursor 用户配置目录：$CursorUserDir"
}

$KeybindingsSource = Join-Path $CursorUserDir "keybindings.json"
if (Test-Path $KeybindingsSource) {
    Copy-Item $KeybindingsSource (Join-Path $PSScriptRoot "keybindings.json") -Force
}

$SnippetsSource = Join-Path $CursorUserDir "snippets"
$SnippetsTarget = Join-Path $PSScriptRoot "snippets"
if (Test-Path $SnippetsTarget) {
    Remove-Item $SnippetsTarget -Recurse -Force
}
if (Test-Path $SnippetsSource) {
    Copy-Item $SnippetsSource $SnippetsTarget -Recurse
}

$RulesSource = Join-Path $CursorHome "rules"
$RulesTarget = Join-Path $PSScriptRoot "rules"
if (Test-Path $RulesTarget) {
    Remove-Item $RulesTarget -Recurse -Force
}
if (Test-Path $RulesSource) {
    Copy-Item $RulesSource $RulesTarget -Recurse
}

if (-not (Get-Command cursor -ErrorAction SilentlyContinue)) {
    throw "未找到 cursor 命令。请先在 Cursor 命令面板运行：Shell Command: Install 'cursor' command in PATH。"
}

$Extensions = @(& cursor --list-extensions) |
    Where-Object { $_ -and $_.Trim() } |
    ForEach-Object { $_.Trim().ToLowerInvariant() } |
    Sort-Object -Unique

if ($LASTEXITCODE -ne 0) {
    throw "读取 Cursor 扩展列表失败，退出码：$LASTEXITCODE"
}

[IO.File]::WriteAllLines(
    (Join-Path $PSScriptRoot "extensions.txt"),
    [string[]]$Extensions,
    $Utf8NoBom
)

Write-Host "Cursor 共享配置已更新：$PSScriptRoot"
Write-Host "提交前请运行 git diff 并确认没有敏感信息。"
