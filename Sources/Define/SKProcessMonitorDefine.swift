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

// MARK: - Enum
public enum SKProcessMonitorFilterFlag {
    
    /// - NOTE: [exit - System Call](https://en.wikipedia.org/wiki/Exit_(system_call))
    case exit
    
    /// - NOTE: [fork - System Call](https://en.wikipedia.org/wiki/Fork_(system_call))
    case fork
    
    /// - NOTE: [exec - System Call](https://en.wikipedia.org/wiki/Exec_(system_call))
    case exec
    
    // MARK: Enum Properties
    public var define: UInt32 {
        
        switch self {
        /// process exec'd: `0x20000000`
        case .exec:
            return UInt32(NOTE_EXEC)
        
        /// Process Exited: `0x80000000`
        case .exit:
            return NOTE_EXIT
        
        /// process forked: `0x40000000`
        case .fork:
            return UInt32(NOTE_FORK)
        }
    }
}
#endif
