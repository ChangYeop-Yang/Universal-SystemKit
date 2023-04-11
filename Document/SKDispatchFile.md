# 🗂 SKDispatchFile

`SKDispatchFile`는 DispatchIO를 기반으로 파일 읽기 및 쓰기 작업에 대한 기능을 제공합니다. `SKDispatchFile`는 파일 잠금(file locking) 매커니즘을 기반으로 구현이 되어있어 쓰레드 안전 (Thread Safety)합니다.

* 파일 잠금(file locking)은 오직 특정한 시간에 한 명의 사용자나 프로세스 접근만을 허용함으로써 컴퓨터 파일에 접근을 제한하는 구조이다.

# Example Source

`SKDispatchFile` 예제 소스코드는 아래와 같습니다.

```Swift
let dispatch = SKDispatchFile(qualityOfService: .background)
            
// 파일 읽기 작업
dispatch.read(filePath: "/Desktop/Symbols.txt") { contents, error in
    print(error)
}
            
// 파일 쓰기 작업
let data = "A String".data(using: .utf8) ?? Data()
dispatch.write(contents: data, filePath: "/Desktop/Example.txt") { error in
    print(error)
}
```

# License

`SystemKit` is released under the MIT license. [See LICENSE](https://github.com/ChangYeop-Yang/Apple-SystemKit/blob/main/LICENSE) for details.

</br>

```TEXT
MIT License

Copyright (c) 2023 Universal-SystemKit

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
