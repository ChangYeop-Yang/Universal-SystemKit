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

// MARK: - Private Extension SKSystemResource
private extension SKSystemResource {
    
    final func getStatistics64() -> vm_statistics64 {
        
        var size: mach_msg_type_number_t = UInt32(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size)
        
        let capacity = Int(size)
        
        let hostInfo = vm_statistics64_t.allocate(capacity: 1)
        let _ = hostInfo.withMemoryRebound(to: integer_t.self, capacity: capacity) { (pointer) -> kern_return_t in
            return host_statistics64(mach_host_self(), HOST_VM_INFO64, pointer, &size)
        }
        
        let data = hostInfo.move()
        hostInfo.deallocate()
        
        return data
    }
}

// MARK: - Public Extension SKSystemResource
public extension SKSystemResource {
    
    final func getSystemMemoryResource(type: SKResourceDataUnitType = .gigaByte) -> SKMemoryResourceInfo {
        
        let maximumMemory = Double(ProcessInfo.processInfo.physicalMemory) / type.rawValue
        
        let load = getStatistics64()
        let unit = Double(vm_kernel_page_size) / type.rawValue
        
        let active = Double(load.active_count) * unit
        let speculative = Double(load.speculative_count) * unit
        let inactive = Double(load.inactive_count) * unit
        let wired = Double(load.wire_count) * unit
        let compressed = Double(load.compressor_page_count) * unit
        let purgeable = Double(load.purgeable_count) * unit
        let external = Double(load.external_page_count) * unit
        let using = active + inactive + speculative + wired + compressed - purgeable - external
        
        return SKMemoryResourceInfo(value: min(99.9, (100.0 * using / maximumMemory).round2dp),
                                    pressureValue: (100.0 * (wired + compressed) / maximumMemory).round2dp, 
                                    appValue: (using - wired - compressed).round2dp,
                                    wiredValue: wired.round2dp,
                                    compressedValue: compressed.round2dp)
    }
}
#endif
