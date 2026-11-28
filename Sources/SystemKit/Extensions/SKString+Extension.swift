/*
 * Copyright (c) 2024 Universal-SystemKit. All rights reserved.
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

// MARK: - Public Extension String
public extension String {
    
    var kCFString: CFString { return self as CFString }
    
    var kCString: UnsafePointer<CChar>? { return (self as NSString).cString(using: String.Encoding.utf8.rawValue) }
    
    var base64EncodedString: String? { return self.data(using: .utf8)?.base64EncodedString() }
    
    var base64EncodedData: Data? { return self.data(using: .utf8)?.base64EncodedData() }
    
    var base64DecodedString: String? {
        
        guard let rawData = Data(base64Encoded: self) else { return nil }
        
        return String(data: rawData, encoding: .utf8)
    }
    
    var base64DecodedData: Data? { return Data(base64Encoded: self) }
    
    var kNSNotificationName: NSNotification.Name { return NSNotification.Name(self) }
    
    var kNotificationName: Notification.Name { return Notification.Name(self) }
}
