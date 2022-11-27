# 🛠 Universal SystemKit

![Swift - Shields.io](https://img.shields.io/badge/Swift-5.3%20%7C%205.4%20%7C%205.5%20%7C%205.6-orange)
![Platfirn - Shields.io](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS-yellowgreen)
![LinkedIn - Shields.io](https://img.shields.io/badge/Linked--In-창엽--양--3535ab134-informational)
![Swift Package Manager - Shields.io](https://img.shields.io/badge/Swift%20Package%20Manager-Compatible-success)

`Universal SystemKit` 오픈소스 라이브러리는 `macOS`, `iOS` 등의 Apple Platform에서 사용할 수 있는 공용 라이브러리입니다.

# Installation

`Universal SystemKit` 설치 방법은 `Swift Package Manager`를 통하 설치할 수 있으며 자세한 사항은 아래와 같습니다.

## Swift Package Manager

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding `SystemKit` as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```Swift
dependencies: [
    .package(url: "https://github.com/ChangYeop-Yang/Universal-SystemKit", .branch("master"))
]
```

# Using SystemKit

`Universal SystemKit` 오픈소스 라이브러리를 사용하는 방법은 아래의 Guide 경로에 기술되어 있습니다. 추가적인 관련 사항은 이슈 생성을 통하여 문의부탁드립니다.

* [SKAsyncOperation](https://github.com/ChangYeop-Yang/Universal-SystemKit/blob/main/Resources/Guide/SKAsyncOperation.md)

* [SKFinderExtension](https://dev-dream-world.tistory.com/226?category=1294828)

* [SKPermission](https://dev-dream-world.tistory.com/227?category=1294828)

* [SKProcess](https://dev-dream-world.tistory.com/225?category=1294828)

* [SKProcessMonitor](https://dev-dream-world.tistory.com/230?category=1294828)

* [SKUserDefault](https://dev-dream-world.tistory.com/224?category=1294828)

* [SKSignal](https://dev-dream-world.tistory.com/229?category=1294828)

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
