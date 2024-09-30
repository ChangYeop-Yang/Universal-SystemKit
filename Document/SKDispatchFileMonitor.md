# 🗂 SKDispatchFileMonitor

`SKDispatchFileMonitor`는 iOS 또는 macOS 플렛폼에서 공용적으로 사용할 수 있는 파일에 대한 이벤트를 감시하는 기능을 제공합니다.

`SKDispatchFileMonitor` provides a common interface for monitoring file events on both iOS and macOS platforms.

`DispatchSource.FileSystemEvent`에 대한 설명은 아래와 같습니다.

- static let all: DispatchSource.FileSystemEvent → 파일에 대하여 모든 파일 이벤트를 수신받습니다.

- static let attrib: DispatchSource.FileSystemEvent → 파일 메타 데이터 변경 이벤트를 수신받습니다.

- static let delete: DispatchSource.FileSystemEvent → 파일 삭제 이벤트를 수신받습니다.

- static let extend: DispatchSource.FileSystemEvent → 파일 크기 변경에 대한 이벤트를 수신받습니다.

- static let funlock: DispatchSource.FileSystemEvent → 파일 Unlocking 이벤트를 수신받습니다.

- static let link: DispatchSource.FileSystemEvent → 파일 Link Count 변경에 대한 이벤트를 수신받습니다. 

- static let rename: DispatchSource.FileSystemEvent → 파일 이름 변경에 대한 이벤트를 수신받습니다.

- static let revoke: DispatchSource.FileSystemEvent → 파일 접근 권한 이벤트를 수신받습니다.

- static let write: DispatchSource.FileSystemEvent → 파일에 대하여 데이터 쓰기 이벤트를 수신받습니다.

# Example Source

`SKDispatchFileMonitor` 예제 소스코드는 아래와 같습니다.

```Swift
let eventMask: DispatchSource.FileSystemEvent = [.delete, .write]
let monitor = SKDispatchFileMonitor(filePath: "FILE_PATH", eventMask: eventMask) { event in
    print(event)
}
        
// 지정 된 파일 경로에 대하여 파일 이벤트를 탐지합니다.
monitor?.start()
        
// 지정 된 파일 경로에 대하여 파일 이벤트 탐지를 중단합니다.
monitor?.stop()
```

# License

`SystemKit` is released under the MIT license. [See LICENSE](https://github.com/ChangYeop-Yang/Apple-SystemKit/blob/main/LICENSE) for details.

</br>

```TEXT
MIT License

Copyright (c) 2024 Universal-SystemKit

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
