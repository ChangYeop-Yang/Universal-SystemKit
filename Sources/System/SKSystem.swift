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

#if os(macOS) || os(iOS)
import Darwin
import Foundation
import SystemConfiguration

public class SKSystem: NSObject, SKClass {
    
    // MARK: - Object Properties
    public static let shared: SKSystem = SKSystem()
    public static let label: String = "com.SystemKit.SKSystem"
    public static let identifier: String = "1735CFB1-19CC-4581-8CB7-F2DC3E16C678"
}

// MARK: - Public Extension SKSystem With Universal Platform
public extension SKSystem {
    
    /**
        현재 구동중인 애플리케이션에 대한 `릴리즈 버전 (Release Version` 그리고 `번들 버전 (Bundle Version)` 정보를 가져오는 함수입니다.

        - Version: `1.0.0`
        - Authors: `ChangYeop-Yang`
        - Returns: `Optional<SKSystemApplicationVersionResult>`
     */
    final func getApplicationVersion() -> Optional<SKSystemApplicationVersionResult> {
        
        guard let infoDictionary = Bundle.main.infoDictionary else { return nil }

        guard let releaseVersion = infoDictionary["CFBundleShortVersionString"] as? String,
              let bundleVersion = infoDictionary["CFBundleVersion"] as? String else { return nil }
    
        return SKSystemApplicationVersionResult(release: releaseVersion, bundle: bundleVersion)
    }
    
    /**
        현재 장비에서 사용중인 메모리 사용률 그리고 전체 메모리 값을 가져오는 함수입니다.
     
        - Version: `1.0.0`
        - Authors: `ChangYeop-Yang`
        - NOTE: Units of measurement `Megabyte (MB)`
        - Returns: `SKSystemMachineUsageMemeoryResult`
     */
    final func getMachineUsageMemory() -> SKSystemMachineUsageMemeoryResult {
        
        var usageMegaBytes: Float = Float.zero
        let totalMegaBytes: Float = Float(ProcessInfo.processInfo.physicalMemory) / 1024.0 / 1024.0
        
        var info: mach_task_basic_info = mach_task_basic_info()
        var count: UInt32 = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        
        let result: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info( mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if result == KERN_SUCCESS {
            usageMegaBytes = Float(info.resident_size) / 1024.0 / 1024.0
        }
        
        return SKSystemMachineUsageMemeoryResult(usage: usageMegaBytes, total: totalMegaBytes)
    }
    
    /**
        현재 사용중인 장비 모델 명칭을 가져오는 함수입니다.
     
        - SeeAlso: [Apple Device Database](https://appledb.dev)
        - Version: `1.0.0`
        - Authors: `ChangYeop-Yang`
        - NOTE: 장비 모델 명칭을 가져오고 실제 제품을 판매하기 위한 제품명을 가져오기 위해서는 `getMachineSystemInfo` 함수를 사용하여야합니다.
        - Returns: `String`
     */
    final func getDeviceModelName() -> String {
        
        var mib: Array<Int32> = [CTL_HW, HW_MODEL]
        var size: Int = MemoryLayout<io_name_t>.size
        let pointee = UnsafeMutablePointer<io_name_t>.allocate(capacity: 1)
        
        let result = sysctl(&mib, u_int(mib.count), pointee, &size, nil, Int.zero)
        
        #if DEBUG
            NSLog("[%@][%@] Action, Get Device Model: %d", SystemKit.label, SKSystem.identifier, result)
        #endif
        
        let cString: UnsafePointer<CChar> = UnsafeRawPointer(pointee).assumingMemoryBound(to: CChar.self)
        
        return String(cString: cString, encoding: String.Encoding.utf8) ?? String.init()
    }
    
    /**
        현재 사용중인 제품에 대한 제품 정보를 가져오는 함수입니다.
     
        - SeeAlso: [Apple Device Database](https://appledb.dev)
        - Version: `1.0.0`
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
}
#endif
