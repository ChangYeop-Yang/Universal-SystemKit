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
import AppKit
import Darwin
import SystemConfiguration

// MARK: - Public Extension SKSystem
public extension SKSystem {
    
    /**
        현재 장비에서 사용하고 있는 `전지 (Battery)` 정보 저장하고 있는 구조체입니다.
     
        - Authors: `ChangYeop-Yang`
        - Date: `2022년도 11월 10일 목요일 23:23`
        - Since: [beltex/SystemKit](https://github.com/beltex/SystemKit)
        - Returns: `Optional<SKSystemApplicationVersionResult>`
     */
    struct SKIOBatteryResult: Codable {
        
        // MARK: Static Properties
        private static var battery: SKIOBattery = SKIOBattery()
        
        // MARK: String Properties
        
        /// Same as timeRemaining(), but returns as a human readable time format, as seen in the battery status menu bar.
        public let timeRemainingFormatted: String
        
        // MARK: Bool Properties
        
        /// Is the machine powered by AC? Plugged into the charger.
        public let poweredAC: Bool
        
        /// Is the battery fully charged.
        public let charged: Bool
        
        /// Is the battery charging.
        public let charging: Bool
        
        // MARK: Double Properties
        
        /// What is the current charge of the machine? As seen in the battery status menu bar. This is the currentCapacity / maxCapacity.
        public let charge: Double
        
        /// Get the current temperature of the battery.
        public let temperature: Double
        
        // MARK: - Integer Properties
        public let designCycleCount: Int
        
        /// Get the current cycle count of the battery.
        public let cycleCount: Int
        
        /// Get the current capacity of the battery in mAh. This is essientally the current charge of the battery.
        public let capacity: Int
        
        /// Get the current max capacity of the battery in mAh. This degrades over time from the original design capacity.
        public let maxCapactiy: Int
        
        /// Get the designed capacity of the battery in mAh. This is a static value. The max capacity will be equal to this when new, and as it degrades over time, be less than this.
        public let designCapacity: Int
        
        public init?() {
            
            guard SKIOBatteryResult.battery.open() == kIOReturnSuccess else { return nil }
            
            self.poweredAC = SKIOBatteryResult.battery.isACPowered()
            self.charging = SKIOBatteryResult.battery.isCharging()
            self.charged = SKIOBatteryResult.battery.isCharged()
            
            self.charge = SKIOBatteryResult.battery.charge()
            self.temperature = SKIOBatteryResult.battery.temperature()
            
            self.cycleCount = SKIOBatteryResult.battery.cycleCount()
            self.designCycleCount = SKIOBatteryResult.battery.designCycleCount()
            
            self.capacity = SKIOBatteryResult.battery.currentCapacity()
            self.maxCapactiy = SKIOBatteryResult.battery.maxCapactiy()
            self.designCapacity = SKIOBatteryResult.battery.designCapacity()
            
            self.timeRemainingFormatted = SKIOBatteryResult.battery.timeRemainingFormatted()
            
            let result: kern_return_t = SKIOBatteryResult.battery.close()
            
            #if DEBUG
                NSLog("[%@][%@] Action, Close Battery: %d", SKSystem.label, SKSystem.identifier, result)
            #endif
        }
    }
    
    /**
        현재 장비에서 사용하고 있는 `처리 장치 (Central/Main processor)` 정보를 저장하고 있는 구조체 입니다.
     
         - Authors: `ChangYeop-Yang`
         - Date: `2022년도 11월 15일 화요일 22:21`
         - Since: [beltex/SystemKit](https://github.com/beltex/SystemKit)
         - Returns: `SKSystemMainControlResult`
     */
    struct SKIOSystemMainControlResult: Codable {
        
        // MARK: Static Properties
        
        private static let processCountInfo = SKIOSystem.processCounts()
        
        private static let processPowerInfo = SKIOSystem.CPUPowerLimit()
        
        // MARK: Integer Properties
        
        /// Total number of Processes
        public let processCount: Int
        
        /// Total number of Threads
        public let threadCount: Int
        
        /// Number of physical cores on this machine.
        public let physicalCores: Int
        
        /// Number of logical cores on this machine. Will be equal to physicalCores() unless it has hyper-threading, in which case it will be double.
        public let logicalCores: Int
        
        /// Defines the speed & voltage limits placed on the CPU. Represented as a percentage (0-100) of maximum CPU speed.
        public let processorSpeed: Double
        
        /// Represents the percentage (0-100) of CPU time available. 100% at normal operation. The OS may limit this time for a percentage less than 100%.
        public let schedulerTime: Double
        
        // MARK: Initalize
        public init() {

            self.logicalCores = SKIOSystem.logicalCores()
            self.physicalCores = SKIOSystem.physicalCores()

            self.processorSpeed = SKSystem.SKIOSystemMainControlResult.processPowerInfo.processorSpeed
            self.schedulerTime = SKSystem.SKIOSystemMainControlResult.processPowerInfo.schedulerTime

            self.processCount = SKSystem.SKIOSystemMainControlResult.processCountInfo.processCount
            self.threadCount = SKSystem.SKIOSystemMainControlResult.processCountInfo.threadCount
        }
    }
    
    /**
        현재 장비에서 사용하고 있는 `메모리 (Memory)` 정보를 저장하고 있는 구조체 입니다.
     
         - Authors: `ChangYeop-Yang`
         - Date: `2022년도 11월 28일 월요일 22:24`
         - Since: [beltex/SystemKit](https://github.com/beltex/SystemKit)
         - Returns: `SKSystemMemoryResult`
     */
    struct SKIOSystemMemoryResult: Codable {
        
        // MARK: Double Properties
        
        /// Size of physical memory on this machine
        public let physicalMemorySize: Double
        
        public let freeSize: Double
        
        public let activeSize: Double
        
        public let inActiveSize: Double
        
        public let compressedSize: Double
        
        public let wiredSize: Double
        
        // MARK: Initalize
        public init(unit: SKIOSystem.Unit = SKIOSystem.Unit.gigabyte) {
            
            // System memory usage [Free, Active, In-Active, Wired, Compressed]
            let usage = SKIOSystem.memoryUsage()
            
            self.freeSize = usage.free
            self.wiredSize = usage.wired
            self.activeSize = usage.active
            self.inActiveSize = usage.inactive
            self.compressedSize = usage.compressed
            
            self.physicalMemorySize = SKIOSystem.physicalMemory(unit)
        }
        
        // MARK: Method
        static func getMemoryUnit(_ value: Double) -> String {
            
            if value < 1.0 {
                let intValue: Int = Int(value * 1000.0)
                return String(format: "%d MB", intValue)
            }
            
            return String(format: "%.2f GB", value)
        }
    }
}

// MARK: - Public Extension SKSystem With macOS Platform
public extension SKSystem {
    
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
            case 12:
                return macOSSystemVersion.Sierra.name
            // macOS High Sierra
            case 13:
                return macOSSystemVersion.HighSierra.name
            // macOS Mojave
            case 14:
                return macOSSystemVersion.Mojave.name
            // macOS Catalina
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
        // Above macOS BigSur
        case 11:
            return macOSSystemVersion.BigSur.name
        // Above macOS Monterey
        case 12:
            return macOSSystemVersion.Monterey.name
        // Above macOS Ventura
        case 13:
            return macOSSystemVersion.Ventura.name
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
}
#endif
