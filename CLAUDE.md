# 📘 Claude Code project instructions

[![Repository guide](https://img.shields.io/badge/Repository%20guide-AGENTS.md-blue)](AGENTS.md)

@AGENTS.md

You must read and follow the root `AGENTS.md` before starting any work in this repository. If the import is unavailable, open the file directly. If you cannot read it, stop and report the problem.

## 🧭 Plan the work

- In an interactive session, use `/context all` and check **Memory files** if you need to confirm that the project instructions loaded. [Claude Code memory](https://code.claude.com/docs/en/memory#how-claudemd-files-load)
- Use Plan Mode when a change crosses Apple platforms or affects a public API and the approach needs review. Use the plan to identify affected files and the checks that will show the change works. Proceed directly with small, clear edits. [Claude Code best practices](https://code.claude.com/docs/en/best-practices)

## 🧠 Keep track of the task

- Keep the current task, user decisions, changed files, and remaining checks when using `/compact` in a long session. Use `/clear` between unrelated tasks. [Claude Code commands](https://code.claude.com/docs/en/commands)
- If you use an Explore or Plan subagent, include the relevant repository rules in its task. Check its findings against the files before relying on them. [Claude Code subagents](https://code.claude.com/docs/en/sub-agents)

## ⚙️ Keep settings in the right place

- Keep personal instructions in `CLAUDE.local.md` and personal settings or saved approvals in `.claude/settings.local.json`. Keep both files out of commits. Use `.claude/settings.json` for settings the team intends to share. [Claude Code settings](https://code.claude.com/docs/en/settings)
- Put a Claude-specific rule in `.claude/rules/` with a `paths` filter when it applies to only part of the repository. Keep rules shared by all coding tools in `AGENTS.md`. [Path-specific rules](https://code.claude.com/docs/en/memory#path-specific-rules)
