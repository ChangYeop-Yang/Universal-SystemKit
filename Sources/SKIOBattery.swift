/*
 * Copyright (c) 2022 Universal SystemKit. All rights reserved.
 * Copyright (C) 2014-2017  beltex <https://github.com/beltex>
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
import IOKit
import Foundation

/**
    Battery statistics for macOS, read-only.
    [Apple Battery](http://www.apple.com/batteries)
 
    - Version: `1.0.0`
    - Authors: `ChangYeop-Yang`
    - NOTE: None of this will work for iOS as I/O Kit is a private framework there
*/
public struct SKIOBattery {
    
    // MARK: - Enum
    public enum TemperatureUnit {
        case celsius
        case fahrenheit
        case kelvin
    }
    
    /// Battery property keys. Sourced via 'ioreg -brc AppleSmartBattery'
    fileprivate enum Key: String {
        
        case ACPowered        = "ExternalConnected"
        case Amperage         = "Amperage"
        
        /// Current charge
        case CurrentCapacity  = "CurrentCapacity"
        case CycleCount       = "CycleCount"
        
        /// Originally DesignCapacity == MaxCapacity
        case DesignCapacity   = "DesignCapacity"
        case DesignCycleCount = "DesignCycleCount9C"
        case FullyCharged     = "FullyCharged"
        case IsCharging       = "IsCharging"
        
        /// Current max charge (this degrades over time)
        case MaxCapacity      = "MaxCapacity"
        case Temperature      = "Temperature"
        
        /// Time remaining to charge/discharge
        case TimeRemaining    = "TimeRemaining"
    }
    
    // MARK: - Object Properties
    fileprivate var service: io_service_t = io_service_t.zero
    
    /// Name of the battery IOService as seen in the IORegistry
    fileprivate static let IOSERVICE_BATTERY: String = "AppleSmartBattery"
    
    // MARK: - Initalize
    public init() { NSLog("[SKBattery] Initalize") }
}

// MARK: - Public Extension SKBattery
public extension SKIOBattery {
    
    /**
        Open a connection to the battery.
    
        - Returns: kIOReturnSuccess on success.
    */
    mutating func open() -> kern_return_t {
        
        if self.service != io_service_t.zero {
            
            #if DEBUG
                print("WARNING - \(#file):\(#function) - " + "\(SKIOBattery.IOSERVICE_BATTERY) connection already open")
            #endif
            
            return kIOReturnStillOpen
        }
        
        
        // TODO: Could there be more than one service? serveral batteries?
        self.service = IOServiceGetMatchingService(kIOMasterPortDefault,
                                                   IOServiceNameMatching(SKIOBattery.IOSERVICE_BATTERY))
        
        if self.service == io_service_t.zero {
            
            #if DEBUG
                print("ERROR - \(#file):\(#function) - " + "\(SKIOBattery.IOSERVICE_BATTERY) service not found")
            #endif
            
            return kIOReturnNotFound
        }
        
        return kIOReturnSuccess
    }
    
    
    /**
        Close the connection to the battery.

        - Returns:kIOReturnSuccess on success.
    */
    mutating func close() -> kern_return_t {
        
        let result = IOObjectRelease(self.service)
        
        // Reset this incase open() is called again
        self.service = io_service_t.zero
        
        #if DEBUG
            if result != kIOReturnSuccess {
                print("ERROR - \(#file):\(#function) - Failed to close")
            }
        #endif
        
        return result
    }
    
    /**
        Get the current capacity of the battery in mAh. This is essientally the current charge of the battery.
    
        - NOTE: [Ampere-hour](https://en.wikipedia.org/wiki/Ampere-hour)
        - Returns: `Int`
    */
    func currentCapacity() -> Int {
        
        let property = IORegistryEntryCreateCFProperty(self.service,
                                                       Key.CurrentCapacity.rawValue as CFString?,
                                                       kCFAllocatorDefault,
                                                       IOOptionBits.zero)
        
        guard let result = property?.takeUnretainedValue() as? Int else { return Int.min }
        
        return result
    }
    
    
    /**
        Get the current max capacity of the battery in mAh. This degrades over time from the original design capacity.

        - NOTE: [Ampere-hour](https://en.wikipedia.org/wiki/Ampere-hour)
        - Returns: `Int`
    */
    func maxCapactiy() -> Int {
        
        let property = IORegistryEntryCreateCFProperty(self.service,
                                                       Key.MaxCapacity.rawValue as CFString?,
                                                       kCFAllocatorDefault,
                                                       IOOptionBits.zero)
        
        guard let result = property?.takeUnretainedValue() as? Int else { return Int.min }
        
        return result
    }
    
    
    /**
        Get the designed capacity of the battery in mAh.
        This is a static value.
        The max capacity will be equal to this when new, and as it degrades over time, be less than this.

         - NOTE: [Ampere-hour](https://en.wikipedia.org/wiki/Ampere-hour)
         - Returns: `Int`
    */
    func designCapacity() -> Int {
        
        let property = IORegistryEntryCreateCFProperty(self.service,
                                                       Key.DesignCapacity.rawValue as CFString?,
                                                       kCFAllocatorDefault,
                                                       IOOptionBits.zero)
        
        guard let result = property?.takeUnretainedValue() as? Int else { return Int.min }
        
        return result
    }
    
