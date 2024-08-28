![Logo](https://user-images.githubusercontent.com/20036523/246614687-8c70ad56-9c85-416e-b664-7f73a1b81743.png)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FChangYeop-Yang%2FUniversal-SystemKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/ChangYeop-Yang/Universal-SystemKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FChangYeop-Yang%2FUniversal-SystemKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/ChangYeop-Yang/Universal-SystemKit)
[![Tistory - Shields.io](https://img.shields.io/badge/Tistory-%40yeop9657-informational)](https://dev-dream-world.tistory.com)
[![LinkedIn - Shields.io](https://img.shields.io/badge/Linked--In-창엽--양--3535ab134-informational)](https://www.linkedin.com/in/창엽-양-3535ab134/)
![Swift Package Manager - Shields.io](https://img.shields.io/badge/Swift%20Package%20Manager-Compatible-success)
![Manually - Shields.io](https://img.shields.io/badge/Manually-Compatible-success)
![Github Repository - Shields.io](https://img.shields.io/badge/Github%20Repository-Compatible-success)
[![License - Shields.io](https://img.shields.io/badge/License-MIT-blueviolet)](https://github.com/ChangYeop-Yang/Universal-SystemKit/blob/main/LICENSE)

The `SystemKit` open-source library can be used on Apple Platforms such as `macOS`, `iOS`. and is a common library that enables convenient and efficient use of device system functions.

# Installation

The installation method for Universal SystemKit can be done through the [Swift Package Manager](https://www.swift.org/package-manager) or the [Github Repository](https://docs.github.com/en/repositories), and the details are as follows.

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate `SystemKit` into your project manually.

### Github Repository

You can pull the `SystemKit` Github Repository and include the `SystemKit` to build a dynamic or static library.

### Swift Package Manager

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding `SystemKit` as a dependency is as easy as adding it to the dependencies value of your Package.swift.

1. From the Xcode menu, click File → Swift Packages → Add Package Dependency.

2. In the dialog that appears, enter the repository URL: https://github.com/ChangYeop-Yang/Universal-SystemKit.git.

3-1. In Branch, Enter text "master".

```Swift
dependencies: [
    .package(url: "https://github.com/ChangYeop-Yang/Universal-SystemKit", .branch("master"))
]
```

3-2. In Branch, Enter text "Version(2, 4, 0)".

```Swift
dependencies: [
    .package(url: "https://github.com/ChangYeop-Yang/Universal-SystemKit", from: Version(2, 4, 0))
]
```

# Requirements

The detailed build results for the `Universal-SystemKit` library are as follows.

| Platform | Minimum Swift Version | Installation | Status |
|:--------:|:---------------------:|:------------:|:------:|
| iOS 11.0+ | [5.0](https://www.swift.org/blog/swift-5-released/) | [Swift Package Manager](#swift-package-manager), [Manual](#manually), [Github Repository](#github-repository) | [✅ Fully Tested](https://swiftpackageindex.com/ChangYeop-Yang/Universal-SystemKit/builds) |
| macOS 10.13+ (High Sierra) | [5.0](https://www.swift.org/blog/swift-5-released/) | [Swift Package Manager](#swift-package-manager), [Manual](#manually), [Github Repository](#github-repository) | [✅ Fully Tested](https://swiftpackageindex.com/ChangYeop-Yang/Universal-SystemKit/builds) |

# Using SystemKit

The method for using the `Universal SystemKit` open-source library is described in the guide path below. For additional related information, please inquire by creating an issue.

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

# License

`SystemKit` is released under the MIT license. [See LICENSE](https://github.com/ChangYeop-Yang/Apple-SystemKit/blob/main/LICENSE) for details.

</br>

```TEXT
MIT License

Copyright (c) 2022 Universal-SystemKit

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
