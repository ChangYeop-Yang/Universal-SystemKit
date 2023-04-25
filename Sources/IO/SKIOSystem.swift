/*
 * Copyright (c) 2022 Universal SystemKit. All rights reserved.
 * Copyright (C) 2014-2017 beltex <https://github.com/beltex>
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
import Darwin
import Foundation
import IOKit.pwr_mgt

/* As defined in <mach/tash_info.h> */
private let HOST_BASIC_INFO_COUNT         : mach_msg_type_number_t =
                    UInt32(MemoryLayout<host_basic_info_data_t>.size / MemoryLayout<integer_t>.size)
private let HOST_LOAD_INFO_COUNT          : mach_msg_type_number_t =
                    UInt32(MemoryLayout<host_load_info_data_t>.size / MemoryLayout<integer_t>.size)
private let HOST_CPU_LOAD_INFO_COUNT      : mach_msg_type_number_t =
                    UInt32(MemoryLayout<host_cpu_load_info_data_t>.size / MemoryLayout<integer_t>.size)
private let HOST_VM_INFO64_COUNT          : mach_msg_type_number_t =
                    UInt32(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size)
private let HOST_SCHED_INFO_COUNT         : mach_msg_type_number_t =
                    UInt32(MemoryLayout<host_sched_info_data_t>.size / MemoryLayout<integer_t>.size)
private let PROCESSOR_SET_LOAD_INFO_COUNT : mach_msg_type_number_t =
                    UInt32(MemoryLayout<processor_set_load_info_data_t>.size / MemoryLayout<natural_t>.size)

public struct SKIOSystem {
    
    public static let PAGE_SIZE = vm_kernel_page_size
    
    // MARK: - Enum
    public enum Unit: Double {
        
        case byte     = 1
        case kilobyte = 1024
        case megabyte = 1048576
        case gigabyte = 1073741824
    }
    
    public enum LOAD_AVG {
        
        /// 5, 30, 60 second samples
        case short
        
        /// 1, 5, 15 minute samples
        case long
    }
    
    public enum ThermalLevel: String {

        /// Under normal operating conditions
        case Normal = "Normal"
        
        /// Thermal pressure may cause system slowdown
        case Danger = "Danger"
        
        /// Thermal conditions may cause imminent shutdown
        case Crisis = "Crisis"
        
        /// Thermal warning level has not been published
        case NotPublished = "Not Published"
        
        /// The platform may define additional thermal levels if necessary
        case Unknown = "Unknown"
    }

    // MARK: - Object Properties
    fileprivate static let machHost = mach_host_self()
    fileprivate var loadPrevious = host_cpu_load_info()
    
    // MARK: - Initalize
    public init() { NSLog("[SKIOSystem] Initalize") }
}

// MARK: - Private Extension SKIOSystem
private extension SKIOSystem {
    
    static func hostBasicInfo() -> host_basic_info {
                
        var size = HOST_BASIC_INFO_COUNT
        let hostInfo = host_basic_info_t.allocate(capacity: 1)
        
        let result = hostInfo.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
            host_info(machHost, HOST_BASIC_INFO, $0, &size)
        }
  
        let data = hostInfo.move()
        hostInfo.deallocate()
        
        #if DEBUG
            if result != KERN_SUCCESS {
                print("ERROR - \(#file):\(#function) - kern_result_t = " + "\(result)")
            }
        #endif
        
