# 📘 Universal SystemKit development guidelines

[![Codex workflow guide](https://img.shields.io/badge/Codex-Workflow-0969da)](#-work-with-codex)
[![Final validation checklist](https://img.shields.io/badge/Validation-Final%20checklist-1a7f37)](#-validate-and-finish)

These rules apply throughout the repository, including the SystemKit Swift library, the SystemKit_Objc library, and their build workflows.

## 🔒 Change this guide

Repository administrators may commit and push changes to `AGENTS.md` directly to `main`. A change made on an administrator's behalf may go directly to `main` only when the administrator explicitly requests it.

Other contributors must propose changes to `AGENTS.md` in a pull request. A repository administrator must approve the pull request before it is merged.

## 🛡️ Protect project files

> [!CAUTION]
> Stop work immediately if an operation would seriously damage the project, including deleting project source code or documentation. Leave the files in place and report the operation and its likely impact. This rule applies even when you have permission to perform the operation.

## 📝 Write for readers

- Include the copyright notice shown at the end of this guide in every project source file and document you write or update. Set the year to the current calendar year whenever you write or update the file. Use a comment in source code and place the notice at the very end of documentation.
- In Markdown documents, put a horizontal rule above the footer. Include only the copyright notice in the blockquote and bold its first sentence.
- Write every README.md below the repository root in US English. The root README.md is exempt from this language rule.
- Write all source code comments in US English. Use common, TOEIC-level words in comments and English README files. Keep exact API names and technical terms when readers need them.
- Proofread documentation and comments for spelling, grammar, and meaning. Use natural sentences that a teammate can follow. Remove repeated phrases, filler, and stock wording associated with AI-generated text.
- Place relevant Shields.io badges just below the title. Use a custom badge for a shortcut to a key section or action. Use a live badge when its status is part of the document's purpose. Give each badge descriptive alt text and link it to the matching section, action, or source. [Shields.io](https://shields.io/)
- Use a few familiar emojis in Markdown headings or status labels to help readers scan the page. Pair each icon with clear text so readers can understand the document without the icon.
- Use comments to explain a decision, a platform limit, or behavior that a reader could easily miss.

## 🧭 Plan and scope changes

- **Make uncertainty clear.** Read the relevant code and its callers. State assumptions that could affect the result and ask for clarification when an open question changes behavior, compatibility, or scope.
- **Explain important choices.** When several approaches fit the request, explain the trade-offs that matter and why the chosen approach fits. Point out a simpler option when it meets the same requirements.
- **Keep one-time logic simple.** Keep code at its call site when it is easy to read there. Add a helper or type only when it makes the code easier to understand, test, or reuse in the current change.
- **Add only the options the task needs.** Limit new settings, extension points, and API options to the current requirements.
- **Handle failures that can occur.** Cover invalid inputs and real failures such as denied permissions or unavailable APIs. Base extra error handling on conditions that can occur on supported platforms.
- **Leave unrelated code alone.** Keep edits tied to the request. Preserve nearby code, comments, formatting, and work already in progress. Clean up imports, variables, or helpers that your change makes unused.
- **Refactor only when the task calls for it.** Preserve working code unless restructuring is part of the request or needed for the fix. When refactoring, run the same checks before and after to verify the behavior that should stay the same.
- **Follow the existing style.** Match the names, layout, and conventions used in the surrounding code and follow the project's SwiftLint rules.
- **Define success and verify it.** Set clear checks before making changes. For work with several steps, pair each step with a check. Reproduce bugs before fixing them when possible, then repeat the same check. Fix issues found during verification and rerun the affected checks. Report any check you could not run.

## 🤖 Work with Codex

| Situation | Codex guidance |
| --- | --- |
| Starting a session | Start in the package root for work across both products. Codex collects project instructions from the repository root down to its working directory. Within each directory, a nonempty `AGENTS.override.md` takes precedence over `AGENTS.md`. Before editing a deeper directory, check it for instructions that apply there. [Instruction discovery](https://developers.openai.com/codex/guides/agents-md) |
| A command needs more access | In the interactive CLI, use `/status` to inspect the session configuration. If a required command exceeds the active sandbox permissions, use the configured approval process and explain what access that command needs. [Sandbox and approvals](https://developers.openai.com/codex/security) |
| Reviewing a change in the CLI | Use `/diff` to inspect changes, including new files. For a requested code review, use `/review` and check each finding against the affected code and callers. Verify Apple builds on macOS as described below. [CLI commands](https://developers.openai.com/codex/cli/slash-commands) |
| Running an automated check | For a read-only task, such as summarizing changes to the package manifest, use `codex exec --sandbox read-only`. If a script consumes the result, use `--output-schema` for a structured final response or `--json` for a stream of events. [Non-interactive mode](https://developers.openai.com/codex/noninteractive) |

## 🍎 Develop for Apple platforms

- Before choosing an API, check Context7 or the latest official developer documentation. Use the current supported API and verify its signature and availability for the platforms you are changing.
- Read the deployment targets in Package.swift. When a newer API requires a later OS, use an availability check and provide a working path for older supported systems. Use a platform or import check for features limited to a particular SDK. [Swift availability checks](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/controlflow/#Checking-API-Availability)
- Review public API names at the call site. Choose names that make the operation and its arguments clear. Consider existing callers of both package products when changing public types or methods. [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/)
- Check existing code before adding a helper or type. Reuse shared logic and avoid duplicate implementations. Choose data structures based on how the code reads, updates, and orders values. Use a design pattern when it simplifies the problem or makes behavior easier to test.
- Protect shared state with a clear owner, such as an actor, a serial queue, or a lock. When changing a timer, file monitor, or other background task, review how it starts, stops, and releases its resources. Explain how access is kept safe if you use `@unchecked Sendable`. [Swift concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/) and [Swift Sendable proposal](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0302-concurrent-value-and-concurrent-closures.md)
- When changing access to file timestamps, disk space, user defaults, or another API that requires a reason, review [Sources/SystemKit/PrivacyInfo.xcprivacy](Sources/SystemKit/PrivacyInfo.xcprivacy). Use an Apple reason code that matches what the library actually does and keep the manifest in the SwiftPM resources. [Apple required reason APIs](https://developer.apple.com/documentation/bundleresources/describing-use-of-required-reason-api)

## 📦 Maintain dependencies and workflows

- When you change a SwiftPM dependency, check its release notes, minimum Swift version, and supported OS versions. Review the version range in Package.swift and verify that a fresh consumer can resolve and build the package. Flag incompatible changes to either public product so the release version can reflect them. [SwiftPM dependency rules](https://github.com/swiftlang/swift-package-manager/blob/main/Sources/Runtimes/PackageDescription/PackageDependency.swift) and [Semantic Versioning](https://semver.org/)
- Give each GitHub Actions job only the permissions it needs. Store credentials in GitHub Actions secrets and keep sensitive values out of logs, summaries, and artifacts. Pass event values such as pull request titles to shell steps through environment variables and quote the variables when using them. [GitHub Actions secure use](https://docs.github.com/en/actions/reference/security/secure-use)

## ✅ Validate and finish

- [ ] Apply SwiftLint to every Swift source file, including Package.swift. Run the check defined in [.github/workflows/swiftlint.yml](.github/workflows/swiftlint.yml). If you add Swift sources outside its current paths, include them in the lint check. Review findings and fix issues introduced by your change.
- [ ] A successful build of the final revision is required before development work is complete. Run `swift build -v` on macOS with Xcode, or verify the build for that commit on the GitHub macOS runner. When a required build fails, inspect its log, fix the cause, and run it again.
- [ ] Verify the Apple platform builds affected by the change. When a fix changes behavior, run a check that would have caught the original problem. Check behavior that depends on device hardware or system permissions on a supported device when one is available, and report what you verified. For package product or public API changes, also check the SwiftPM consumer step. It builds and runs a separate release executable that imports both libraries. [Swift workflow](.github/workflows/swift.yml) and [Apple platform builds](.github/workflows/apple-platforms.yml)
- [ ] Remove all temporary files and directories created by your task. Check their paths and ownership before cleanup. Preserve existing user files, project sources, and documentation. Review the final diff and `git status --short` for unexpected changes.
- [ ] Update `CHANGELOG.md` at the end of every task. Wait until all work and checks are complete, then record the final changes under `Unreleased`.

---

> **Copyright © 2026 Universal SystemKit.** All rights reserved.
