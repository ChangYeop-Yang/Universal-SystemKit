![Logo](https://user-images.githubusercontent.com/20036523/204139069-916be47d-391f-4afd-85a9-84529bec78a5.png)

![Swift - Shields.io](https://img.shields.io/badge/Swift-5.3%20%7C%205.4%20%7C%205.5%20%7C%205.6-orange)
![Platfirn - Shields.io](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS-yellowgreen)
[![Tistory - Shields.io](https://img.shields.io/badge/Tistory-%40yeop9657-informational)](https://dev-dream-world.tistory.com)
[![LinkedIn - Shields.io](https://img.shields.io/badge/Linked--In-창엽--양--3535ab134-informational)](https://www.linkedin.com/in/창엽-양-3535ab134/)
![Swift Package Manager - Shields.io](https://img.shields.io/badge/Swift%20Package%20Manager-Compatible-success)
![Manually - Shields.io](https://img.shields.io/badge/Manually-Compatible-success)
![Github Repository - Shields.io](https://img.shields.io/badge/Github%20Repository-Compatible-success)
[![License - Shields.io](https://img.shields.io/badge/License-MIT-blueviolet)](https://github.com/ChangYeop-Yang/Universal-SystemKit/blob/main/LICENSE)

`Universal SystemKit` is an open-source library that can be used on Apple platforms such as `macOS` and `iOS`. It provides common functionality that can be used across different Apple operating systems.

# Installation

`Universal SystemKit` 설치 방법은 [Swift Package Manager](https://www.swift.org/package-manager) 또는 [Github Repository](https://docs.github.com/en/repositories)를 통하여 설치할 수 있으며 자세한 사항은 아래와 같습니다.

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate `Universal SystemKit` into your project manually.

### Github Repository

You can pull the `Universal SystemKit` Github Repository and include the `Universal SystemKit` to build a dynamic or static library.

### Swift Package Manager

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding `SystemKit` as a dependency is as easy as adding it to the dependencies value of your Package.swift.

1. From the Xcode menu, click File → Swift Packages → Add Package Dependency.

2. In the dialog that appears, enter the repository URL: https://github.com/ChangYeop-Yang/Universal-SystemKit.git.

3. In Branch, Enter text "master".

```Swift
dependencies: [
    .package(url: "https://github.com/ChangYeop-Yang/Universal-SystemKit", .branch("master"))
]
```

# Requirements

| Platform | Minimum Swift Version | Installation | Status |
|:--------:|:---------------------:|:------------:|:------:|
| iOS 10.0+ / macOS 10.12+ | [5.0](https://www.swift.org/blog/swift-5-released/) | [Swift Package Manager](#swift-package-manager), [Manual](#manually), [Github Repository](#github-repository) | ✅ Fully Tested |

# Using SystemKit

`Universal SystemKit` 오픈소스 라이브러리를 사용하는 방법은 아래의 Guide 경로에 기술되어 있습니다. 추가적인 관련 사항은 이슈 생성을 통하여 문의부탁드립니다.

* [SKAsyncOperation](https://github.com/ChangYeop-Yang/Universal-SystemKit/blob/main/Resources/Guide/SKAsyncOperation.md)

* [SKNetworkMonitor](https://dev-dream-world.tistory.com/234)

* [SKFinderExtension](https://dev-dream-world.tistory.com/226?category=1294828)

* [SKPermission](https://dev-dream-world.tistory.com/227?category=1294828)

* [SKProcess](https://dev-dream-world.tistory.com/225?category=1294828)

* [SKProcessMonitor](https://dev-dream-world.tistory.com/230?category=1294828)

* [SKUserDefault](https://dev-dream-world.tistory.com/224?category=1294828)

* [SKSignal](https://dev-dream-world.tistory.com/229?category=1294828)

* [SKCrashReporter](https://dev-dream-world.tistory.com/236)

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