    /**
        Get the current cycle count of the battery.

        - NOTE: [Charge Cycle](https://en.wikipedia.org/wiki/Charge_cycle)
        - Returns: `Int`
    */
    func cycleCount() -> Int {
        
        let property = IORegistryEntryCreateCFProperty(self.service,
                                                       Key.CycleCount.rawValue as CFString?,
                                                       kCFAllocatorDefault,
                                                       IOOptionBits.zero)
        
        guard let result = property?.takeUnretainedValue() as? Int else { return Int.min }
        
        return result
    }
    
    
    /**
        Get the designed cycle count of the battery.

        - Version: `1.0.0`
        - Authors: `ChangYeop-Yang`
        - NOTE: [Charge Cycle](https://en.wikipedia.org/wiki/Charge_cycle)
        - Returns: `Int`
    */
    func designCycleCount() -> Int {
        
        let property = IORegistryEntryCreateCFProperty(self.service,
                                                       Key.DesignCycleCount.rawValue as CFString?,
                                                       kCFAllocatorDefault,
                                                       IOOptionBits.zero)
        
        guard let result = property?.takeUnretainedValue() as? Int else { return Int.min }
        
        return result
    }
    
    
    /**
        Is the machine powered by AC? Plugged into the charger.
    
        - Returns: True if it is, False otherwise.
    */
    func isACPowered() -> Bool {
        
        let property = IORegistryEntryCreateCFProperty(self.service,
                                                       Key.ACPowered.rawValue as CFString?,
                                                       kCFAllocatorDefault,
                                                       IOOptionBits.zero)
        
        return property?.takeUnretainedValue() as? Bool ?? false
    }
    
    
    /**
        Is the battery charging?
    
        - Returns: True if it is, False otherwise.
    */
    func isCharging() -> Bool {
        
        let property = IORegistryEntryCreateCFProperty(self.service,
                                                       Key.IsCharging.rawValue as CFString?,
                                                       kCFAllocatorDefault,
                                                       IOOptionBits.zero)
        
        return property?.takeUnretainedValue() as? Bool ?? false
    }
    
    
    /**
        Is the battery fully charged?
    
        - Returns: True if it is, False otherwise.
    */
    func isCharged() -> Bool {
        
        let property = IORegistryEntryCreateCFProperty(self.service,
                                                       Key.FullyCharged.rawValue as CFString?,
                                                       kCFAllocatorDefault,
                                                       IOOptionBits.zero)
        
        return property?.takeUnretainedValue() as? Bool ?? false
    }
    
    
    /**
        What is the current charge of the machine? As seen in the battery status menu bar. This is the currentCapacity / maxCapacity.
    
        - Returns: The current charge as a % out of 100.
    */
    func charge() -> Double {
        
        let maxCapactiy: Int = self.maxCapactiy()
        let currentCapacity: Int = self.currentCapacity()
        
        return floor(Double(currentCapacity) / Double(maxCapactiy) * 100.0)
    }
    
    
    /**
        The time remaining to full charge (if plugged into AC), or the time remaining to full discharge (running on battery).
        See also timeRemainingFormatted().
    
        - Returns: Time remaining in minutes.
    */
    func timeRemaining() -> Int {
        
        let property = IORegistryEntryCreateCFProperty(self.service,
                                                       Key.TimeRemaining.rawValue as CFString?,
                                                       kCFAllocatorDefault,
                                                       IOOptionBits.zero)
        
        guard let result = property?.takeUnretainedValue() as? Int else { return Int.min }
        
        return result
    }

    
    /**
        Same as timeRemaining(), but returns as a human readable time format, as seen in the battery status menu bar.

        - Returns: Time remaining string in the format [HOURS]: [MINUTES]
    */
    func timeRemainingFormatted() -> String {
        
        let time = self.timeRemaining()
        return NSString(format: "%d:%02d", time / 60, time % 60) as String
    }
    
    
    /**
        Get the current temperature of the battery.
        "MacBook works best at 50° to 95° F (10° to 35° C).
        Storage temperature: -4° to 113° F (-20° to 45° C)." - via Apple

        - NOTE: [Maximizing Performance](http://www.apple.com/batteries/maximizing-performance)
        - Returns: Battery temperature, by default in Celsius.
    */
    func temperature(_ unit: TemperatureUnit = .celsius) -> Double {
        
        let property = IORegistryEntryCreateCFProperty(self.service,
                                                       Key.Temperature.rawValue as CFString?,
                                                       kCFAllocatorDefault,
                                                       IOOptionBits.zero)
        
        guard var temperature = property?.takeUnretainedValue() as? Double else { return Double.zero }
                
        temperature = temperature / 100.0
        
        switch unit {
            case .celsius:
                // Do nothing - in Celsius by default
                // Must have complete switch though with executed command
                break
            
            case .fahrenheit:
                temperature = SKIOBattery.toFahrenheit(temperature)
            
            case .kelvin:
                temperature = SKIOBattery.toKelvin(temperature)
        }
        
        return ceil(temperature)
    }
}

// MARK: - FilePrivate Extension SKBattery
fileprivate extension SKIOBattery {
    
    /**
        Celsius to Fahrenheit
    
        - Parameters:
            - temperature: Temperature in Celsius
        - NOTE: [Fahrenheit](https://en.wikipedia.org/wiki/Fahrenheit#Definition_and_conversions)
        - Returns: Temperature in Fahrenheit
    */
    static func toFahrenheit(_ temperature: Double) -> Double {
        return (temperature * 1.8) + 32
    }

    /**
        Celsius to Kelvin
    
        - NOTE: [Kelvin](https://en.wikipedia.org/wiki/Kelvin)
        - Parameters:
            - temperature: Temperature in Celsius
        - Returns: Temperature in Kelvin
    */
    static func toKelvin(_ temperature: Double) -> Double {
        return temperature + 273.15
    }
}
#endif
