# Universal SystemKit development guidelines

These rules apply throughout the repository, including the SystemKit Swift library, the SystemKit_Objc library, and their build workflows.

## Protect project files

Stop work immediately if an operation would seriously damage the project, including deleting project source code or documentation. Leave the files in place and report the operation and its likely impact. This rule applies even when you have permission to perform the operation.

## Write for readers

- Write every README.md below the repository root in US English. The root README.md is exempt from this language rule.
- Write all source code comments in US English. Use common, TOEIC-level words in comments and English README files. Keep exact API names and technical terms when readers need them.
- Proofread documentation and comments for spelling, grammar, and meaning. Use natural sentences that a teammate can follow. Remove repeated phrases, filler, and stock wording associated with AI-generated text.
- Use comments to explain a decision, a platform limit, or behavior that a reader could easily miss.

## Develop for Apple platforms

- Before choosing an API, check Context7 or the latest official developer documentation. Use the current supported API and verify its signature and availability for the platforms you are changing.
- Read the deployment targets in Package.swift. When a newer API requires a later OS, use an availability check and provide a working path for older supported systems. Use a platform or import check for features limited to a particular SDK. [Swift availability checks](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/controlflow/#Checking-API-Availability)
- Review public API names at the call site. Choose names that make the operation and its arguments clear. Consider existing callers of both package products when changing public types or methods. [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/)
- Check existing code before adding a helper or type. Reuse shared logic and avoid duplicate implementations. Choose data structures based on how the code reads, updates, and orders values. Use a design pattern when it simplifies the problem or makes behavior easier to test.

## Validate and finish

1. Apply SwiftLint to every Swift source file, including Package.swift. Run the check defined in [.github/workflows/swiftlint.yml](.github/workflows/swiftlint.yml). If you add Swift sources outside its current paths, include them in the lint check. Review findings and fix issues introduced by your change.
2. A successful build of the final revision is required before development work is complete. Run `swift build -v` on macOS with Xcode, or verify the build for that commit on the GitHub macOS runner. When a required build fails, inspect its log, fix the cause, and run it again.
3. Verify the Apple platform builds affected by the change. For package product or public API changes, also check the SwiftPM consumer step. It builds and runs a separate release executable that imports both libraries. [Swift workflow](.github/workflows/swift.yml) and [Apple platform builds](.github/workflows/apple-platforms.yml)
4. Remove all temporary files and directories created by your task. Check their paths and ownership before cleanup. Preserve existing user files, project sources, and documentation. Review the final diff and `git status --short` for unexpected changes.
