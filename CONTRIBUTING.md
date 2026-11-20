# 🤝 Contributing to Universal SystemKit

[![Swift package build status](https://img.shields.io/github/actions/workflow/status/ChangYeop-Yang/Universal-SystemKit/swift.yml?branch=main&label=Swift%20build)](https://github.com/ChangYeop-Yang/Universal-SystemKit/actions/workflows/swift.yml)

Bug reports, fixes, and documentation updates are welcome. Keep discussions respectful and focus feedback on the change. Read the [repository development rules](AGENTS.md) before editing files.

## 🐛 Report a bug or suggest a change

Search [open and closed issues](https://github.com/ChangYeop-Yang/Universal-SystemKit/issues?q=is%3Aissue) first. If a report already exists, add new details there. Otherwise, open an issue with the following information.

- The library product (`SystemKit` or `SystemKit_Objc`), the API you used, and the package version or commit.
- The Apple platform and OS version, whether you used a device or simulator, and your Xcode and Swift versions.
- The shortest steps or Swift sample that reproduce the problem, followed by what you expected and what happened. Include relevant error messages or logs with private data removed.

For a feature request, describe the use case and how it would help package users. Discuss public API changes, new dependencies, or changes that affect existing callers in an issue before starting a pull request.

Keep vulnerability details out of public issues and pull requests. If **Report a vulnerability** is available on the [Security tab](https://github.com/ChangYeop-Yang/Universal-SystemKit/security), use it to send a private report.

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
- Install [SwiftLint](https://github.com/realm/SwiftLint) with `brew install swiftlint` if needed. Run `swiftlint lint --lenient --reporter github-actions-logging Package.swift Sources` from the repository root to match [CI](.github/workflows/swiftlint.yml). Review its warnings and fix findings introduced by your change.
- For a change to a package product, dependency, or public API, run the same consumer check used in [CI](.github/workflows/swift.yml). It builds and runs a separate release executable that imports both products.

```bash
RUNNER_TEMP="${TMPDIR:-/tmp}" bash .github/scripts/smoke-test-swift-package.sh
```

- For changes that affect hardware or permissions, check the behavior on a supported device when available. The [Apple platform workflow](.github/workflows/apple-platforms.yml) builds both products for macOS and the iOS, visionOS, tvOS, and watchOS simulators.

## 📬 Open a pull request

Update the relevant usage guide if the public API or setup steps change. Once the work and checks are complete, record the final change under **Unreleased** in [CHANGELOG.md](CHANGELOG.md).

1. Push your branch to your fork and open a pull request against `main`. Keep it focused on one change.
2. Explain what changed and why. Link the issue if there is one, and list the commands and Apple platforms you checked. Include any steps you could not verify.
3. Review the GitHub Actions results on the pull request. Address failed checks, review SwiftLint warnings, and reply to review comments.

Changes to `AGENTS.md` follow its [review rules](AGENTS.md#-change-this-guide).

---

> **Copyright © 2026 Universal SystemKit.** All rights reserved.
