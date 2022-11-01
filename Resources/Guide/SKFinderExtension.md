# 🗂 SKFinderExtension

`SKFinderExtension`는 macOS 운영체제 환경에서 사용되는 Finder 확장 프로그램을 추가 (Append), 활성화 (Enable), 비활성화 (Disable), 활성화 여부 (isEnable)를 실행할 수 있습니다.

# Example Source

`SKFinderExtension` 예제 소스코드는 아래와 같습니다.

```Swift
let result: bool = SKFinderExtension.shared.isExtensionEnabled
print(result)

// 확장 프로그램 활성화
SKFinderExtension.shared.enable(extensionPath: "extensionPath", waitUntilExit: false)

// 확장 프로그램 비활성화
SKFinderExtension.shared.disable(extensionPath: "extensionPath", waitUntilExit: false)

// 확장 프로그램 추가
SKFinderExtension.shared.append(extensionPath: "extensionPath", waitUntilExit: false)
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
