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

// MARK: - Struct
public struct SKProcessResourceInfo: Codable {
    
    public let pid: pid_t
    
    public let name: String
    
    /// Virtual memory size (Bytes)
    public let virtualMemSize: UInt64
    
    /// Resident memory size (Bytes)
    public let residentMemSize: UInt64
    
    /// Task priority
    public let priority: Int32
    
    /// Number of running threads
    public let runningThreads: Int32
    
    /// Number of threads in the task
    public let totalThreads: Int32
    
    /// Number of context switches
    public let contextSwitch: Int32
    
    /// Total time `[User]`
    public let totalUserTime: UInt64
    
    /// Total Time `[System]`
    public let totalSystemTime: UInt64
    
    /// Number of page faults
    public let totalPageFaults: Int32
    
    /// Number of copy-on-write faults
    public let onCopyWritePageFaluts: Int32
    
    // MARK: Initalize
    public init(pid: pid_t, name: String, info: proc_taskinfo) {
        
        self.pid = pid
        self.name = name
        self.onCopyWritePageFaluts = info.pti_cow_faults
        self.totalPageFaults = info.pti_faults
        self.totalUserTime = info.pti_total_user
        self.totalSystemTime = info.pti_total_system
        self.priority = info.pti_priority
        self.contextSwitch = info.pti_csw
        self.totalThreads = info.pti_threadnum
        self.runningThreads = info.pti_numrunning
        self.virtualMemSize = info.pti_virtual_size
        self.residentMemSize = info.pti_resident_size
    }
}
#endif