        return data
    }

    static func hostLoadInfo() -> host_load_info {
        
        var size = HOST_LOAD_INFO_COUNT
        let hostInfo = host_load_info_t.allocate(capacity: 1)
        
        let result = hostInfo.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
            host_statistics(machHost, HOST_LOAD_INFO, $0, &size)
        }
        
        let data = hostInfo.move()
        hostInfo.deallocate()
        
        #if DEBUG
            if result != KERN_SUCCESS {
                print("ERROR - \(#file):\(#function) - kern_result_t = " + "\(result)")
            }
        #endif
        
        return data
    }
    
    static func hostCPULoadInfo() -> host_cpu_load_info {
        
        var size = HOST_CPU_LOAD_INFO_COUNT
        let hostInfo = host_cpu_load_info_t.allocate(capacity: 1)
        
        let result = hostInfo.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
            host_statistics(machHost, HOST_CPU_LOAD_INFO, $0, &size)
        }
        
        let data = hostInfo.move()
        hostInfo.deallocate()
        
        #if DEBUG
            if result != KERN_SUCCESS {
                print("ERROR - \(#file):\(#function) - kern_result_t = " + "\(result)")
            }
        #endif

        return data
    }
    
    static func processorLoadInfo() -> processor_set_load_info {
        
        var pset = processor_set_name_t()
        var result = processor_set_default(machHost, &pset)
        
        if result != KERN_SUCCESS {
            #if DEBUG
                print("ERROR - \(#file):\(#function) - kern_result_t = " + "\(result)")
            #endif

            return processor_set_load_info()
        }

        var count = PROCESSOR_SET_LOAD_INFO_COUNT
        let info_out = processor_set_load_info_t.allocate(capacity: 1)
        
        result = info_out.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
            processor_set_statistics(pset, PROCESSOR_SET_LOAD_INFO, $0, &count)
        }

        #if DEBUG
            if result != KERN_SUCCESS {
                print("ERROR - \(#file):\(#function) - kern_result_t = " + "\(result)")
            }
        #endif

        mach_port_deallocate(mach_task_self_, pset)

        let data = info_out.move()
        info_out.deallocate()
        
        return data
    }
    
    static func VMStatistics64() -> vm_statistics64 {
        
        var size = HOST_VM_INFO64_COUNT
        let hostInfo = vm_statistics64_t.allocate(capacity: 1)
        
        let result = hostInfo.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
            host_statistics64(machHost, HOST_VM_INFO64, $0, &size)
        }

        let data = hostInfo.move()
        hostInfo.deallocate()
        
        #if DEBUG
            if result != KERN_SUCCESS {
                print("ERROR - \(#file):\(#function) - kern_result_t = " + "\(result)")
            }
        #endif
        
        return data
    }
}

// MARK: - Public Extension SKIOSystem
public extension SKIOSystem {
    
    /// Get CPU usage (system, user, idle, nice). Determined by the delta between the current and last call. Thus, first call will always be inaccurate.
    mutating func usageCPU() -> (system: Double, user: Double, idle: Double, nice: Double) {
        
        let load = SKIOSystem.hostCPULoadInfo()
        
        let userDiff = Double(load.cpu_ticks.0 - loadPrevious.cpu_ticks.0)
        let sysDiff  = Double(load.cpu_ticks.1 - loadPrevious.cpu_ticks.1)
        let idleDiff = Double(load.cpu_ticks.2 - loadPrevious.cpu_ticks.2)
        let niceDiff = Double(load.cpu_ticks.3 - loadPrevious.cpu_ticks.3)
        
        let totalTicks = sysDiff + userDiff + niceDiff + idleDiff
        
        let sys  = sysDiff  / totalTicks * 100.0
        let user = userDiff / totalTicks * 100.0
        let idle = idleDiff / totalTicks * 100.0
        let nice = niceDiff / totalTicks * 100.0
        
        loadPrevious = load
    
        return (sys, user, idle, nice)
    }
    
    /// Get the model name of this machine. Same as "sysctl hw.model"
    static func modelName() -> String {
        
        let name: String
        var mib  = [CTL_HW, HW_MODEL]

        // Max model name size not defined by sysctl. Instead we use io_name_t
        // via I/O Kit which can also get the model name
        var size = MemoryLayout<io_name_t>.size

        let ptr = UnsafeMutablePointer<io_name_t>.allocate(capacity: 1)
        let result = sysctl(&mib, u_int(mib.count), ptr, &size, nil, Int.zero)

        if result == Int32.zero {
            name = String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
        } else {
            name = String()
        }

        ptr.deallocate()

        #if DEBUG
            if result != 0 {
                print("ERROR - \(#file):\(#function) - errno = " + "\(result)")
            }
        #endif

        return name
    }

