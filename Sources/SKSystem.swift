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
    public static let identifier: String = UUID().uuidString
}

// MARK: - Public Extension SKSystem With Universal Platform
public extension SKSystem {
    
    /**
        현재 구동중인 애플리케이션에 대한 `릴리즈 버전 (Release Version` 그리고 `번들 버전 (Bundle Version)` 정보를 가져오는 함수입니다.
     
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
}
#endif
