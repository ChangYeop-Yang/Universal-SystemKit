# 🗂 SKSecurity

`SKSecurity`는 고급 암호화 표준 (Advanced Encryption Standard, AES)를 기반으로 입력받은 데이터를 `AES-128`, `AES-192`, `AES-256`들의 대칭키 (Symmetric) 크기를 바탕으로 암호화 또는 복호화 작업을 수행할 수 있습니다. 또한, CBC (Cipher Block Chaining mode) 기반으로 동작하기에 초기화 백터 값이 필요합니다.

</br>

* AES (Advanced Encryption Standard) 암호화 기법에 대한 자세한 설명은 [Advanced Encryption Standard](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) 확인 부탁드립니다.

</br>

고급 암호화 표준 (Advanced Encryption Standard, AES) 키의 크기 제약 조건은 아래를 반드시 지켜야 합니다.

* An AES 128-bit key can be expressed as a hexadecimal string with 32 characters. It will require 24 characters in base64.

* An AES 192-bit key can be expressed as a hexadecimal string with 48 characters. It will require 32 characters in base64.

* An AES 256-bit key can be expressed as a hexadecimal string with 64 characters. It will require 44 characters in base64.

# Example Source

`SKSecurity` 예제 소스코드는 아래와 같습니다.

```Swift
// AES 암호화를 수행하기 위한 IV를 생성합니다.
let iv = SKSecurity.shared().createInitializationVector()
print(iv)
        
let key = "a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2"
        
// AES 암호화를 수행하기 위한 평문을 생성합니다.
if let rawData = "PASSWORD".data(using: .utf8) {
            
    // AES 암호화를 수행합니다.
    let encrypted = SKSecurity.shared().encrypt(key, .AES256, iv, rawData)

    // AES 복호화를 수행합니다.   
    let decrypted = SKSecurity.shared().decrypt(key, .AES256, iv, encrypted)
    print(String(data: decrypted, encoding: .utf8))
}
```

# License

`Universal SystemKit` is released under the MIT license. [See LICENSE](https://github.com/ChangYeop-Yang/Apple-SystemKit/blob/main/LICENSE) for details.

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
