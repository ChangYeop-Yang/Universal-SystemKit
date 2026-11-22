# 🤝 Contributing to Universal SystemKit

[![Pull request checklist](https://img.shields.io/badge/Pull%20request-Checklist-1a7f37)](#-open-a-pull-request)
[![Code review guide](https://img.shields.io/badge/Code%20review-Guide-0969da)](#-give-and-respond-to-code-reviews)

Bug reports, fixes, and documentation updates are welcome. Keep discussions respectful and focus feedback on the change. Read the [repository development rules](AGENTS.md) before editing files.

## 🐛 Report a bug or suggest a change

Search [open and closed issues](https://github.com/ChangYeop-Yang/Universal-SystemKit/issues?q=is%3Aissue) first. If a report already exists, add new details there. Otherwise, open an issue with the following information.

- The library product (`SystemKit` or `SystemKit_Objc`), the API you used, and the package version or commit.
- The Apple platform and OS version, whether you used a device or simulator, and your Xcode and Swift versions.
- The shortest steps or Swift sample that reproduce the problem, followed by what you expected and what happened. Include relevant error messages or logs with private data removed.

For a feature request, describe the use case and how it would help package users. Discuss public API changes, new dependencies, or changes that affect existing callers in an issue before starting a pull request.

Report suspected vulnerabilities privately. For the reporting address, the response time, and guidance on sharing evidence, see the [security policy](SECURITY.md).

## 🛠️ Set up the Swift package

Use macOS with Xcode, Swift 5.9 or later, and the SDKs for the platforms you plan to build. [Package.swift](Package.swift) lists the minimum Swift tools and OS versions. The two library products live in [Sources](Sources) and [ObjcSources](ObjcSources). Usage guides live in [Document](Document).

Fork the repository on GitHub, replace `YOUR-USERNAME` with your GitHub username, and run these commands.

```bash
git clone https://github.com/YOUR-USERNAME/Universal-SystemKit.git
cd Universal-SystemKit
git switch -c fix/short-description
xcodebuild -version
swift --version
swift build -v
```

## ✅ Check your changes

- Run `swift build -v` again after the final code change. For a bug fix, run the same example before and after the change to show that the fix works.
- Install [SwiftLint 0.65.1](https://github.com/realm/SwiftLint/releases/tag/0.65.1) to match [CI](.github/workflows/swiftlint.yml). Run `swiftlint lint --config .swiftlint.yml` from the repository root. The [shared lint policy](.swiftlint.yml) sets the rules, file exclusions, and severity for both local runs and CI. Review warnings and fix findings introduced by your change.
- For a change to a package product, dependency, or public API, run the same consumer check used in [CI](.github/workflows/swift.yml). It builds and runs a separate release executable that imports both products.

```bash
RUNNER_TEMP="${TMPDIR:-/tmp}" bash .github/scripts/smoke-test-swift-package.sh
```

- For changes that affect hardware or permissions, check the behavior on a supported device when available. The [Apple platform workflow](.github/workflows/apple-platforms.yml) builds both products for macOS and the iOS, visionOS, tvOS, and watchOS simulators.

## ✍️ Write a commit message

Keep each commit focused on one change. Start the title with an action verb and name the behavior, API, or file that changed. Use the category that best matches the purpose of the commit to choose what to include in the message.

| Category | When to use it | Example title | What to explain in the body |
| --- | --- | --- | --- |
| Feature | Add a capability that callers can use. | Add file monitoring for renamed files | Describe the use case, the public API, and the supported platforms. |
| Bug fix | Correct behavior that callers already expect. | Fix duplicate file change notifications | Give the steps that trigger the bug, the cause, and the result after the fix. |
| Performance | Reduce time, memory use, or other resource costs. | Reduce allocations when reading process data | Describe the workload and report measurements taken before and after the change. |
| Refactor | Change how existing code is organized. | Share CPU usage calculations between process helpers | Explain why the new structure helps and how you checked that callers see the same behavior. |
| Tests | Add or update checks for package behavior. | Check both library imports in the consumer test | Name the case covered and the regression it would catch. |
| Package or dependency | Change the SwiftPM manifest, dependencies, or deployment targets. | Raise the minimum macOS version to 11 | Give the reason, affected versions, and any steps package users need to take. |
| CI | Change how GitHub Actions builds or checks the package. | Add a watchOS simulator build | Identify the workflow, when it runs, and how you verified the changed step. |
| Documentation | Update a guide, example, or API reference. | Document the SwiftPM consumer check | Explain what the reader can now do and how you checked the instructions. |

A short title can stand on its own for a small, obvious change. When a reviewer needs more context, leave a blank line after the title and add a body. Include the checks you actually ran. If a change breaks a public API, name the old and new calls and explain how to update existing code. Add an issue reference such as `Refs #123` when relevant.

<details>
<summary>View a complete example commit message</summary>

```text
Document commit titles and bodies for SwiftPM changes

Add examples for changes to package products, dependencies, and CI.
Each example shows what a reviewer needs to know about the change.
```

</details>

## 📬 Open a pull request

Update the relevant usage guide if the public API or setup steps change. Once the work and checks are complete, record the final change under **Unreleased** in [CHANGELOG.md](CHANGELOG.md).

- [ ] Push your branch to your fork and open a pull request against `main`. Keep it focused on one change.
- [ ] Explain what changed and why. Link the issue if there is one, and list the commands and Apple platforms you checked. Include any steps you could not verify.
- [ ] Review the GitHub Actions results on the pull request. Address failed checks, review SwiftLint warnings, and reply to review comments.

Changes to `AGENTS.md` follow its [review rules](AGENTS.md#-change-this-guide).

## 🔎 Give and respond to code reviews

**As an author**, read your diff before requesting review. Point reviewers to the public API, platform, or behavior that needs the closest look. If a check ran only on a simulator, say so in the pull request.

**As a reviewer**, describe what the code does and how it affects a caller. Refer to a specific line, test result, or documented SDK requirement. Ask a question when the intent is unclear. Keep the discussion respectful. Personal attacks, ridicule, and assumptions about a contributor's ability have no place in a review.

| GitHub review | When to use it | Example feedback |
| --- | --- | --- |
| Comment | Ask a question or offer an optional improvement. Mark personal preferences as optional. | “Optional suggestion: Could the example show which queue receives the callback?” |
| Request changes | Identify a problem that needs a fix before merge. Explain how to verify the fix. | “This call requires iOS 16, and the package supports iOS 13. Please add an availability check and exercise the fallback on a supported OS version.” |
| Approve | Use this when you have reviewed the change and your concerns about merging it are resolved. | “I verified that the release consumer imports both products after the manifest change.” |

**During follow-up**, reply in the original thread with the fix and its check, or explain why a different approach meets the requirement. If you disagree, compare the options against the expected behavior. Ask a maintainer for a decision when a trade-off remains open, and record that decision in the pull request. Resolve the thread once the concern is addressed and request another review after pushing the fix.

Further reading includes [GitHub's pull request review guide](https://docs.github.com/en/pull-requests/how-tos/review-pull-requests/reviewing-proposed-changes-in-a-pull-request) and [Google's guide to review comments](https://github.com/google/eng-practices/blob/master/review/reviewer/comments.md).

---

> **Copyright © 2026 Universal SystemKit.** All rights reserved.
