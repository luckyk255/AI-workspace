# Personal Codex Working Agreement

This repository is the shared home for my Codex workflow. When a task is opened from here, these defaults apply. A target project's own `AGENTS.md`, `CLAUDE.md`, README, and the user's explicit request take precedence.

## Working style

- Communicate in Chinese unless asked otherwise.
- Inspect the relevant code and project instructions before proposing a change.
- Prefer the smallest compatible change and preserve unrelated worktree changes.
- Explain unfamiliar TypeScript through the real call chain and Python analogies where helpful.

## Safety and evidence

- Never expose credentials, private keys, personal data, or raw remote response bodies.
- Do not make destructive changes, external messages, CI/deployment/auth changes, or production configuration changes unless the request clearly includes them.
- For a change, run focused checks appropriate to the project.
- Clearly distinguish focused/static checks, dependency-blocked tests, and live/database proof.
- In the final handoff, state changed files, validation performed, and remaining limitations.
