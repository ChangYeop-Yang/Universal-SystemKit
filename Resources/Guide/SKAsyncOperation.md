# 🗂 SKAsyncOperation

`SKAsyncOperation`는 iOS 또는 macOS 플렛폼에서 공용적으로 사용할 수 있는 `Concurrent OperationQueue`를 효율적으로 사용할 수 있도록 기능을 제공합니다. `SKAsyncOperation`는 상속을 통해서 사용할 수 있습니다.

# Example Source

`SKAsyncOperation` 예제 소스코드는 아래와 같습니다.

```Swift
public class CurrentOperation: SKAsyncOperation {
    
    public override func start() {
        // 특정 작업을 수행할 수 있는 비즈니스 로직을 추가합니다.
        print("START")
    }
    
    public override func cancel() {
        // 작업에 대하여 취소 작업 수행 로직을 추가합니다.
        print("CANCEL")
    }
}

let operation: Operation = CurrentOperation()
OperationQueue().addOperation(operation)
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
