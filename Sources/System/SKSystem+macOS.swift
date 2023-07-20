/*
 * Copyright (c) 2023 Universal-SystemKit. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

// swiftlint:disable all
#if os(macOS)
import AppKit
import Darwin
import SystemConfiguration

// MARK: - Public Extension SKSystem With macOS Platform
public extension SKSystem {
    
    /**
        현재 구동중인 macOS 운영체제 명칭을 가져오는 함수입니다.
     
        - Authors: `ChangYeop-Yang`
        - Requires: Use more than `macOS Sierra (10.12)`
        - Returns: `String`
     */
    @available(macOS 10.12, *)
    final func getOperatingSystemName() -> String {
        
        let version = ProcessInfo.processInfo.operatingSystemVersion
        
        // macOS Sierra ~ macOS Catalina 운영체제는 Minor Version까지 확인
        let lowerVersion: () -> String = {
            switch version.minorVersion {
            // macOS Sierra (10.12)
            case 12:
                return macOSSystemVersion.Sierra.name
            // macOS High Sierra (10.13)
            case 13:
                return macOSSystemVersion.HighSierra.name
            // macOS Mojave (10.14)
            case 14:
                return macOSSystemVersion.Mojave.name
            // macOS Catalina (10.15)
            case 15:
                return macOSSystemVersion.Catalina.name
            default:
                return "UNKNOWN"
            }
        }
        
        switch version.majorVersion {
        // Above macOS Sierra
        case 10:
            return lowerVersion()
        // Above macOS BigSur (11.0)
        case 11:
            return macOSSystemVersion.BigSur.name
        // Above macOS Monterey (12.0)
        case 12:
            return macOSSystemVersion.Monterey.name
        // Above macOS Ventura (13.0)
        case 13:
            return macOSSystemVersion.Ventura.name
        // Above macOS Sonoma (14.0)
        case 14:
            return macOSSystemVersion.Sonoma.name
        // macOS 10.12 미만의 운영체제이거나 아직 알려지지 않은 운영체제
        default:
            return "UNKNOWN"
        }
    }
    
    /**
        현재 macOS 운영체제에서 로그인 되어 사용중인 사용자 이름을 가져오는 함수입니다.
     
        - Authors: `ChangYeop-Yang`
        - Requires: Use more than `OSX Puma (10.1)`
        - Returns: `Optional<String>`
     */
    @available(macOS 10.1, *)
    final func getConsoleUserName() -> Optional<String> {

        let forKey: String = "GetConsoleUser"
        
        // Creates a new session used to interact with the dynamic store maintained by the System Configuration server.
        let store = SCDynamicStoreCreate(nil, forKey as CFString, nil, nil)

        // Returns information about the user currently logged into the system.
        guard let result = SCDynamicStoreCopyConsoleUser(store, nil, nil) else {
            return UserDefaults.standard.string(forKey: forKey)
        }

        UserDefaults.standard.setValue(result as String, forKey: forKey)

        // https://developer.apple.com/library/archive/qa/qa1133/_index.html
        return result as String
    }
    
    /**
        현재 구동중인 응용 프로그램이 `Rosetta`를 통하여 실행이 되는지 확인하는 함수입니다.
     
        - Authors: `ChangYeop-Yang`
        - NOTE: [Apple Document](https://developer.apple.com/documentation/apple-silicon/about-the-rosetta-translation-environment)
        - Requires: Use more than `OSX Cheetah (10.0)`
        - Returns: The example function returns the value 0 for a native process, 1 for a translated process, and -1 when an error occurs.
     */
    @available(macOS 10.0, *)
    final func isRosettaTranslatedProcess() -> SKTranslatedRosettaResult {
        
        var ret: Int = Int.zero
        var size: size_t = MemoryLayout.size(ofValue: ret)
        
        let flag: String = "sysctl.proc_translated"
        if sysctlbyname(flag, &ret, &size, nil, Int.zero) == EOF {
            if errno == ENOENT { return .native }
            return .error
        }
        
        let rawValue = Int32(ret)
        return SKTranslatedRosettaResult(rawValue: rawValue) ?? .error
    }
    
    /**
        현재 구동중인 응용 프로그램이 사용하고 있는 `CPU 사용률 (CPU usage)`을 가져오는 함수입니다.
     
        - Authors: `ChangYeop-Yang`
        - Requires: Use more than `OSX Yosemite (10.10)`
        - Returns: `Double`
     */
    @available(macOS 10.10, *)
    final func getRunningProcessUsingCPU() -> Double {

        var threadsList: thread_act_array_t?
        var totalUsageOfCPU: Double = Double.zero
        var threadsCount = mach_msg_type_number_t(Int32.zero)
        
        let threadsResult = withUnsafeMutablePointer(to: &threadsList) {
            return $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
                task_threads(mach_task_self_, $0, &threadsCount)
            }
        }

        if threadsResult == KERN_SUCCESS, let threadsList = threadsList {
            
            for index in mach_msg_type_number_t.zero..<threadsCount {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(threadsList[Int(index)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                    }
                }

                guard infoResult == KERN_SUCCESS else { break }

                let threadBasicInfo = threadInfo as thread_basic_info
                if (threadBasicInfo.flags & TH_FLAGS_IDLE) == Int32.zero {
                    totalUsageOfCPU = (totalUsageOfCPU + (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0))
                }
            }
        }
        
        vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))

        return totalUsageOfCPU
    }
    
    /**
        전달받은 `프로세스 식별 값 (PID)`를 통하여 현재 응용 프로그램 실행 상태가 `Debug` 상태 여부를 확인하는 함수입니다.
     
        - Authors: `ChangYeop-Yang`
        - NOTE: [Detect if Swift app is being run from Xcode](https://stackoverflow.com/questions/33177182/detect-if-swift-app-is-being-run-from-xcode)
        - Returns: `Bool`
     */
    final func getBeingDebugged(pid: pid_t) -> Bool {
        
        var proc: kinfo_proc = kinfo_proc()
        var size: Int = MemoryLayout.stride(ofValue: proc)
        var mib: Array<Int32> = [CTL_KERN, KERN_PROC, KERN_PROC_PID, pid]
        let junk: Int32 = sysctl(&mib, UInt32(mib.count), &proc, &size, nil, Int.zero)
        
        // sysctl 함수를 통하여 결과를 가져오지 못하는 경우에는 함수를 종료합니다.
        guard junk == Int32.zero else { return false }
        
        return (proc.kp_proc.p_flag & P_TRACED) != Int32.zero
    }

    /**
        출력장치 (Output Device) 정보를 가져오는 함수입니다.
     
        - Authors: `ChangYeop-Yang`
        - Returns: `Array<SKDisplayOutputUnitResult>`
     */
    final func getDisplayOutputUnit() -> Array<SKDisplayOutputUnitResult> {
        
        var result: Array<SKDisplayOutputUnitResult> = Array.init()
        
        for (windowNumber, screen) in NSScreen.screens.enumerated() {
            
            var newElement = SKDisplayOutputUnitResult(windowNumber: windowNumber)

            // The bit depth of the window’s raster image (2-bit, 8-bit, and so forth).
            let bitsPerSampleKey: NSDeviceDescriptionKey = NSDeviceDescriptionKey.bitsPerSample
            if let bitsPerSample = screen.deviceDescription[bitsPerSampleKey] as? NSNumber {
                
                // RGB(적·녹·청) 각각에 대해 몇 비트씩 할당해서 이의 조합으로 여러 가지 색을 나타내는, 즉 비트 수로 색의 수를 표현하는 것을 말한다.
                newElement.bitsPerSample = bitsPerSample.intValue
            }
            
            // The name of the window’s color space.
            let colorSpaceNameKey: NSDeviceDescriptionKey = NSDeviceDescriptionKey.colorSpaceName
            if let colorSpaceName = screen.deviceDescription[colorSpaceNameKey] as? NSString {
                
                // 일반적으로 적·녹·청 3원색의 조합으로 표현되는 색 모델 좌표계에서 나타낼 수 있는 색상의 범위를 뜻한다.
                newElement.colorSpaceName = colorSpaceName as String
            }
            
            // The size of the window’s frame rectangle.
            let sizeKey: NSDeviceDescriptionKey = NSDeviceDescriptionKey.size
            if let size = screen.deviceDescription[sizeKey] as? NSSize {
                
                // 내장 디스플레이의 해상도의 크기를 뜻합니다.
                newElement.frameWidth = size.width
                newElement.frameHeight = size.height
            }
            
            // The window’s raster resolution in dots per inch (dpi).
            let resolutionKey: NSDeviceDescriptionKey = NSDeviceDescriptionKey.resolution
            if let resolution = screen.deviceDescription[resolutionKey] as? NSSize {

                // 내장 디스플레이의 래스터 해상도의 단위 인 DPI(인치당 도트수)의 크기를 뜻합니다.
                newElement.rasterWidth = resolution.width
                newElement.rasterHeight = resolution.height
            }
            
            // The display device is a screen.
            let isScreenKey: NSDeviceDescriptionKey = NSDeviceDescriptionKey.isScreen
            if let isScreen = screen.deviceDescription[isScreenKey] as? NSString {
                
                // 해당 디스플레이 장치가 화면을 나타내는 출력 장치 여부를 확인합니다.
                newElement.isScreen = isScreen.boolValue
            }
            
            // The display device is a printer.
            let isPrinterKey: NSDeviceDescriptionKey = NSDeviceDescriptionKey.isPrinter
            if let isPrinter = screen.deviceDescription[isPrinterKey] as? NSString {
                
                // 해당 디스플레이 장치가 프린터 출력 장치 여부를 확인합니다.
                newElement.isPrinter = isPrinter.boolValue
            }
    
            result.append(newElement)
        }
        
        return result
    }
    
    /**
        `PreferencePane` 경로를 입력받아서 `시스템 환경설정 (System Preference)` 창을 켭니다.

        - NOTE: `@discardableResult`
        - Parameters:
            - preferencePane: `PreferencePane` 경로를 입력받는 변수
        - Returns: `Bool`
     */
    @discardableResult
    final func openPreferencePane(preferencePane: String) -> Bool {
        
        logger.debug("[SKSystem] Move to System Preferences based on \(preferencePane) PreferencePane.")
        
        guard let url = URL(string: preferencePane) else {
            logger.error("[SKSystem] This is an invalid PreferencePane.")
            return false
        }
        
        return NSWorkspace.shared.open(url)
    }
    
    /**
        `tccutil` 명령어를 통하여 입력 된 애플리케이션 권한을 초기화 작업을 수행합니다.

        - Requires: Use more than `macOS Sierra (10.12)`
        - Parameters:
            - service: `SKPermissionServiceName` 입력받는 변수
            - bundlePath: Application Bundle Path를 입력받는 변수
        - Returns: `Bool`
     */
    @available(macOS 10.12, *)
    final func managePrivacyPermission(service: SKPermissionServiceName, bundlePath: String) {
                
        let arguments: [String] = ["reset", service.rawValue, bundlePath]
        SKProcess.shared.run(launchPath: "/usr/bin/tccutil", arguments: arguments)
    }
    
    /**
        `.pkg` 또는 `.app` 확장자를 가진 파일에 대하여 코드 서명을 검증하는 함수입니다.

        - Parameters:
            - ofPath: 코드 서명 (Code Signing) 검증 작업을 수행 할 파일 경로를 입력받는 변수
        - Returns: `Bool`
     */
    final func verifyCodeSignature(ofPath filePath: String) -> Bool {
                
        let process = Process()
                
        switch URL(fileURLWithPath: filePath).pathExtension {
        // 코드 서명을 검증하는 대상이 .pkg 확장자를 가진 파일인 경우
        case "pkg":
            process.launchPath = "/usr/sbin/pkgutil"
            process.arguments = ["--check-signature", filePath]
            
        // 코드 서명을 검증하는 대상이 .app 확장자를 가진 파일인 경우
        case "app":
            process.launchPath = "/usr/bin/codesign"
            process.arguments = ["--verify", "-R=anchor apple generic", filePath]
            
        default:
            logger.error("[SKSystem] The file with an extension that cannot be verified for code signing.")
            return false
        }
        
        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus == Int32.zero
        } catch let error as NSError {
            logger.error("[SKSystem] An error occurred while running the process: \(error.description)")
            return false
        }
    }
}
#endif
