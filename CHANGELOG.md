# 📋 Changelog

[![Latest release](https://img.shields.io/github/v/release/ChangYeop-Yang/Universal-SystemKit?label=Latest%20release)](https://github.com/ChangYeop-Yang/Universal-SystemKit/releases/latest)

Copyright © 2026 Universal SystemKit. All rights reserved.

This file lists notable changes to Universal SystemKit. The format follows [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/). Release dates come from GitHub Releases.

## [Unreleased]

### Added

- Use `SKDispatchFileMonitor` to watch a file or folder for selected events, such as writes and deletions. Pass an event mask and a handler, then call `start()` and `stop()` to control monitoring. [File monitor guide](Document/SKDispatchFileMonitor.md)
- On macOS, use `SKSystemProcessResource` to look up a process by PID or list processes with details such as resident memory, virtual memory, and thread counts.
- Declared tvOS 13, watchOS 6, and visionOS 1 as SwiftPM deployment targets. CI checks these platforms with simulator builds. APIs such as `SKSystemProcessResource` remain limited to macOS.
- Added a SwiftPM consumer test that imports `SystemKit` and `SystemKit_Objc`, builds a release executable, and runs it. This checks that both products can be linked from a separate package. CI also runs SwiftLint, CodeQL for Swift, and the Xcode static analyzer for Objective-C++.
- Added an API reference report with the runner's Xcode and SDK versions, the package's minimum OS versions, and Context7 lookup results. The report includes links to official references when a lookup fails.
- Added repository development rules, Claude Code instructions, and a security reporting policy so contributors know how to work on the project and where to report a vulnerability. [Development rules](AGENTS.md) · [Claude Code instructions](CLAUDE.md) · [Security policy](SECURITY.md)

### Changed

- Raised the SwiftPM tools version from 5.4 to 5.9. Update the Swift toolchain before resolving this revision if your project still uses an older version.
- Added device names for iPhone 15, iPhone 15 Plus, iPhone 15 Pro, and iPhone 15 Pro Max to the model lookup.
- `SKDispatchTimer` now queues control changes asynchronously. Calls such as `suspend()`, `reschedule(interval:_:)`, and `cancel()` can return before the change takes effect.
- Renamed `SKResourceDataUnitType` to `SKResourceDataUnit` in the macOS CPU and memory APIs. Update references to the old type name when upgrading from 2.4.0.
- Moved GitHub Actions to hosted macOS 26 runners. Build summaries list which steps passed or failed and link to the full logs when available.
- Updated the development rules to require a changelog update after all work and checks for each task are complete. [Development rules](AGENTS.md)
- Added nine rules to the development guide for explaining assumptions and choices, keeping changes focused, and defining and running checks before marking work complete. [Development rules](AGENTS.md#-plan-and-scope-changes)
- Required a standard copyright notice in source files and documentation, with the year set to the current year when a file is written or updated. [Development rules](AGENTS.md#-write-for-readers)

## [2.4.0] - 2024-08-18

### Added

- Use `SKSystemResource` to read system memory, CPU use, and disk space on macOS. It provides separate calls for these measurements, including free and total space on the system volume.
- Added `SKDispatchTimer` for repeating work at a chosen interval. It provides controls to activate, suspend, resume, reschedule, or cancel the timer.
- Added common helpers for Base64 encoding and decoding, string conversions for Core Foundation and C APIs, and notification names.
- Included `PrivacyInfo.xcprivacy` in the Swift package resources. The manifest declares reasons for the library's use of file timestamps, user defaults, and disk space APIs.

## [2.3.2] - 2024-01-29

### Added

- Added the `SystemKit_Objc` product with `SKSecurity` for AES encryption and decryption. Add this product to your target to use the Objective-C API. [SKSecurity guide](Document/SKSecurity.md)
- Added `SKAtomicValue` for synchronized reads and writes. Use `mutate` when a change needs to read and update the value in a single operation.

## [2.3.1] - 2023-07-20

### Added

- Added `SKSystem.verifyCodeSignature(ofPath:)` on macOS. Pass the path of an app bundle or installer package to get a Boolean result. The helper uses `codesign` for `.app` bundles and `pkgutil` for `.pkg` files.

## [2.3.0] - 2023-07-06

### Added

- Added `SKPreferencePaneDefine` to name macOS settings panes by their identifiers.
- Added `getCurrentRadioAccessTechnology()` on iOS to read the current cellular radio technology for each reported service.

### Changed

- Reorganized permission definitions and added `SKOperation` to share operation requirements.

### Removed

- Removed the separate `SKPermission` implementation. Review any direct calls to that class when moving from 2.2.x.

## [2.2.5] - 2023-06-20

### Changed

- Replaced the separate local and remote initializers with `init(portName:_:)`. To receive messages, pass the dispatch queue, callback information, and handler to `listen`. To send messages, use the same named-port setup. Existing callers must update their initialization and listener setup.

## [2.2.4] - 2023-05-30

### Changed

- Changed the local `SKMessagePort` initializer to accept an `AnyObject` for callback information. Pass the object directly if your 2.2.3 code previously built a raw pointer for that argument.

## [2.2.3] - 2023-05-29

### Added

- Added `SKMessagePort` for sending data between threads or processes on the same machine. It wraps Core Foundation message ports with Swift methods to listen on a named local port and send data to a remote port.

## [2.2.2] - 2023-05-02

### Added

- Added `SKFileLock` to coordinate file access within a process. Create the lock with a file path and access mode or an existing file descriptor, then call `lock()` and `unlock()`.

## [2.2.1] - 2023-04-27

### Fixed

- Fixed Swift 5.6 build errors in the package manifest and network address handling. The manifest now uses `from:` for SwiftLog and Swift-DocC and sets their minimum versions to 1.5.2 and 1.2.0, respectively.

## [2.2.0] - 2023-04-26

### Added

- Added `SKNetworkInterface` to list local interfaces and read IPv4, IPv6, and MAC addresses where available.
- Added `SKDispatchFile` for queue-based file reads and writes. Callers receive the result through a completion handler.

### Changed

- Restored the user defaults helper after its removal in 2.0.0. It wraps a typed value stored in `UserDefaults` and provides a fallback when the key has no stored value.

## [2.1.0] - 2023-04-03

### Added

- Made the Swift-DocC plugin available when the manifest runs with Swift 5.6 or later, so the library's API documentation can be generated through SwiftPM.

## [2.0.0] - 2023-03-28

### Added

- Added IOKit helpers for macOS system, process, and battery information, along with support for reading information about connected displays or printers.

### Changed

- Raised the package deployment targets to macOS 10.13 and iOS 11. Check your app's deployment targets before upgrading from 1.0.0.
- Switched the SwiftPM target to a bundled PLCrashReporter XCFramework for crash reporting.
- Replaced the Beltex XCFramework with source code.

### Removed

- Removed the Core Data, synchronized array, and existing user defaults helpers.

## [1.0.0] - 2023-01-05

### Added

- Published the first tagged Swift package with deployment targets of macOS 10.12 and iOS 10. It included helpers for operations, network monitoring, user defaults, crash reporting, and macOS process monitoring and Finder extensions.

[Unreleased]: https://github.com/ChangYeop-Yang/Universal-SystemKit/compare/2.4.0...main
[2.4.0]: https://github.com/ChangYeop-Yang/Universal-SystemKit/compare/2.3.2...2.4.0
[2.3.2]: https://github.com/ChangYeop-Yang/Universal-SystemKit/compare/2.3.1...2.3.2
[2.3.1]: https://github.com/ChangYeop-Yang/Universal-SystemKit/compare/2.3.0...2.3.1
[2.3.0]: https://github.com/ChangYeop-Yang/Universal-SystemKit/compare/2.2.5...2.3.0
[2.2.5]: https://github.com/ChangYeop-Yang/Universal-SystemKit/compare/2.2.4...2.2.5
[2.2.4]: https://github.com/ChangYeop-Yang/Universal-SystemKit/compare/2.2.3...2.2.4
[2.2.3]: https://github.com/ChangYeop-Yang/Universal-SystemKit/compare/2.2.2...2.2.3
[2.2.2]: https://github.com/ChangYeop-Yang/Universal-SystemKit/compare/2.2.1...2.2.2
[2.2.1]: https://github.com/ChangYeop-Yang/Universal-SystemKit/compare/2.2.0...2.2.1
[2.2.0]: https://github.com/ChangYeop-Yang/Universal-SystemKit/compare/2.1.0...2.2.0
[2.1.0]: https://github.com/ChangYeop-Yang/Universal-SystemKit/compare/2.0.0...2.1.0
[2.0.0]: https://github.com/ChangYeop-Yang/Universal-SystemKit/compare/1.0.0...2.0.0
[1.0.0]: https://github.com/ChangYeop-Yang/Universal-SystemKit/releases/tag/1.0.0
