# 📋 Changelog

[![Latest release](https://img.shields.io/github/v/release/ChangYeop-Yang/Universal-SystemKit?label=Latest%20release)](https://github.com/ChangYeop-Yang/Universal-SystemKit/releases/latest)

This file lists notable changes to Universal SystemKit. The format follows [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/). Release dates come from GitHub Releases.

## [Unreleased]

### Added

- Added `SKDispatchFileMonitor` to monitor file and folder events.
- Added `SKSystemProcessResource` to read macOS process details and resource use.
- Added SwiftPM platform declarations and simulator build checks for tvOS, watchOS, and visionOS.
- Added SwiftLint, Swift and Objective-C++ static analysis, and a SwiftPM consumer test that builds and runs both library products.
- Added an API reference report that lists installed SDKs, supported OS versions, and Context7 lookup results.
- Added contributor guidelines, Claude Code instructions, and a security reporting policy.

### Changed

- Raised the Swift package tools version to 5.9.
- Updated the iPhone model list to include iPhone 15, iPhone 15 Plus, iPhone 15 Pro, and iPhone 15 Pro Max.
- Updated dispatch timer controls and macOS resource reporting.
- Updated GitHub Actions to use hosted macOS 26 runners and provide job summaries with links to downloadable logs.

## [2.4.0] - 2024-08-18

### Added

- Added `SKSystemResource` to read macOS memory, CPU, and disk use.
- Added `SKDispatchTimer` and shared helpers for data, numbers, and strings.
- Added a privacy manifest with reasons for accessing file timestamps, user defaults, and disk space.

## [2.3.2] - 2024-01-29

### Added

- Added the `SystemKit_Objc` product with `SKSecurity` for AES encryption and decryption.
- Added `SKAtomicValue` for synchronized access to a value.

## [2.3.1] - 2023-07-20

### Added

- Added macOS code signature checks for `.app` and `.pkg` files.

## [2.3.0] - 2023-07-06

### Added

- Added `SKPreferencePaneDefine` with identifiers for settings panes.
- Added an iPhone API for reading the current cellular radio technology.

### Changed

- Reworked permission definitions and organized shared operation protocols.

### Removed

- Removed the separate `SKPermission` implementation.

## [2.2.5] - 2023-06-20

### Changed

- Reworked `SKMessagePort` setup and its handling of local and remote ports.

## [2.2.4] - 2023-05-30

### Changed

- Simplified pointer handling in `SKMessagePort` and updated its usage guide.

## [2.2.3] - 2023-05-29

### Added

- Added `SKMessagePort` for sending data between threads or processes on the same machine.

## [2.2.2] - 2023-05-02

### Added

- Added `SKFileLock` to control file access within a process.

## [2.2.1] - 2023-04-27

### Fixed

- Fixed a compilation issue with Swift 5.6.

## [2.2.0] - 2023-04-26

### Added

- Added `SKNetworkInterface` to read local network interface details, including IPv4, IPv6, and MAC addresses.
- Added `SKDispatchFile` for queue-based file reads and writes.

### Changed

- Reworked the user defaults helper.

## [2.1.0] - 2023-04-03

### Added

- Added the Swift-DocC plugin to support documentation builds.

## [2.0.0] - 2023-03-28

### Added

- Added macOS system, process, and battery helpers based on IOKit.

### Changed

- Packaged PLCrashReporter as an XCFramework.
- Replaced the Beltex XCFramework with source code.

### Removed

- Removed the Core Data, synchronized array, and existing user defaults helpers.

## [1.0.0] - 2023-01-05

### Added

- Published the first tagged release of Universal SystemKit.

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
