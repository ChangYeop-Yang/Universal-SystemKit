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
    
    typealias ApplicationVersionResult = (releaseVersion: String, bundleVersion: String)
    final func getApplicationVersion() -> Optional<ApplicationVersionResult> {
        
        guard let infoDictionary = Bundle.main.infoDictionary else { return nil }

        guard let releaseVersion = infoDictionary["CFBundleShortVersionString"] as? String,
              let bundleVersion = infoDictionary["CFBundleVersion"] as? String else { return nil }
    
        return ApplicationVersionResult(releaseVersion, bundleVersion)
    }
    
    typealias DeviceMemoryResult = (usage: Float, total: Float)
    final func getDeviceMemoryUnitMB() -> DeviceMemoryResult {
        
        var usageMegaBytes = Float.zero
        let totalMegaBytes = Float(ProcessInfo.processInfo.physicalMemory) / 1024.0 / 1024.0
        
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        
        let result: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info( mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if result == KERN_SUCCESS {
            usageMegaBytes = Float(info.resident_size) / 1024.0 / 1024.0
        }
        
        return DeviceMemoryResult(usageMegaBytes, totalMegaBytes)
    }
}
#endif
