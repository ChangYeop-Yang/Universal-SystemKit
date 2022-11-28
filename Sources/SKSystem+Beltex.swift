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
import Beltex
import Foundation

// MARK: - Public Extension SKSystem With Beltex
public extension SKSystem {
 
    /**
        현재 장비에서 사용하고 있는 `전지 (Battery)` 정보 저장하고 있는 구조체입니다.
     
        - Authors: `ChangYeop-Yang`
        - Date: `2022년도 11월 10일 목요일 23:23`
        - Since: [beltex/SystemKit](https://github.com/beltex/SystemKit)
        - Returns: `Optional<SKSystemApplicationVersionResult>`
     */
    struct SKBatteryResult: Codable {
        
        // MARK: Static Properties
        private static var battery: Battery = Battery()
        
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
            
            guard SKBatteryResult.battery.open() == kIOReturnSuccess else { return nil }
            
            self.poweredAC = SKBatteryResult.battery.isACPowered()
            self.charging = SKBatteryResult.battery.isCharging()
            self.charged = SKBatteryResult.battery.isCharged()
            
            self.charge = SKBatteryResult.battery.charge()
            self.temperature = SKBatteryResult.battery.temperature()
            
            self.cycleCount = SKBatteryResult.battery.cycleCount()
            self.designCycleCount = SKBatteryResult.battery.designCycleCount()
            
            self.capacity = SKBatteryResult.battery.currentCapacity()
            self.maxCapactiy = SKBatteryResult.battery.maxCapactiy()
            self.designCapacity = SKBatteryResult.battery.designCapacity()
            
            self.timeRemainingFormatted = SKBatteryResult.battery.timeRemainingFormatted()
            
            let result: kern_return_t = SKBatteryResult.battery.close()
            
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
         - Returns: `SKSystemControlResult`
     */
    struct SKSystemControlResult: Codable {
        
        // MARK: Static Properties
        
        private static let processCountInfo = System.processCounts()
        
        // MARK: String Properties
        
        /// Get the model name of this machine. Same as "sysctl hw.model"
        public let modelName: String
        
        // MARK: Integer Properties
        
        /// Total number of Processes
        public let processCount: Int
        
        /// Total number of Threads
        public let threadCount: Int
        
        /// Number of physical cores on this machine.
        public let physicalCores: Int
        
        /// Number of logical cores on this machine. Will be equal to physicalCores() unless it has hyper-threading, in which case it will be double.
        public let logicalCores: Int
        
        // MARK: Initalize
        public init() {
            
            self.modelName = System.modelName()
        
            self.physicalCores = System.physicalCores()
            self.logicalCores = System.logicalCores()
            
            self.processCount = SKSystem.SKSystemControlResult.processCountInfo.processCount
            self.threadCount = SKSystem.SKSystemControlResult.processCountInfo.threadCount
        }
    }
    
    /**
        현재 장비에서 사용하고 있는 `메모리 (Memory)` 정보를 저장하고 있는 구조체 입니다.
     
         - Authors: `ChangYeop-Yang`
         - Date: `2022년도 11월 28일 월요일 22:24`
         - Since: [beltex/SystemKit](https://github.com/beltex/SystemKit)
         - Returns: `SKSystemMemoryResult`
     */
    struct SKSystemMemoryResult: Codable {
        
        // MARK: Double Properties
        
        /// Size of physical memory on this machine
        public let physicalMemorySize: Double
        
        public let freeSize: Double
        
        public let activeSize: Double
        
        public let inActiveSize: Double
        
        public let compressedSize: Double
        
        public let wiredSize: Double
        
        // MARK: Initalize
        public init(unit: System.Unit = System.Unit.gigabyte) {
            
            // System memory usage [Free, Active, In-Active, Wired, Compressed]
            let usage = System.memoryUsage()
            
            self.freeSize = usage.free
            self.wiredSize = usage.wired
            self.activeSize = usage.active
            self.inActiveSize = usage.inactive
            self.compressedSize = usage.compressed
            
            self.physicalMemorySize = System.physicalMemory(unit)
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
#endif
