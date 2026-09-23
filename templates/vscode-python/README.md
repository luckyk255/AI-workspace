# Python 项目 VS Code 模板

这是可提交、可复制的项目级 `.vscode` 基线，不会被 VS Code 自动应用到其他项目。

新项目需要时，在项目根目录执行：

```powershell
Copy-Item C:\Users\k\git-repo\AI-workspace\templates\vscode-python\.vscode .\.vscode -Recurse
```

复制后，在项目自身 `.vscode/settings.json` 增加解释器路径、工作目录、`PYTHONPATH` 等项目差异；在 `launch.json` 增加模块名、端口和启动参数。不要把这些项目差异写回此模板。

模板包括：

- Code Runner 在终端运行并清理旧输出；
- 编辑器缩略图与 Markdown 双向滚动；
- 使用当前项目解释器运行当前 Python 文件的任务。
