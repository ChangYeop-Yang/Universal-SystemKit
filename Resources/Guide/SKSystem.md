# 🗂 SKSystem

`SKSystem`는 iOS 또는 macOS 플렛폼에서 공용적으로 사용할 수 있는 `Concurrent OperationQueue`를 효율적으로 사용할 수 있도록 기능을 제공합니다. `SKAsyncOperation`는 상속 (Inheritance)을 통해서 사용할 수 있습니다.

# Example Source

`SKSystem` 예제 소스코드는 아래와 같습니다.

```Swift
// 현재 프로세스를 실행 시킨 작업 대상이 Debug 형태로 실행이 되었는 경우를 확인합니다.
let result = SKSystem.shared.getBeingDebugged(pid: pid)
print(result ? "DEBUG" : "NON DEBUG")

// 운영체제가 구동 중인 장비에 대한 정보를 가져옵니다.
let resultA = SKSystem.shared.getMachineSystemInfo()
print(resultA)

// 현재 구동중인 macOS 운영체제 시스템 버전 (System Version) 정보를 가져옵니다.
let resultB = SKSystem.shared.getOperatingSystemVersion()
print(resultB)

// 현재 구동중인 애플리케이션에 대한 `릴리즈 버전 (Release Version` 그리고 `번들 버전 (Bundle Version)` 정보를 가져옵니다.
let resultC = SKSystem.shared.getApplicationVersion()
print(resultC)
```

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
