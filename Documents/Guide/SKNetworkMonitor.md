# 🗂 SKNetworkMonitor

`SKNetworkMonitor`는 iOS 운영체제 또는 macOS 운영체제 환경에서 네트워크 환경 (WiFi, Ethernet, Cellular, LoopBack 등)에 대한 정보를 얻을 수 있도록 기능을 제공합니다.

# Example Source

`SKNetworkMonitor` 예제 소스코드는 아래와 같습니다.

```Swift
// 네트워크 상태에 대한 정보 수집을 종료합니다.
let monitor = SKNetworkMonitor { result in
    
    // NWPath 정보를 가져옵니다.
    print(result.newPath)
    
    // 네트워크 상태 정보를 가져옵니다.
    print(result.status)
    
    // 네트워크 연결 상태를 가져옵니다.
    print(result.connectionType)
}

// 네트워크 상태에 대한 정보 수집을 시작합니다.
monitor.startMonitor()

// 네트워크 상태에 대한 정보 수집을 종료합니다.
monitor.stopMonitor()
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
