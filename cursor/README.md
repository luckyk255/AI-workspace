# Cursor 公共项目配置与跨电脑偏好

此目录保存可提交到 Git 仓库的公共项目 `.vscode` 模板，以及可跨电脑同步的 Cursor 偏好：

- `.vscode/`：可直接复制到新项目根目录的公共项目配置
- `keybindings.json`：快捷键
- `extensions.txt`：扩展 ID，不锁定版本
- `rules/`：本地 Cursor 用户规则
- `backup.ps1`、`restore.ps1`：同步快捷键、代码片段、规则和扩展

不会同步 Cursor 用户 `settings.json`、扩展二进制、缓存、工作区状态、账号登录、令牌或密码。

## 新项目使用公共 `.vscode`

对于尚未创建 `.vscode` 的新项目，在项目根目录执行：

```powershell
Copy-Item C:\Users\k\git-repo\AI-workspace\cursor\.vscode .\.vscode -Recurse
```

模板包括 Code Runner、编辑器缩略图、Markdown 双向滚动，以及运行当前 Python 文件的任务。已有 `.vscode` 的项目请合并需要的键，避免覆盖已有项目配置。

`launch.json`、解释器路径、工作目录、`PYTHONPATH`、模块名和端口始终由项目自己维护；项目设置会优先于用户设置。

## 当前电脑更新仓库

关闭 Cursor 后，在 PowerShell 中运行，可更新快捷键、代码片段、规则和扩展清单：

```powershell
cd C:\Users\k\git-repo\AI-workspace
.\cursor\backup.ps1
git diff -- cursor
```

确认差异不包含敏感信息后，再自行提交和推送。

当前远程仓库是公开仓库；提交前仍需人工确认差异不含敏感信息。

## 新电脑恢复

先安装 Cursor、Git，并克隆此仓库，然后关闭 Cursor：

```powershell
cd C:\Users\k\git-repo\AI-workspace
.\cursor\restore.ps1
```

不安装扩展：

```powershell
.\cursor\restore.ps1 -SkipExtensions
```

恢复前，脚本会把目标电脑原配置备份到：

```text
%USERPROFILE%\CursorConfigBackups\<时间戳>\
```

恢复后重新启动 Cursor，并重新登录各扩展。Cursor 用户设置和自定义 AI 服务地址等本机配置需要单独填写。

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