    /**
        Via uname(3) manual page.
        
        -  Parameters:
            - sysname: Name of the operating system implementation.
            - nodename: Network name of this machine.
            - release: Release level of the operating system.
            - version: Version level of the operating system.
            - machine: Machine hardware platform.
    */
    static func uname() -> (sysname: String, nodename: String, release: String, version: String, machine: String) {

        var names  = utsname()
        let result = Foundation.uname(&names)
        
        #if DEBUG
            if result != Int32.zero {
                print("ERROR - \(#file):\(#function) - errno = " + "\(result)")
            }
        #endif
        
        if result == Int32.zero {
            let sysname  = String(reflecting: names.sysname)
            let nodename = String(reflecting: names.nodename)
            let release  = String(reflecting: names.release)
            let version  = String(reflecting: names.version)
            let machine  = String(reflecting: names.machine)

            return (sysname, nodename, release, version, machine)
        }

        return ("", "", "", "", "")
    }

    /// Number of physical cores on this machine.
    static func physicalCores() -> Int {
        return Int(SKIOSystem.hostBasicInfo().physical_cpu)
    }
    
    /**
        Number of logical cores on this machine. Will be equal to physicalCores() unless it has hyper-threading, in which case it will be double.
        [🌎 Hyper-Threading](https://en.wikipedia.org/wiki/Hyper-threading)
    */
    static func logicalCores() -> Int {
        return Int(SKIOSystem.hostBasicInfo().logical_cpu)
    }
    
    /**
        System load average at 3 intervals.
        "Measures the average number of threads in the run queue."
        [🌎 Load](https://en.wikipedia.org/wiki/Load_(computing))
    */
    static func loadAverage(_ type: LOAD_AVG = .long) -> Array<Double> {
        
        var avg = [Double](repeating: 0, count: 3)
        
        switch type {
            case .short:
                let result = SKIOSystem.hostLoadInfo().avenrun
                avg = [Double(result.0) / Double(LOAD_SCALE),
                       Double(result.1) / Double(LOAD_SCALE),
                       Double(result.2) / Double(LOAD_SCALE)]
            
            case .long:
                getloadavg(&avg, 3)
        }
        
        return avg
    }
    
    /// System mach factor at 3 intervals. via hostinfo manual page
    static func machFactor() -> Array<Double> {
        
        let result = SKIOSystem.hostLoadInfo().mach_factor
        
        return [Double(result.0) / Double(LOAD_SCALE),
                Double(result.1) / Double(LOAD_SCALE),
                Double(result.2) / Double(LOAD_SCALE)]
    }

    /// Total number of processes & threads
    static func processCounts() -> (processCount: Int, threadCount: Int) {
        
        let data = SKIOSystem.processorLoadInfo()
        return (Int(data.task_count), Int(data.thread_count))
    }
    
    /// Size of physical memory on this machine
    static func physicalMemory(_ unit: Unit = .gigabyte) -> Double {
        return Double(SKIOSystem.hostBasicInfo().max_mem) / unit.rawValue
    }
    
    /// System memory usage (free, active, inactive, wired, compressed).
    static func memoryUsage() -> (free: Double, active: Double, inactive: Double, wired: Double, compressed: Double) {
        
        let stats = SKIOSystem.VMStatistics64()
        
        let free = Double(stats.free_count) * Double(PAGE_SIZE) / Unit.gigabyte.rawValue
        let active = Double(stats.active_count) * Double(PAGE_SIZE) / Unit.gigabyte.rawValue
        let inactive = Double(stats.inactive_count) * Double(PAGE_SIZE) / Unit.gigabyte.rawValue
        let wired = Double(stats.wire_count) * Double(PAGE_SIZE) / Unit.gigabyte.rawValue
        
        // Result of the compression. This is what you see in Activity Monitor
        let compressed = Double(stats.compressor_page_count) * Double(PAGE_SIZE) / Unit.gigabyte.rawValue
        
        return (free, active, inactive, wired, compressed)
    }
    
