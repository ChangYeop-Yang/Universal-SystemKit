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

// MARK: - Extension SKSystem
public extension SKSystem {
 
    /// - NOTE: Device 장비에서 사용하고 있는 Battery 정보를 가져올 수 있는 구조체입니다.
    struct SKBatteryResult: Codable {
        
        // MARK: Static Properties
        private static var battery: Battery = Battery()
        
        // MARK: - String Properties
        
        /// Same as timeRemaining(), but returns as a human readable time format, as seen in the battery status menu bar.
        public let timeRemainingFormatted: String
        
        // MARK: - Bool Properties
        
        /// Is the machine powered by AC? Plugged into the charger.
        public let poweredAC: Bool
        
        /// Is the battery fully charged.
        public let charged: Bool
        
        /// Is the battery charging.
        public let charging: Bool
        
        // MARK: - Double Properties
        
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
            NSLog("[%@][%@] Action, Close Battery: %d", SKSystem.label, SKSystem.identifier, result)
        }
    }
    
    /// - NOTE:
    struct SKSystemResult: Codable {
        
        // MARK: - Static Properties
        private static let processCountInfo = System.processCounts()
        
        // MARK: - String Properties
        
        /// Get the model name of this machine. Same as "sysctl hw.model"
        public let modelName: String
        
        // MARK: - Integer Properties
        
        /// Total number of Processes
        public let processCount: Int
        
        /// Total number of Threads
        public let threadCount: Int
        
        /// Number of physical cores on this machine.
        public let physicalCores: Int
        
        /// Number of logical cores on this machine. Will be equal to physicalCores() unless it has hyper-threading, in which case it will be double.
        public let logicalCores: Int
        
        /// Size of physical memory on this machine: GB
        public let physicalMemory: Double
        
        // MARK: - Initalize
        public init() {
            
            self.modelName = System.modelName()
        
            self.physicalCores = System.physicalCores()
            self.logicalCores = System.logicalCores()
            
            self.physicalMemory = System.physicalMemory(.gigabyte)
            
            self.processCount = SKSystem.SKSystemResult.processCountInfo.processCount
            self.threadCount = SKSystem.SKSystemResult.processCountInfo.threadCount
        }
    }
}

#endif