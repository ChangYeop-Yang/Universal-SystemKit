# 🗂 SKPermission

`SKPermission`는 iOS 또는 macOS 운영체제에서 애플리케이션 구동에 필요 한 다양한 권한 [`파일 및 폴더 권한 (Files and Folders)`, `전체 디스크 접근 권한 (Full Disk Access)`, `사진 (Photos)`, `연락처 (AddressBook)`, `블루투스 (Bluetooth)`, `캘린더 (Calendar)`] 등을 손쉽게 관리할 수 있습니다. 

# Example Source

`SKPermission` 예제 소스코드는 아래와 같습니다.

```Swift
// 공유하기 환경설정 페이지를 표시합니다.
SKSystem.shared.openPreferencePane(path: SKSharingPreferencePane.Main.rawValue)
        
// Screentime 환경설정 페이지를 표시합니다.
SKPermission.shared.openPreferencePane(path: SKDefaultPreferencePane.Screentime.rawValue)

// 전체 디스크 접근 권한 (Full Disk Access) 여부를 확인합니다. 
let isPermission: Bool = SKPermission.shared.isFullDiskAccessPermission()
print(isPermission)

// com.apple.Terminal 애플리케이션 권한을 제거합니다.
SKPermission.shared.managePrivacyPermission(service: .SystemPolicyDesktopFolder, bundlePath: "com.apple.Terminal")
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