    static func uptime() -> (days: Int, hrs: Int, mins: Int, secs: Int) {
        
        var currentTime: time_t = time_t()
        var bootTime: timeval = timeval()
        var mib: Array<Int32> = [CTL_KERN, KERN_BOOTTIME]

        var size = MemoryLayout<timeval>.stride
        let result = sysctl(&mib, u_int(mib.count), &bootTime, &size, nil, Int.zero)

        if result != Int32.zero {
            #if DEBUG
                print("ERROR - \(#file):\(#function) - errno = " + "\(result)")
            #endif

            return (Int.zero, Int.zero, Int.zero, Int.zero)
        }

        time(&currentTime)

        var uptime = currentTime - bootTime.tv_sec

        let days = uptime / 86400   // Number of seconds in a day
        uptime %= 86400

        let hrs = uptime / 3600     // Number of seconds in a hour
        uptime %= 3600

        let mins = uptime / 60
        let secs = uptime % 60

        return (days, hrs, mins, secs)
    }
    
    /**
        As seen via 'pmset -g therm' command. Via `<IOKit/pwr_mgt/IOPMLib.h>`

        - Parameters:
            - processorSpeed: Defines the speed & voltage limits placed on the CPU. Represented as a percentage (0-100) of maximum CPU speed.
            - processorCount: Reflects how many, if any, CPUs have been taken offline. Represented as an integer number of CPUs (0 - Max CPUs).
            - schedulerTime:  Represents the percentage (0-100) of CPU time available. 100% at normal operation. The OS may limit this time for a percentage less than 100%.
        - NOTE: This doesn't sound quite correct, as pmset treats it as the number of CPUs available, NOT taken offline. The return value suggests the same.
    */
    static func CPUPowerLimit() -> (processorSpeed: Double, processorCount: Int, schedulerTime : Double) {
        
        var processorSpeed: Double = -1.0
        var processorCount: Int = -1
        var schedulerTime: Double  = -1.0

        let status = UnsafeMutablePointer<Unmanaged<CFDictionary>?>.allocate(capacity: 1)
        let result = IOPMCopyCPUPowerStatus(status)

        #if DEBUG
            if result != kIOReturnSuccess {
                print("ERROR - \(#file):\(#function) - kern_result_t = " + "\(result)")
            }
        #endif

        if result == kIOReturnSuccess, let data = status.move()?.takeUnretainedValue() {

            let dataMap = data as NSDictionary
            processorSpeed = (dataMap[kIOPMCPUPowerLimitProcessorSpeedKey] as? Double) ?? Double.zero
            processorCount = (dataMap[kIOPMCPUPowerLimitProcessorCountKey] as? Int) ?? Int.zero
            schedulerTime  = (dataMap[kIOPMCPUPowerLimitSchedulerTimeKey] as? Double) ?? Double.zero
        }

        status.deallocate()

        return (processorSpeed, processorCount, schedulerTime)
    }

    /// Get the thermal level of the system. As seen via 'pmset -g therm'
    static func thermalLevel() -> SKIOSystem.ThermalLevel {
        
        var thermalLevel: UInt32 = UInt32.zero
        let result = IOPMGetThermalWarningLevel(&thermalLevel)

        if result == kIOReturnNotFound {
            return SKIOSystem.ThermalLevel.NotPublished
        }
        #if DEBUG
            if result != kIOReturnSuccess {
                print("ERROR - \(#file):\(#function) - kern_result_t = " + "\(result)")
            }
        #endif

        switch thermalLevel {
            /// kIOPMThermalWarningLevelNormal
            case 0:
                return SKIOSystem.ThermalLevel.Normal
            // kIOPMThermalWarningLevelDanger
            case 5:
                return SKIOSystem.ThermalLevel.Danger
            // kIOPMThermalWarningLevelCrisis
            case 10:
                return SKIOSystem.ThermalLevel.Crisis
            default:
                return SKIOSystem.ThermalLevel.Unknown
        }
    }
}
#endif
