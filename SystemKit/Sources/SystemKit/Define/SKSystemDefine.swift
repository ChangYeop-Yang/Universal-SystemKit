/*
 * Copyright (c) 2022 ChangYeop-Yang. All rights reserved.
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

// MARK: - Enum With macOS Platform
#if os(macOS)
public enum TranslatedRosettaResult: Int32 {
    
    // MARK: Enum Properties
    case error = -1
    case native = 0
    case translated = 1
}

@available(macOS 10.12, *)
public enum macOSVersion: String {
    
    // MARK: Enum Properties
    case Sierra     = "Sierra"
    case HighSierra = "High Sierra"
    case Mojave     = "Mojave"
    case Catalina   = "Catalina"
    case BigSur     = "BigSur"
    case Monterey   = "Monterey"
    case Ventura    = "Ventura"
    
    // MARK: Enum Computed Properties
    public var name: String { return String(format: "macOS %@", self.rawValue) }
}
#endif

// MARK: - Enum With iOS Platform
#if os(iOS)
#endif
