# 🗂 SKFileLock

`SKFileLock`는 iOS 그리고 macOS 운영체제 환경에서 작동하며 오직 특정 시간에 단일 프로세스 접근만을 허용함으로써 컴퓨터 파일에 접근을 제한하는 기능을 제공합니다. `파일 읽기 (Read)`, `파일 쓰기 (Write)`, `파일 수정 (Modify)` 등의 작업을 할 수 있습니다.

* [파일 잠금 (File Locking)](https://en.wikipedia.org/wiki/File_locking) → File locking is a mechanism that restricts access to a computer file, or to a region of a file, by allowing only one user or process to modify or delete it at a specific time and to prevent reading of the file while it's being modified or deleted.

# Example Source

`SKFileLock` 예제 소스코드는 아래와 같습니다.

```Swift
// FileLockMode (.read, .write, update)
let filePath = "/Users/~/Desktop/file.txt"
let locker = SKFileLock(filePath: filePath, .read)

// 파일 접근에 대하여 잠금 (Locking) 작업을 수행합니다.
locker.lock()

// 파일 접근에 대하여 잠금 해제 (UnLocking) 작업을 수행합니다.        
locker.unlock()
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
