# 🗂 SKCrashReporter

`SKCrashReporter`는 iOS 또는 macOS 플렛폼에서 구동이되는 애플리케이션이 특정한 이유로 충돌 (Crash) 발생 시 관련 내용들을 파일 저장 또는 충돌 내용을 확인할 수 있는 기능을 제공합니다. 충돌이 발생하여 애플리케이션 (Application)이 종료되는 경우에는 종료직전 입력받은 `Callback`으로 `CompletionHandler`을 받으여 애플리케이션 재시작 시 충돌 내용ㅇ 저장 된 `.plcrash` 확장자를 가진 파일이 생성됩니다.

* 해당 기능을 사용하기 위해서는 `Xcode Debug executable` 환경이 아닌 `Release` 모드에서만 구동이 됩니다.

* `SKCrashReporter` 기능은 [PLCrashReporter](https://github.com/microsoft/plcrashreporter) 오픈소스를 사용하여 제공하는 기능입니다. 해당 오픈소스 라이센스는 `Copyright (c) Microsoft Corporation.`를 적용받습니다.

# Example Source

`SKCrashReporter` 예제 소스코드는 아래와 같습니다.

```Swift
// SKCrashReporter Instance를 사용하기 위해서는 충돌파일을 저장하기 위한 폴더 경로 및 파일 이름을 매개변수로 전달합니다.
let crashReport = SKCrashReporter(crashReportDirectory: "DIRECTORY_REPORT", crashReportFileName: "REPORT_NAME")

// typedef void (*PLCrashReporterPostCrashSignalCallback)(siginfo_t *info, ucontext_t *uap, void *context);
crashReport.enable(handleSignal: PLCrashReporterPostCrashSignalCallback)

// SKCrashReporter 비활성화를 수행합니다.
crashReport.disable()
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
