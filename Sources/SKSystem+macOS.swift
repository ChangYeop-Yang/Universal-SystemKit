/*
 * Copyright (c) 2022 Universal-SystemKit. All rights reserved.
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

#if os(macOS)
import Darwin
import Foundation
import SystemConfiguration

// MARK: - Public Extension SKSystem
public extension SKSystem {
 
    /**
        운영체제가 구동 중인 장비에 대한 정보를 가져오는 함수입니다.
     
        - Authors: `ChangYeop-Yang`
        - Returns: `Optional<SKSystemMachineSystemResult>`
     */
    final func getMachineSystemInfo() -> Optional<SKSystemMachineSystemResult> {
        
        let toString: (UnsafeRawBufferPointer) -> Optional<String> = { raw in
            guard let cString = raw.baseAddress?.assumingMemoryBound(to: CChar.self) else { return nil }
            return String(cString: cString, encoding: String.Encoding.utf8)
        }
        
        var names: utsname  = utsname()
        guard Foundation.uname(&names) == Int32.zero else { return nil }
        
        let sysname  = withUnsafeBytes(of: &names.sysname, toString) ?? String.init()
        let nodename = withUnsafeBytes(of: &names.nodename, toString) ?? String.init()
        let release  = withUnsafeBytes(of: &names.release, toString) ?? String.init()
        let version  = withUnsafeBytes(of: &names.version, toString) ?? String.init()
        let machine  = withUnsafeBytes(of: &names.machine, toString) ?? String.init()
        
        return SKSystemMachineSystemResult(operatingSystemName: sysname,
                                           operatingSystemRelease: release, operatingSystemVersion: version,
                                           machineNetworkNodeName: nodename, machineHardwarePlatform: machine)
    }
    
    /**
        현재 구동중인 macOS 운영체제 시스템 버전 (System Version) 정보를 가져오는 함수입니다.
     
        - Authors: `ChangYeop-Yang`
        - Returns: `OperatingSystemVersion`
     */
    final func getOperatingSystemVersion() -> OperatingSystemVersion {

        let result: OperatingSystemVersion = ProcessInfo.processInfo.operatingSystemVersion
        
        #if DEBUG
            NSLog("[%@][%@] Current OperatingSystem Version: \(result)", SKSystem.label, SKSystem.identifier)
        #endif
        
        return result
    }
    
    /**
        현재 구동중인 macOS 운영체제 명칭을 가져오는 함수입니다.
     
        - Authors: `ChangYeop-Yang`
        - Requires: Use more than `macOS Sierra (10.12)`
        - Returns: `String`
     */
    @available(macOS 10.12, *)
    final func getOperatingSystemName() -> String {
        
        let version = getOperatingSystemVersion()
        
        // macOS Sierra ~ macOS Catalina 운영체제는 Minor Version까지 확인
        let lowerVersion: () -> String = {
            switch version.minorVersion {
            // macOS Sierra
            case 12: return macOSSystemVersion.Sierra.name
            // macOS High Sierra
            case 13: return macOSSystemVersion.HighSierra.name
            // macOS Mojave
            case 14: return macOSSystemVersion.Mojave.name
            // macOS Catalina
            case 15: return macOSSystemVersion.Catalina.name
            default: return "UNKNOWN"
            }
        }
        
        switch version.majorVersion {
        // Above macOS Sierra
        case 10: return lowerVersion()
        // Above macOS BigSur
        case 11: return macOSSystemVersion.BigSur.name
        // Above macOS Monterey
        case 12: return macOSSystemVersion.Monterey.name
        // Above macOS Ventura
        case 13: return macOSSystemVersion.Ventura.name
        // macOS 10.12 미만의 운영체제이거나 아직 알려지지 않은 운영체제
        default: return "UNKNOWN"
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

        // MARK: https://developer.apple.com/library/archive/qa/qa1133/_index.html
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
}
#endif
