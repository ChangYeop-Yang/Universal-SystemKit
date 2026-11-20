# 📘 Claude Code project instructions

[![Read the shared rules in AGENTS.md](https://img.shields.io/badge/Shared%20rules-AGENTS.md-0969da)](AGENTS.md)
[![Claude Code settings and file locations](https://img.shields.io/badge/Claude%20Code-Settings-8250df)](#%EF%B8%8F-keep-settings-in-the-right-place)

@AGENTS.md

> [!IMPORTANT]
> You must read and follow the root `AGENTS.md` before starting any work in this repository. If the import is unavailable, open the file directly. If you cannot read it, stop and report the problem.

## 🧭 Plan the work

- In an interactive session, use `/context all` and check **Memory files** if you need to confirm that the project instructions loaded. [Claude Code memory](https://code.claude.com/docs/en/memory#how-claudemd-files-load)
- Use Plan Mode when a change crosses Apple platforms or affects a public API and the approach needs review. Use the plan to identify affected files and the checks that will show the change works. Proceed directly with small, clear edits. [Claude Code best practices](https://code.claude.com/docs/en/best-practices)

## 🧠 Keep track of the task

- Keep the current task, user decisions, changed files, and remaining checks when using `/compact` in a long session. Use `/clear` between unrelated tasks. [Claude Code commands](https://code.claude.com/docs/en/commands)
- If you use an Explore or Plan subagent, include the relevant repository rules in its task. Check its findings against the files before relying on them. [Claude Code subagents](https://code.claude.com/docs/en/sub-agents)

## ⚙️ Keep settings in the right place

| What you need to store | Where it belongs |
| --- | --- |
| Personal instructions | Keep them in `CLAUDE.local.md` and leave the file out of commits. |
| Personal settings and saved approvals | Keep them in `.claude/settings.local.json` and leave the file out of commits. |
| Settings for the team | Use `.claude/settings.json` for settings the team intends to share. [Claude Code settings](https://code.claude.com/docs/en/settings) |
| Claude rules for specific paths | Use a `paths` filter in `.claude/rules/`. [Path-specific rules](https://code.claude.com/docs/en/memory#path-specific-rules) |
| Rules shared by all coding tools | Put them in the root [development guide](AGENTS.md). |

---

> **Copyright © 2026 Universal SystemKit.** All rights reserved.
