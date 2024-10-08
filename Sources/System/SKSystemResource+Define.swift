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
import Foundation

// MARK: - Struct
public struct SKMemoryResourceInfo: Codable {
    
    /// Using Total RAM `[% Percentage]`
    public let value: Double
    
    /// Efficiently your memory is serving your processing needs `[% Percentage]`
    public let pressureValue: Double

    /// The amount of memory being used by apps
    public let appValue: Double
    
    /// Memory required by the system to operate. This memory can’t be cached and must stay in RAM, so it’s not available to other apps
    public let wiredValue: Double
    
    /// The amount of memory that has been compressed to make more RAM available
    public let compressedValue: Double
}

public struct SKCPUResourceInfo: Codable {
    
    /// Using Total CPU `[% Percentage]`
    public let value: Double
    
    /// The percentage of CPU capability that’s being used by processes that belong to macOS. `[% Percentage]`
    public let systemValue: Double
    
    /// The percentage of CPU capability that’s being used by apps you opened, or by the processes opened by those apps. `[% Percentage]`
    public let userValue: Double
    
    /// The percentage of CPU capability that’s not being used. `[% Percentage]`
    public let idleValue: Double
}

public struct SKDiskSpaceResult: Codable {
    
    public let totalSpace: Int64
    
    public let freeSpace: Int64
    
    public let usedSpace: Int64
}
#endif
