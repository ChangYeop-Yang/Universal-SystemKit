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

import Foundation

#if os(macOS) || os(iOS)
// MARK: - Struct With Universal Platform
public struct SKSystemMachineUsageMemeoryResult: Codable {
    
    // MARK: Float Proeprties
    
    public let usage: Float
    
    public let total: Float
}

public struct SKSystemApplicationVersionResult: Codable {
    
    // MARK: String Properties
    
    public let release: String
    
    public let bundle: String
}

public struct SKSystemMachineSystemResult: Codable {
    
    // MARK: String Proeprties
    
    /// Name of the operating system implementation
    public let operatingSystemName: String
    
    /// Release level of the operating system
    public let operatingSystemRelease: String
    
    /// Version level of the operating system.
    public let operatingSystemVersion: String
    
    /// Network name of this machine
    public let machineNetworkNodeName: String
    
    /// Machine hardware platform
    public let machineHardwarePlatform: String
}
#endif

#if os(macOS)
// MARK: - Enum With macOS Platform
public enum SKTranslatedRosettaResult: Int32 {
    
    /// Error Occurs
    case error = -1
    
    /// Native Process
    case native = 0
    
    /// Translated Process
    case translated = 1
}

@available(macOS 10.12, *)
public enum macOSSystemVersion: String {
    
    case Sierra = "Sierra"
    
    case HighSierra = "High Sierra"
    
    case Mojave = "Mojave"
    
    case Catalina = "Catalina"
    
    case BigSur = "BigSur"
    
    case Monterey = "Monterey"
    
    case Ventura = "Ventura"
    
    // MARK: Enum Computed Properties
    public var name: String { return String(format: "macOS %@", self.rawValue) }
}

// MARK: - Struct With macOS Platform
public struct SKDisplayOutputUnitResult: Codable {
    
    // MARK: Integer Properties
    
    /// The window number of the window’s window device.
    public let windowNumber: Int
    
    /// the bit depth of the window’s raster image (2-bit, 8-bit, and so forth)
    public var bitsPerSample: Optional<Int> = nil
    
    // MARK: Double Properties
    
    /// A screen resolution width value.
    public var frameWidth: Optional<Double> = nil
    
    /// A screen resolution height value.
    public var frameHeight: Optional<Double> = nil
    
    /// A raster screen resolution width value.
    public var rasterWidth: Optional<Double> = nil
    
    /// A raster screen resolution height value.
    public var rasterHeight: Optional<Double> = nil
    
    // MARK: String Properties
    
    /// The name of the window’s color space.
    public var colorSpaceName: Optional<String> = nil
    
    // MARK: Bool Properties
    
    /// The display device is a screen.
    public var isScreen: Optional<Bool> = nil
    
    /// The display device is a printer.
    public var isPrinter: Optional<Bool> = nil
}
#endif
