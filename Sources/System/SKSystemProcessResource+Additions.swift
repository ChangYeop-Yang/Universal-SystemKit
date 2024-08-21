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

// MARK: - Public Extension SKSystemProcessResource
public extension SKSystemProcessResource {
    
    final func getProcessName(pid: pid_t) -> String {

        // The maximum bytes of argument to execve
        var mib: [Int32] = [CTL_KERN, KERN_ARGMAX]

        var buffersize = UInt32.zero
        var size = MemoryLayout.size(ofValue: buffersize)

        if sysctl(&mib, UInt32(mib.count), &buffersize, &size, nil, Int.zero) < Int32.zero {
            logger.error("[SKSystemProcessResource] Failed to retrieve KERN_ARGMAX buffer size")
            return String.init()
        }

        let count = Int(buffersize)
        var cString = [CChar](repeating: CChar.zero, count: count)

        // Retrieves the process name
        if proc_name(pid, &cString, buffersize) < Int32.zero {
            logger.error("[SKSystemProcessResource] Failed to retrieve process name")
            return String.init()
        }

        return String(cString: cString)
    }
    
    final func getProcessInfoList() -> Array<SKProcessResourceInfo> {
        
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_ALL]
        
        // Retrieves information about all processes running on the operating system
        var length = size_t.zero
        if sysctl(&mib, UInt32(mib.count), nil, &length, nil, Int.zero) < Int32.zero {
            logger.error("[SKSystemProcessResource] Failed to retrieve process information")
            return Array.init()
        }

        // Allocating memory to UnsafeMutablePointer<kinfo_proc>
        let capacity = Int(length)
        let info = UnsafeMutablePointer<kinfo_proc>.allocate(capacity: capacity)
        
        // Deallocating memory from UnsafeMutablePointer
        defer { info.deallocate() }

        // Retrieves detailed information about processes
        if sysctl(&mib, UInt32(mib.count), info, &length, nil, Int.zero) < Int32.zero {
            logger.error("[SKSystemProcessResource] Failed to retrieve detailed process information using kinfo_proc")
            return Array.init()
        }
        
        var result = Array<SKProcessResourceInfo>.init()

        let count = Int(length / MemoryLayout<kinfo_proc>.size)
        for index in Int.zero..<count {
            
            let pid: pid_t = info[index].kp_proc.p_pid
            
            // Kernel processes do not retrieve process information
            if pid == pid_t.zero { continue }
            
            var taskInfo = proc_taskinfo()
            
            let buffersize = Int32(MemoryLayout<proc_taskinfo>.size)
            if proc_pidinfo(pid, PROC_PIDTASKINFO, UInt64.zero, &taskInfo, buffersize) < Int32.zero { continue }
            
            // Retrieves the process name
            let name = getProcessName(pid: pid)
            
            let newElement = SKProcessResourceInfo(pid: pid, name: name, info: taskInfo)
            result.append(newElement)
        }
        
        return result
    }
}
#endif
