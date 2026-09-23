# Cursor 跨电脑配置

此目录保存经过脱敏、可提交到 Git 仓库的 Cursor 配置：

- `settings.json`：共享用户设置
- `keybindings.json`：快捷键
- `extensions.txt`：扩展 ID，不锁定版本
- `rules/`：本地 Cursor 用户规则
- `backup.ps1`：从当前电脑更新共享配置
- `restore.ps1`：在当前电脑恢复共享配置

不会同步扩展二进制、缓存、工作区状态、账号登录、令牌或密码。

## 用户配置与项目配置的边界

编辑器外观、自动保存、Markdown 预览、Code Runner 等通用偏好保存在这里的
`settings.json`。项目的 `.vscode/launch.json`、`.vscode/tasks.json` 以及
Python 模块名、端口、环境变量等项目配置，应由各项目自己的 Git 仓库同步。
需要一个可复制的项目级 `.vscode` 基线时，使用
[`templates/vscode-python`](../templates/vscode-python/)；它不是自动继承机制，
项目复制后自行维护其运行差异。项目设置会优先于用户设置。

## 当前电脑更新仓库

关闭 Cursor 后，在 PowerShell 中运行：

```powershell
cd C:\Users\k\git-repo\AI-workspace
.\cursor\backup.ps1
git diff -- cursor
```

确认差异不包含敏感信息后，再自行提交和推送。

备份脚本会自动排除 `cursor.openAIBaseURL`，并在发现名称包含
`apiKey`、`token`、`password`、`secret` 或 `credential` 的设置键时停止。
当前远程仓库是公开仓库；这只是基础防护，不能代替提交前人工检查。

## 新电脑恢复

先安装 Cursor、Git，并克隆此仓库，然后关闭 Cursor：

```powershell
cd C:\Users\k\git-repo\AI-workspace
.\cursor\restore.ps1
```

只恢复设置、不安装扩展：

```powershell
.\cursor\restore.ps1 -SkipExtensions
```

恢复前，脚本会把目标电脑原配置备份到：

```text
%USERPROFILE%\CursorConfigBackups\<时间戳>\
```

恢复后重新启动 Cursor，并重新登录各扩展。自定义 AI 服务地址等本机配置需要单独填写。

## 日常同步

旧电脑：

```powershell
git pull --ff-only
.\cursor\backup.ps1
git diff -- cursor
git add cursor
git commit -m "chore: update Cursor config"
git push
```

新电脑：

```powershell
git pull --ff-only
.\cursor\restore.ps1
```
