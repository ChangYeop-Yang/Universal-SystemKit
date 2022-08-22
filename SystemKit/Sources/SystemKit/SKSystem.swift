/*
 * Copyright (c) 2022 ChangYeop-Yang. All rights reserved.
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

import Foundation
import SystemConfiguration

public class SKSystem: NSObject {
    
    // MARK: - Object Properties
    public static let shared: SKSystem = SKSystem()
}

#if os(macOS)
// MARK: - Public Extension SKSystem With macOS Platform
public extension SKSystem {
    
    @available(macOS 10.1, *)
    final func getConsoleUserName() -> String? {

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
        - NOTE: [Apple Document](https://developer.apple.com/documentation/apple-silicon/about-the-rosetta-translation-environment)
        - Returns: The example function returns the value 0 for a native process, 1 for a translated process, and -1 when an error occurs.
     */
    @available(macOS 10.0, *)
    final func isRosettaTranslatedProcess() -> TranslatedRosettaResult {
        
        var ret: Int = Int.zero
        var size: size_t = MemoryLayout.size(ofValue: ret)
        
        let flag: String = "sysctl.proc_translated"
        if sysctlbyname(flag, &ret, &size, nil, Int.zero) == EOF {
            if errno == ENOENT { return .native }
            return .error
        }
        
        let rawValue = Int32(ret)
        return TranslatedRosettaResult(rawValue: rawValue) ?? .error
    }
    
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
}
#endif
