# 🗂 SKMessagePort

`SKMessagePort`는 iOS 또는 macOS 플렛폼에서 로컬 장비 상에서 다중 쓰레드 및 프로세스들 간에 임의의 데이터를 전달하는 통신 채널을 제공합니다. 즉, 서로 다른 애플리케이션, 또는 애플리케이션과 프레임워크, 또는 서로 다른 프레임워크 사이의 통신을 할 수 있는 기능을 제공합니다.

# Example Source

`SKMessagePort` 예제 소스코드는 아래와 같습니다.

```Swift
// https://developer.apple.com/documentation/corefoundation/cfmessageportcallback
let callback: CFMessagePortCallBack = { local, msgid, data, info -> Unmanaged<CFData>? in
            
    let pointee = info!.assumingMemoryBound(to: [ViewController].self).pointee
            
    /* here is processing data */
            
    return nil
}
        
// https://developer.apple.com/documentation/corefoundation/cfmessageportinvalidationcallback
let callout: CFMessagePortInvalidationCallBack = { local, info in
            
    let pointee = info!.assumingMemoryBound(to: ViewController.self).pointee
            
    /* here is processing invaild local port */
}
        
var pointee = self
        
let local = SKMessagePort(localPortName: "com.systemkit.port",
                          info: UnsafeMutablePointer(mutating: &pointee), callback, callout)
        
// 다른 프로세스 또는 쓰레드로부터 데이터를 수신할 수 있도록 Listen 상태를 수행합니다.
local.listen(runLoop: .main)
        
let remote = SKMessagePort(remotePortName: "com.systemkit.port", callout)
        
let error = remote.send(messageID: 12345, message: Data(), sendTimeout: 1, recvTimeout: 1)
print(error)

// 생성 된 CFMessagePort 소멸 작업을 수행합니다.
local.invalidate()
remote.invalidate()
```

# License

`SystemKit` is released under the MIT license. [See LICENSE](https://github.com/ChangYeop-Yang/Apple-SystemKit/blob/main/LICENSE) for details.

</br>

```TEXT
MIT License

Copyright (c) 2022 SystemKit

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
