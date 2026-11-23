![Logo](https://user-images.githubusercontent.com/20036523/246614687-8c70ad56-9c85-416e-b664-7f73a1b81743.png)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FChangYeop-Yang%2FUniversal-SystemKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/ChangYeop-Yang/Universal-SystemKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FChangYeop-Yang%2FUniversal-SystemKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/ChangYeop-Yang/Universal-SystemKit)
[![Tistory - Shields.io](https://img.shields.io/badge/Tistory-%40yeop9657-informational)](https://dev-dream-world.tistory.com)
[![LinkedIn - Shields.io](https://img.shields.io/badge/Linked--In-창엽--양--3535ab134-informational)](https://www.linkedin.com/in/창엽-양-3535ab134/)
![Swift Package Manager - Shields.io](https://img.shields.io/badge/Swift%20Package%20Manager-Compatible-success)
![Manually - Shields.io](https://img.shields.io/badge/Manually-Compatible-success)
![GitHub Repository - Shields.io](https://img.shields.io/badge/GitHub%20Repository-Compatible-success)
[![License - Shields.io](https://img.shields.io/badge/License-MIT-blueviolet)](https://github.com/ChangYeop-Yang/Universal-SystemKit/blob/main/LICENSE)

`SystemKit` is an open-source library that provides access to device and system functions on Apple platforms such as macOS and iOS.

# Installation

Install Universal SystemKit with Swift Package Manager, clone its GitHub repository, or add the source files manually.

### Manually

You can add the `SystemKit` source files to your project manually.

### GitHub Repository

Clone the GitHub repository to build `SystemKit` from source.

### Swift Package Manager

Swift Package Manager comes with the Swift toolchain and resolves and builds package dependencies.

To add `SystemKit` to an Xcode project, choose **File → Add Package Dependencies** and enter the repository URL.

    https://github.com/ChangYeop-Yang/Universal-SystemKit.git

If you use a Swift package manifest, add the dependency to `Package.swift`. To follow the `main` branch, use this declaration.

```Swift
dependencies: [
    .package(url: "https://github.com/ChangYeop-Yang/Universal-SystemKit.git", branch: "main")
]
```

To start with a tagged release, use a version requirement.

```Swift
dependencies: [
    .package(url: "https://github.com/ChangYeop-Yang/Universal-SystemKit.git", from: "2.4.0")
]
```

# Requirements

The table lists the minimum versions and links to build results.

| Platform | Minimum Swift Version | Installation | Status |
|:--------:|:---------------------:|:------------:|:------:|
| iOS 13.0+ | 5.9 | [Swift Package Manager](#swift-package-manager), [Manual](#manually), [GitHub Repository](#github-repository) | [✅ Fully Tested](https://swiftpackageindex.com/ChangYeop-Yang/Universal-SystemKit/builds) |
| macOS 10.15+ (Catalina) | 5.9 | [Swift Package Manager](#swift-package-manager), [Manual](#manually), [GitHub Repository](#github-repository) | [✅ Fully Tested](https://swiftpackageindex.com/ChangYeop-Yang/Universal-SystemKit/builds) |

# Using SystemKit

The guides below show how to use individual APIs. To ask a question or report a problem, follow the [support guide](SUPPORT.md).

* [SKAsyncOperation](https://dev-dream-world.tistory.com/231)

* [SKUserDefault](https://dev-dream-world.tistory.com/224)

* [SKMessagePort](https://dev-dream-world.tistory.com/247)

* [SKNetworkMonitor](https://dev-dream-world.tistory.com/234)

* [SKFinderExtension](https://dev-dream-world.tistory.com/226?category=1294828)

* [SKPermission](https://dev-dream-world.tistory.com/227?category=1294828)

* [SKProcess](https://dev-dream-world.tistory.com/225?category=1294828)

* [SKProcessMonitor](https://dev-dream-world.tistory.com/230?category=1294828)

* [SKSignal](https://dev-dream-world.tistory.com/229?category=1294828)

* [SKCrashReporter](https://dev-dream-world.tistory.com/236)

* [SKFileLock](https://dev-dream-world.tistory.com/244)

* [SKDispatchFile](https://dev-dream-world.tistory.com/246)

* [SKSecurity](https://dev-dream-world.tistory.com/262)

* [SKDispatchFileMonitor](https://dev-dream-world.tistory.com/275) → `SKDispatchFileMonitor` provides a common interface for monitoring file events on both iOS and macOS platforms.

# License

`SystemKit` is released under the MIT license. [Read the license](LICENSE).

```TEXT
MIT License

Copyright © 2026 Universal SystemKit. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

> **Copyright © 2026 Universal SystemKit.** All rights reserved.
